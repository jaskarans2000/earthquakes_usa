import 'dart:convert';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async{
  Map _data=await getJSON();
  List _features=_data["features"];
  runApp(
    new MaterialApp(

    home: new Scaffold(
      appBar: new AppBar(
      title: new Text("Quakes"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _features.length,

          itemBuilder: (BuildContext context,int position){
            var format=new intl.DateFormat.yMMMMd("en_US").add_jm();
            var date=format.format(DateTime.fromMicrosecondsSinceEpoch(_features[position]["properties"]["time"]*1000,isUtc: true));

            return new Column(
              children: <Widget>[
                Divider(height: 6.0,),
                ListTile(
                  title: new Text(
                      "$date",
                       style: new TextStyle(color: Colors.orange,fontSize: 19.9,fontWeight: FontWeight.w600),
                  ),
                  subtitle: new Text(
                    "${_features[position]["properties"]["place"]}",
                    style: new TextStyle(fontStyle: FontStyle.italic),
                  ),
                  leading: new CircleAvatar(
                    radius: 24.5,
                    backgroundColor: Colors.green,
                    child: new Text(
                      "${_features[position]["properties"]["mag"]}",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),onTap: ()=> changeTap(context,position),
                )
              ],
            );

          })
    )
    )
  );
}

changeTap(BuildContext context, int position) async{
  Map _map=await getJSON();
  List _list=_map["features"];
  AlertDialog alertDialog=new AlertDialog(
    contentPadding: const EdgeInsets.all(3.3),
    title: new Text("Quakes"),
    actions: <Widget>[
      Column(
        children: <Widget>[
          Text("${_list[position]["properties"]["title"]}"),
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),

    ],

  );
  showDialog(context: context,builder: (context){
    return alertDialog;
  });
}
Future<Map> getJSON() async{
  String apiURL="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response=await http.get(apiURL);
  return json.decode(response.body);
}