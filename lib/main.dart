import 'package:flutter/material.dart';
import 'mqtt.dart';
// import 'package:get_ip/get_ip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  mqtt myMqttt;
  String listeningTopic = "";
  String lastEvent = "";
  TextEditingController topicController = new TextEditingController();
  TextEditingController msController = new TextEditingController();
  TextEditingController subTopicController = new TextEditingController();

  void publishMessage2Mqtt() {
    myMqttt.publishMessage(topicController.text, msController.text);
  }

  void onMqttEvent(String topic, String message) {
    setState(() {
      lastEvent = "\n\n>>" +
          new DateTime.now().toString() +
          "\n    from: " +
          topic +
          "\n   value: " +
          message +
          lastEvent;
    });
  }

  void setup() {
    myMqttt = mqtt(onMqttEvent);
    myMqttt.prepareMqttClient();
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  void mDNSSetup() async {
    // String ipAddress = await GetIp.ipAddress;
    // print(">>My IP>>"+ipAddress);
  }

  @override
  Widget build(BuildContext context) {
//    setup();
//     mDNSSetup();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
//        margin: EdgeInsets.all(30),
        padding: EdgeInsets.all(20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              Text("Subscribe:  "),
              new Expanded(child: TextField(controller: subTopicController)),
              new IconButton(
                icon: new Icon(Icons.cast_connected, color: Colors.green),
                iconSize: 40.0,
                onPressed: () {
                  myMqttt.addTopicToSubscribe(subTopicController.text);
                  setState(() {
                    listeningTopic =
                        '[' + subTopicController.text + ']  ' + listeningTopic;
                  });
                },
              ),
            ]),
            new RichText(
              text: new TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  new TextSpan(
                      text: 'Subscribing to: ',
                      style: new TextStyle(fontWeight: FontWeight.bold)),
                  new TextSpan(text: '$listeningTopic'),
                ],
              ),
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Last message                  ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  new IconButton(
                    icon: new Icon(Icons.clear, color: Colors.red),
                    iconSize: 40.0,
                    onPressed: () {
                      setState(() {
                        lastEvent = "";
                      });
                    },
                  ),
                  Text("Clear all message"),
                ]),
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: Text(
                  '$lastEvent',
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Topic:  "),
                new Expanded(child: TextField(controller: topicController)),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Message:  "),
                new Expanded(
                    child: TextField(
                        controller: msController,
                        keyboardType: TextInputType.multiline,
                        minLines:1,
                        maxLines: 3)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: publishMessage2Mqtt,
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
