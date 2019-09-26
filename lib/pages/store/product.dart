import 'package:flutter/material.dart';
import 'package:wup/Templates/Store/Product/color_chooser.dart';
import 'package:wup/Templates/Store/Product/size.dart';
import 'package:wup/Templates/Store/Product/description.dart';
import 'package:wup/Templates/Store/Product/images.dart';
import 'dart:core';

class ProductPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin{

  ColorChooserTemplate colorChooserTemplate;
  ImageTemplate imageTemplate;
  SizeTemplate sizeTemplate;
  DescriptionTemplate descriptionTemplate;

  int _current = 0;

  var testData = {
    'title': 'Nike Running Shoes',
    'images': ["https://images-na.ssl-images-amazon.com/images/I/81kZmFGmevL._UX695_.jpg",
  "https://images-na.ssl-images-amazon.com/images/I/81kZmFGmevL._UX695_.jpg"],
    'colors': {'color_1': {'color_name': 'Red', 'color_value': '#FF0000'}, 'color_2': {'color_name': 'Green', 'color_value': '#00FF00'}},
    'quantity': [1, 2, 3, 4, 5, 6, 7, 8, 9],
    'size': ['S', 'M', 'XL'],
    'weight': '80kg',
    'description': 'Loren epsum',
  };



  @override
  void initState() {
    super.initState();
  }

  changeState(index){
    setState(() {
      _current = index;
    });
  }
  
  List<Widget> getProductMeta() {
    List<Widget> widgetList = List();
    for (var key in testData.keys) {
      switch (key){
        case 'colors':
          colorChooserTemplate = ColorChooserTemplate(testData[key]);
          widgetList.add(colorChooserTemplate.createTemplate());
          break;

        case 'title':
          widgetList.add(Container(
            margin: EdgeInsets.all(10),
            child: Text(testData[key], style: TextStyle(fontSize: 30),),
          ));
          break;

        case 'images':
          imageTemplate = ImageTemplate(testData[key]);
          widgetList.add(imageTemplate.createTemplate());
          break;

        case 'size':
          sizeTemplate = SizeTemplate(testData[key]);
          widgetList.add(sizeTemplate.createTemplate());
          break;

        case 'description':
          descriptionTemplate = DescriptionTemplate(testData[key]);
          widgetList.add(descriptionTemplate.createTemplate());
          break;
      }
    }
    widgetList.add(
      Container(
        height: 60,
        margin: EdgeInsets.all(10),
        child: RaisedButton(
          onPressed: (){

          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          padding: const EdgeInsets.all(8.0),
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20,),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
            ],
          )
        ),
      ),
    );
    return widgetList;
  }


  Widget productPageWidget() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getProductMeta(),
        ),
      )
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 40.0),
            child: productPageWidget(),
          ),
        )
    );
  }
}