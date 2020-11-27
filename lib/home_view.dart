import 'dart:math';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workshop_du_di_simple/sensor_model.dart';

class HomeView extends StatefulWidget {
  String user;
  String pass;
  String vhost;

  HomeView(this.user, this.pass, this.vhost);

  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<SensorModel> _list = new List();
  List<String> _sensor = ['Humidity', 'Temperature'];
  final _random = new Random();
  bool rmq_status = true;
  String payload = "";
  String soil_serial = "";
  String soil_value = "";
  String soil_status = "";

  String pompa_serial = "";
  String pompa_value = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consumeSoil();
  }
  void consumeSoil(){
    try{
      ConnectionSettings settings = new ConnectionSettings(
          host: "rmq2.pptik.id",
          authProvider: new PlainAuthenticator(widget.user, widget.pass),
          virtualHost: widget.vhost
      );

      Client client = new Client(settings: settings);

      client.errorListener((error) {print("dsa${error.toString()}"); });
      client.connect().catchError((Object error){
        print("dsa ${error.toString()}");
        setState(() {
          rmq_status = false;
        });
      });
      client.connect().then((value){
        setState(() {
          rmq_status = true;
        });
      });

      client
          .channel()
          .then((Channel channel) => channel.queue("Aktuator", durable: true))
          .then((Queue queue) => queue.consume())
          .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
        print("test ${message.payloadAsString}");
        setValuePompa(message.payloadAsString);
        setState(() {
          payload = message.payloadAsString;
        });
      }));
      client
          .channel()
          .then((Channel channel) => channel.queue("Log", durable: true))
          .then((Queue queue) => queue.consume())
          .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
        print("test ${message.payloadAsString}");
        setValueSoil(message.payloadAsString);
        setState(() {
          payload = message.payloadAsString;
        });
      }));
    }on Exception catch(e){
      print("[x]Received False ${e.toString()}");
    }

  }
  Widget userList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.transparent,
      ),
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _list[index].title,
                  style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(_list[index].value,
                    style: TextStyle(
                        height: 1.5,
                        color: Colors.black54,
                        fontSize: 18,
                        letterSpacing: .3)),
                SizedBox(
                  height: 6,
                ),
                Text('${_list[index].timestamp}',
                    style: TextStyle(
                        height: 2.5,
                        color: Colors.black45,
                        fontSize: 13,
                        letterSpacing: .3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Application"),
      ),
      body: rmq_status ? Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return userList(context, index);
              },
            ),
          )
        ],
      ):
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("RMQ Not Conneceted"),
            Text("Please Check Credential")
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  void randomSensor(String title,String serial,String value) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE,d MMM yyyy, HH:mm:ss a').format(now);
    var sensor = _sensor[_random.nextInt(_sensor.length)];
    print(sensor);
    setState(() {
      if (sensor == 'Humidity') {
        _list.insert(
            0, SensorModel(title,serial, randomValue(value), formattedDate));
      } else {
        _list.insert(
            0, SensorModel(title,serial, randomValue(value), formattedDate));
      }
    });
  }

  String randomValue(String sensor) {

    if (sensor == 'Humidity') {
      return '${sensor} g/m\u00B3';
    } else {

      return 'Status : $sensor';
    }
  }

  void setValuePompa(String message) {
    List<String> list = message.split("#");
    int cek_value = int.parse(list[1]);
    setState(() {
      pompa_serial = list[0];
      if (cek_value == 1) {
        pompa_value = 'ON';
      } else if (cek_value == 0) {
        pompa_value = 'OFF';
      }
      randomSensor("Pompa", pompa_serial, pompa_value);
    });
  }

  void setValueSoil(String message) {
    List<String> a = message.split("#");
    int cek = int.parse(a[1]);
    setState(() {
      soil_value = a[1];
      soil_serial = a[0];
      if (cek < 350) {
        soil_status = 'lembab';
      } else if (cek > 700) {
        soil_status = 'Kering';
      } else if (cek >= 350 && cek <= 700) {
        soil_status = 'Normal';
      }
      randomSensor("Soil", soil_serial,soil_value);
    });
  }

}
