import 'package:flutter/material.dart';
import 'package:wup/Pages/Store/store.dart';
import 'package:wup/Pages/User/profile.dart';
import 'dart:core';

class OrderPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin{

  Widget orderPage;
  String userImg;
  String imageString;
  String _genderGroup;
  String _userGender;


  @override
  void initState() {
    super.initState();
  }


  Widget orderPageWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              child: Text("Order Details", style: TextStyle(fontSize: 25),),
            ),
          ),
          Container(
            child: Card(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text("Order Date: 25-Apr-2019"),
                  ),
                  Container(
                    child: Text("Item Count: 3"),
                  ),
                  Container(
                    child: Text("Order Status: Received"),
                  ),
                  Container(
                    child: Text("Order Tracking ID: #13243524"),
                  ),
                  Container(
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Total:  "),
                          Text("30k"),
                          Icon(Icons.favorite_border)
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
          Center(
//            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Text("Delivering To", style: TextStyle(fontSize: 25),),
          ),
          SizedBox(height: 20,),
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Text("Home", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blueGrey),),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text("Akas Antony", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          child: Text("No 10", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          child: Text("1st B Main Road", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          child: Text("8th Block Koramangala", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          child: Text("Bangalore - 560095", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text("Contact: 953870672", style: TextStyle(fontSize: 15.0),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text("Items", style: TextStyle(fontSize: 25),),
            ),
          ),
          Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/61daG4%2BsNPL._UL1000_.jpg"),
                  ),
                  Column(
                    children: <Widget>[
                      Text("Nike Running Shoes"),
                      Row(
                        children: <Widget>[
                          Text("1,000"),
                          Icon(Icons.favorite)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage("https://assets.myntassets.com/h_1440,q_100,w_1080/v1/assets/images/6841945/2018/10/7/b5cf3d4e-a798-48b5-a5c1-824be172f41e1538892108930-adidas-ERDIGA-40-Men-7361538892108770-1.jpg"),
                  ),
                  Column(
                    children: <Widget>[
                      Text("Adidas Sneakers"),
                      Row(
                        children: <Widget>[
                          Text("2,000"),
                          Icon(Icons.favorite)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage("https://assets.myntassets.com/h_1440,q_100,w_1080/v1/assets/images/6841945/2018/10/7/b5cf3d4e-a798-48b5-a5c1-824be172f41e1538892108930-adidas-ERDIGA-40-Men-7361538892108770-1.jpg"),
                  ),
                  Column(
                    children: <Widget>[
                      Text("Adidas Sneakers"),
                      Row(
                        children: <Widget>[
                          Text("2,000"),
                          Icon(Icons.favorite)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage("https://assets.myntassets.com/h_1440,q_100,w_1080/v1/assets/images/6841945/2018/10/7/b5cf3d4e-a798-48b5-a5c1-824be172f41e1538892108930-adidas-ERDIGA-40-Men-7361538892108770-1.jpg"),
                  ),
                  Column(
                    children: <Widget>[
                      Text("Adidas Sneakers"),
                      Row(
                        children: <Widget>[
                          Text("2,000"),
                          Icon(Icons.favorite)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
            child: RaisedButton(
              color: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: () {},
              elevation: 0,
              child: Text("Cancel Order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 40.0),
            child: orderPageWidget(),
          ),
        )
    );
  }
}