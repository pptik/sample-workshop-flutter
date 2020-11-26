import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workshop_du_di_simple/sensor_model.dart';

class HomeView extends StatefulWidget{
  _HomeViewState createState()=> _HomeViewState();
}

class _HomeViewState extends State<HomeView>{
  List<SensorModel> _list = new List();
  List<String> _sensor = ['Humidity','Temperature'];
  final _random = new Random();
  Widget userList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.transparent,
      ),
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(_list[index].value,
                    style: TextStyle(
                        color: Colors.black87, fontSize: 13, letterSpacing: .3)),
                SizedBox(
                  height: 6,
                ),
                Text('${_list[index].timestamp}',
                    style: TextStyle(
                        color: Colors.black87, fontSize: 13, letterSpacing: .3)),
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
      body:Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context,int index){
                  return userList(context, index);
                },
              ),
            )
          ],
        ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          randomSensor();
        },
      ),
    );
    throw UnimplementedError();
  }

  void randomSensor(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE,d MMM yyyy, HH:mm:ss a').format(now);
    var sensor = _sensor[_random.nextInt(_sensor.length)];
    print(sensor);
    setState(() {
      if(sensor == 'Humidity'){
        _list.insert(0,SensorModel(sensor,randomValue(sensor),formattedDate));
      }else{
        _list.insert(0,SensorModel(sensor,randomValue(sensor),formattedDate));
      }
    });
  }

  String randomValue(String sensor){
    int min,max;
    if(sensor == 'Humidity'){
      min = 0;
      max =1000;
      return '${min + _random.nextInt(max-min)} g/m\u00B3';
    }else{
      min = 20;
      max =40;
      return '${min + _random.nextInt(max-min)}°C';
    }
  }


}