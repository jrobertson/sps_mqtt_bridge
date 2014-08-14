#!/usr/bin/env ruby

# file: sps_mqtt_bridge.rb

require 'mqtt'
require 'simplepubsub'
require 'sps-pub'


class SpsMqttBridge

  def initialize(mqtt: {address: 'mqtt', port: '1883'}, 
                                        sps:{address: 'sps', port: '59000'})
    @mqtt, @sps = mqtt, sps
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

    SimplePubSub::Client.connect(@sps[:address], @sps[:port]) do |client|

      client.get(topic) do |t, message|

        MQTT::Client.connect(@mqtt[:address], @mqtt[:port]) do |client|
          client.publish(t, message)
        end
      end
    end
  end
end

if __FILE__ == $0 then

  bridge = SpsMqttBridge.new
  bridge.mqtt_to_sps
end
