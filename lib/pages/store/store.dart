import 'package:flutter/material.dart';
import 'package:wup/Pages/Store/cart.dart';
import 'package:wup/Pages/Store/product.dart';
import 'package:wup/Pages/Store/order.dart';
import 'dart:core';

class StorePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin{

  String userImg;
  String imageString;
  TabController _controller;


  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }



  Widget storePageWidget() {
    return Container(
//      width: 100.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 60.0,
                  width: 350.0,
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.search),
                      title: TextField(
                        decoration: const InputDecoration(hintText: 'Search merchandise...'),
                      ),
                      trailing: IconButton(icon: Icon(Icons.filter_list), onPressed: null),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),),
                    GestureDetector(
                      child: Icon(Icons.shopping_cart, color: Colors.grey, size: 40,),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
//            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  text: 'Store',
                ),
                Tab(
                  text: 'Orders',
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
                  child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(100, (index) {
                      return Center(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("${index + 1},000"),
                                  Icon(Icons.favorite)
                                ],
                              ),
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/61daG4%2BsNPL._UL1000_.jpg"),
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Add to cart',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                      );
                    }),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => OrderPage(),
                        ),
                      );
                    },
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
      body: Container(
        padding: EdgeInsets.only(top: 50.0),
        child: storePageWidget(),
      ),
    );
  }
}