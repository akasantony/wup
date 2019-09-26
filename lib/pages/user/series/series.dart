import 'package:flutter/material.dart';
import 'package:wup/Pages/User/video.dart';
import 'dart:core';

class SeriesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> with SingleTickerProviderStateMixin{

  Widget seriesPage;


  @override
  void initState() {
    super.initState();

  }



  Widget seriesPageBuilder(){
    return Container(
      margin: EdgeInsets.only(top:40),
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Container(
            child: Text("#SeriesName", style: TextStyle(fontSize: 30),),
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.only(top:10),
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white70
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("123", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text("Videos", style: TextStyle(fontSize: 15.0)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("43", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text("Views", style: TextStyle(fontSize: 15.0)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("40", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Icon(Icons.favorite_border, size: 20,),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(),
                      ),
                    );
                  },
                  title: Text("Video title $index"),
                  leading: Text("Leading text"),
                  subtitle: Container(
                    margin: EdgeInsets.only(top:10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.favorite_border),
                              Text("12k")
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.comment),
                              Text("13")
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.visibility),
                              Text("124k")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: seriesPageBuilder(),
    );
  }
}