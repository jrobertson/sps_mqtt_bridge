#!/usr/bin/env ruby

# file: sps_mqtt_bridge.rb

require 'mqtt'
require 'sps-sub'
require 'sps-pub'
require 'open-uri' # used sps_to_http
require 'timeout'  # used sps_to_http



class SpsMqttBridge

  def initialize(mqtt: {address: 'mqtt', port: '1883'},
     sps:{host: 'sps', address: host, port: '59000'},
                 sps2:{address: 'sps', port: '59000'})
    @mqtt, @sps, @sps2 = mqtt, sps, sps2
  end

  def mqtt_to_sps(topic: '#')

    MQTT::Client.connect(@mqtt[:address], @mqtt[:port]) do |client|

      client.get(topic) do |t, message|
        SPSPub.notice [t, message].join(': '),
                                address: @sps[:address], port: @sps[:port]
      end
    end
  end

  def sps_to_mqtt(topic: '#')

    SPSSub.new(host: @sps[:address], port: @sps[:port]).\
                                         subscribe(topic: topic) do |message,t|

      MQTT::Client.connect(@mqtt[:address], @mqtt[:port]) do |client|
        client.publish(t, message)
      end

    end
  end

  def sps_to_sps(topic: '#')

    SPSSub.new(host: @sps[:address], port: @sps[:port]).\
                                         subscribe(topic: topic) do |message,t|

      SPSPub.notice [t, message].join(': '),
                                   address: @sps2[:address], port: @sps2[:port]
    end
  end

  def sps_to_http(topic: '#', url: '', timeout: 5, \
                                             http_auth: ["user", "password"])

    sps = SPSSub.new(host: @sps[:address], port: @sps[:port])

    sps.subscribe(topic: topic) do |message,t|

      begin

        Timeout::timeout(timeout){

          ipaddr = url[/https?:\/\/([^\/]+)/,1]
          ip_address = block_given? ? yield(ipaddr) || ipaddr : ipaddr
          full_url = url.sub(/(https?:\/\/)([^\/]+)/,'\1' + ip_address).\
                                      sub('$topic', t).sub('$msg', message)

          buffer = URI.open(full_url, read_timeout: timeout,\
                      http_basic_authentication: http_auth).read

        }
      rescue Timeout::Error => e

        puts 'connection timed out'

      rescue OpenURI::HTTPError => e

        puts '400 bad request'

      end

    end
  end
end

if __FILE__ == $0 then

  bridge = SpsMqttBridge.new
  bridge.mqtt_to_sps
end
