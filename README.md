# Sending an SPS message via HTTP using the sps_mqtt_bridge gem

    require 'sps_mqtt_bridge'

    bridge = SpsMqttBridge.new host: '192.168.4.140', port: 59000
    bridge.sps_to_http(topic: 'rosa',  \
      url: "http://94.34.11.123/do/sps/publish?topic=$topic&msg=$msg", \
      http_auth: ['user', 'password'])


The above example shows how the sps_mqtt_bridge can be used to subscribe to an SPS topic, and have any received messages forwarded to a web server.

Notes:

1. The $topic and $msg variables are replaced with the actual string values within the URL
2. A block can be passed to the *sps_to_http()* method to allow the IP address used in the URL to be refreshed or updated when a new message is received
3. This example demonstrates publishing a message to a web server which uses basic http authentication. It should be able to publish to a web server which doesn't require authentication, although I haven't tested that as yet.

----------------------------

# Introducing the sps_mqtt_bridge gem

    require 'sps_mqtt_bridge'

    bridge = SpsMqttBridge.new
    bridge.mqtt_to_sps

The above example will subscribe to all topics on an MQTT broker at address 'mqtt' using port '1883' and publish the received messages to the SPS broker at address 'sps' using port '59000'.

To test the above code I used the following code:

**MQTT client**

    require 'mqtt'

    MQTT::Client.connect('mqtt') do |client|

      client.publish('test', "The time is: #{Time.now}")

    end

**SPS client**

<pre>
&lt;!DOCTYPE html&gt;
&lt;pre id="log"&gt;&lt;/pre&gt;
&lt;script&gt;
  // helper function: log message to screen
  function log(msg) {
    document.getElementById('log').innerText += msg + '\n';
  }

  // setup websocket with callbacks
  var ws = new WebSocket('ws://192.168.4.171:59000/');
  ws.onopen = function() {
    log('CONNECT');
    ws.send('subscribe to topic: #');
  };
  ws.onclose = function() {
    log('DISCONNECT');
  };
  ws.onmessage = function(event) {
    log('MESSAGE: ' + event.data);
  };
&lt;/script&gt;
</pre>

Note: *sps* in this example points to *192.168.4.171*.

## Resources

* [jrobertson/sps_mqtt_bridge](https://github.com/jrobertson/sps_mqtt_bridge)

sps mqtt bridge gem sps_mqtt_bridge
