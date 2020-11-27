import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workshop_du_di_simple/home_view.dart';

class FormView extends StatefulWidget{
  _FormViewState createState()=> _FormViewState();
}

class _FormViewState extends State<FormView>{
  TextEditingController user_queue = TextEditingController();
  TextEditingController pass_queue = TextEditingController();
  TextEditingController vhost_queue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("RMQ Connection"),
      ),
      body:  Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            TextField(
              minLines: 1,
              maxLines: 2,
              controller:user_queue,
              decoration: InputDecoration(
                hintText: "User Queue",
                labelText: 'User Queue',
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              minLines: 1,
              maxLines: 2,
              controller:pass_queue,
              decoration: InputDecoration(
                hintText: "Pass Queue",
                labelText: 'Pass Queue',
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              minLines: 1,
              maxLines: 2,
              controller:vhost_queue,
              decoration: InputDecoration(
                hintText: "Vhost Queue",
                labelText: 'Virtual Host Queue',
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.lightBlueAccent,
              child: Text("Connect",style: TextStyle(color: Colors.white),),
              onPressed: (){
                print("connection");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView(user_queue.text, pass_queue.text, vhost_queue.text)),
                );
              },
            )
          ],
        ),
      )
    );
    throw UnimplementedError();
  }
  
}