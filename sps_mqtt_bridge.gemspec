Gem::Specification.new do |s|
  s.name = 'sps_mqtt_bridge'
  s.version = '0.3.0'
  s.summary = 'Subscribes and re-publishes messages automatically from MQTT to SPS or to HTTP'
  s.authors = ['James Robertson']
  s.files = Dir['lib/sps_mqtt_bridge.rb']
  s.add_runtime_dependency('sps-pub', '~> 0.4', '>=0.4.1')
  s.add_runtime_dependency('sps-sub', '~> 0.3', '>=0.3.1')
  s.add_runtime_dependency('mqtt', '~> 0.3', '>=0.3.1')
  s.signing_key = '../privatekeys/sps_mqtt_bridge.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/sps_mqtt_bridge'
end
