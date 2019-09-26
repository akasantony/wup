import 'package:flutter/material.dart';


class SizeTemplate {
  List size;
  List<Widget> widgetList = [Text("Size: "),];

  SizeTemplate(this.size);

  createTemplate() {
    this.size.forEach((element) {
      widgetList.add(
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                child: Text(element),
              ),
            ],
          ),
        ),
      );
    });


    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgetList
      ),
    );
  }
}