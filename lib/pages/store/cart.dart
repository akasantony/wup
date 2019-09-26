import 'package:flutter/material.dart';
import 'package:wup/Pages/Store/store.dart';
import 'package:wup/Pages/User/profile.dart';
import 'dart:core';

class CartPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin{

  Widget CartPage;
  String userImg;
  String imageString;
  String _genderGroup;
  String _userGender;


  @override
  void initState() {
    super.initState();
  }

  void _genderSet(String value) {
    setState(() {
      _genderGroup = value;
      _userGender = value;
      print("Value $value");
    });
  }

  Widget CartPageWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
//            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Text("Shipping Address", style: TextStyle(fontSize: 25),),
          ),
          SizedBox(height: 20,),
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Text("Home", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blueGrey),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
//                    color: Colors.grey,
                          child: Radio(
                              activeColor: Colors.greenAccent,
                              value: 1,
                              groupValue: _genderGroup,
                              onChanged: (value) => _genderSet(value)
                          ),
                        ),
                      ],
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
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.delete, size:30,),
                          onPressed: null
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Text("Work", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blueGrey),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
//                    color: Colors.grey,
                          child: Radio(
                              activeColor: Colors.grey,
                              value: 1,
                              groupValue: _genderGroup,
                              onChanged: (value) => _genderSet(value)
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text("Akas Antony", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          child: Text("No 12", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          child: Text("12th Main Kodihalli", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          child: Text("HAL 2nd Stage", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          child: Text("Bangalore - 560065", style: TextStyle(fontSize: 15.0),),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text("Contact: 953870672", style: TextStyle(fontSize: 15.0),),
                        ),
                      ],
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.delete, size:30,),
                          onPressed: null
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_circle_outline),
                    ),
                    Container(
                      child: Text("Add Address")
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text("Select Items", style: TextStyle(fontSize: 25),),
            ),
          ),
          Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: false,
                      onChanged: null
                  ),
                  Text("Select All")
                ],
              ),
            ),
          ),
          Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: true,
                      onChanged: null
                  ),
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
                  Checkbox(
                      value: true,
                      onChanged: null
                  ),
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
                  Checkbox(
                      value: true,
                      onChanged: null
                  ),
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
                  Checkbox(
                      value: true,
                      onChanged: null
                  ),
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
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: () {},
              elevation: 0,
              child: Text("Place Order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
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
          child: CartPageWidget(),
        ),
      )
    );
  }
}