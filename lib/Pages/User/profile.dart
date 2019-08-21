import 'package:flutter/material.dart';
import 'package:wup/Pages/Store/store.dart';
import 'package:wup/Pages/User/flips.dart';
import 'dart:core';

class ProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{

  Widget ProfilePage;
  String userImg;
  String imageString;
  TabController _controller;


  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }



  Widget profilePageBuilder(){
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                child: Container(
//              margin: EdgeInsets.only(top:50),
                  width: double.infinity,
                  height: 300,
                  child: FittedBox(
                    child: Image.network('https://media.vanityfair.com/photos/5c0ef15ae2641b48c86501e9/master/pass/Megan-Fox-MeToo-Story%20(1).jpg'),
                    fit: BoxFit.fill,
                  ),
                  //            height: 300,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0),
//                    bottomRight: Radius.circular(50.0)),
//              ),
                ),
              ),
              Center(
                child: Container(
//            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                  margin: const EdgeInsets.only(top:250),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage("https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg",
                              scale: 1
                          ),
                        ),
                      ),
                      Text("Meghan Fox", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text("@hotie_meghan")
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.only(top:10),
//            padding: const EdgeInsets.only(left: 40, right: 40),
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
                   Text("Followers", style: TextStyle(fontSize: 15.0)),
                 ],
                ),
                Column(
                  children: <Widget>[
                    Text("43", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text("Following", style: TextStyle(fontSize: 15.0)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("40", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text("Posts", style: TextStyle(fontSize: 15.0)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(8.0),
              elevation: 0.0,
              highlightColor: Colors.redAccent,
              focusColor: Colors.redAccent,
              textColor: Colors.white,
              color: Colors.red,
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.file_upload, size: 20,),
                  ),
                  Text("Upload", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Container(
//            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  icon: Icon(Icons.camera),
                  text: 'My Flips',
                ),
                Tab(
                  icon: Icon(Icons.ondemand_video),
                  text: 'My Series',
                )
              ],
            ),
          ),
          Expanded(
//            height: 650,
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                Container(
                  child: Column(
                     children: List.generate(2, (index) {
                        return Center(
                           child: Card(
                             child: Row(
                               children: <Widget>[
                                 Container(
                                   width: 30,
                                   height:30,
                                   child: Image.network("https://images-na.ssl-images-amazon.com/images/I/61daG4%2BsNPL._UL1000_.jpg"),
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                        );
                      }
                     ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/61daG4%2BsNPL._UL1000_.jpg"),
                    ),
                    title: Text('Nike Shoes Black'),
                    trailing: Text("1,000"),
                  ),
                ),
              ],
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
      body: profilePageBuilder()
    );
  }
}