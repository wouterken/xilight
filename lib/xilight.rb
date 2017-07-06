require "xilight/version"

module Xilight
  require 'socket'
  require 'json'
  require 'timeout'

  class Yeelight

    attr_reader :id

    def initialize(location:, rgb: 0, hue: 0, sat: 0, ct: 0, color_mode: 0, bright: 0, power: :on, id:, name:, **kwargs)
      @id         = id
      @rgb        = rgb.to_i
      @hue        = hue.to_i
      @sat        = sat.to_i
      @ct         = ct.to_i
      @color_mode = color_mode.to_i
      @bright     = bright.to_i
      @power      = power.to_sym
      @location   = location
      @name       = name
      @host       = location[/(?:\d+\.)+\d+/]
      @port       = location[/(?!<:)\d+$/]
    end

    def request(cmd)
      begin
        Timeout.timeout(0.5) do
          s = TCPSocket.open(@host, @port)
          s.puts "#{JSON.generate(cmd)}\r\n"
          data = s.gets.chomp
          s.close
          JSON.parse(data)
        end
      rescue Timeout::Error
        puts "Yeelight connection timed out. Yeelight not accessible"
      end
    end

    # This method is used to retrieve current property of smart LED.
    def get_prop(values)
      request({id: 1,method: 'get_prop', params: values})
    end

    # This method is used to change the color temperature of the smart LED.
    def set_ct_abx(ct_value, effect='smooth', duration=200)
      request({id: 2,method: 'set_ct_abx', params: [ct_value,effect,duration]})
    end

    # This method is used to change the color temperature of the smart LED.
    def ct_abx=ct_value
      set_ct_abx(ct_value)
    end

    # This method is used to change the color RGB of the smart LED.
    # Expects an integer representing a hex triplet (e.g. 0xFFFFFF )
    def set_rgb(rgb_value, effect='smooth', duration=200)
      request({id: 3,method: 'set_rgb', params: [rgb_value,effect,duration]})
    end

    # This method is used to change the color RGB of the smart LED.
    # Expects an integer representing a hex triplet (e.g. 0xFFFFFF )
    def rgb=rgb_value
      set_rgb(rgb_value)
    end

    # This method is used to change the color HSV of the smart LED.
    def set_hsv(hue, sat, effect='smooth', duration=200)
      request({id: 4,method: 'set_hsv', params: [hue,sat,effect,duration]})
    end

    # This method is used to change the color HSV of the smart LED.
    def hsv=hue
      set_hsv(hue)
    end

    # This method is used to change the brightness of the smart LED.
    def set_bright(brightness, effect='smooth', duration=200)
      request({id: 5,method: 'set_bright', params: [brightness,effect,duration]})
    end

    # This method is used to change the brightness of the smart LED.
    def bright=brightness
      set_bright(brightness)
    end

    # This method is used to switch on or off the smart LED (software managed on/off).
    def set_power(power, effect='smooth', duration=200)
      request({id: 6,method: 'set_power', params: [power,effect,duration]})
    end

    # This method is used to switch on or off the smart LED (software managed on/off).
    def power=power
      set_power(power)
    end

    # This method is used to toggle the smart LED.
    def toggle
      request({id: 7,method: 'toggle', params: []})
    end

    # This method is used to save the current state of smart LED in persistent memory.
    # If user powers off and then powers on the smart LED again (hard power reset),
    # the smart LED will show last the saved state.
    def set_default
      request({id: 8,method: 'set_default', params: []})
    end

    # This method is used to start a color flow. Color flow is a series of smart
    # LED visible state changes. It can be either brightness changing, color changing
    # or color temperature changing
    def start_cf(count, action, flow_expression)
      request({id: 9,method: 'set_power', params: [count,action,flow_expression]})
    end

    # This method is used to stop a running color flow.
    def stop_cf
      request({id: 10,method: 'stop_cf', params: []})
    end

    # This method is used to set the smart LED directly to specified state. If
    # the smart LED is off, then it will first turn on the smartLED  and then
    # apply the specified command.
    def set_scene(classe, val1, val2)
      request({id: 11,method: 'set_scene', params: [classe,val1,val2]})
    end

    # This method is used to start a timer job on the smart LED
    def cron_add(type, value)
      request({id: 12,method: 'cron_add', params: [type,value]})
    end

    # This method is used to retrieve the setting of the current cron job
    # of the specified type
    def cron_get(type)
      request({id: 13,method: 'cron_get', params: [type]})
    end

    # This method is used to stop the specified cron job.
    def cron_del(type)
      request({id: 14,method: 'cron_del', params: [type]})
    end

    # This method is used to change brightness, CT or color of a smart LED
    # without knowing the current value, it's mainly used by controllers.
    def set_adjust(action, prop)
      request({id: 15,method: 'set_adjust', params: [action,prop]})
    end

    # This method is used to name the device. The name will be stored on the
    # device and reported in the discovery response. Users can also read the device name
    # through the “get_prop” method.
    def set_name(name)
      request({id: 16,method: 'set_name', params: [name]})
    end

    def name=(name)
      set_name(name)
    end

    # This method is used to switch on the smart LED
    def on
      set_power("on", "smooth",1000)
    end

    # This method is used to switch off the smart LED
    def off
      set_power("off", "smooth",1000)
    end


    # This method is used to discover a smart LED on the local network
    def self.discover
      host = "239.255.255.250"
      port = 1982
      socket  = UDPSocket.new(Socket::AF_INET)

      payload = []
      payload << "M-SEARCH * HTTP/1.1\r\n"
      payload << "HOST: #{host}:#{port}\r\n"
      payload << "MAN: \"ssdp:discover\"\r\n"
      payload << "ST: wifi_bulb"

      socket.send(payload.join(), 0, host, port)

      devices = []
      begin
        Timeout.timeout(0.5) do
          loop do
            devices << socket.recvfrom(2048)
          end
        end
      rescue Timeout::Error => ex
        ex
      end
      devices.map do |(description, params)|
        options = description.split("\r\n")
                   .select{|x| x.include?(":")}
                   .map{|x| x.split(":", 2) }
                   .map do |key, value|
                      [key.downcase.strip.gsub(/[^a-z]+/,"_").to_sym, value.strip]
                   end.to_h
        Yeelight.new(**options)
      end.uniq{|yl| yl.id }
    end
  end
end
