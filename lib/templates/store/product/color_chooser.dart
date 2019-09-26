import 'package:flutter/material.dart';


class ColorChooserTemplate {
  Map<String, dynamic> colors;
  List<Widget> widgetList = [Text("Color: "),];

  ColorChooserTemplate(this.colors);

  _parseHexColor(String hexColor) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  createTemplate() {

    this.colors.keys.forEach((element) {
      widgetList.add(
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                color: _parseHexColor(this.colors[element]['color_value']),
              ),
              Container(
                child: Text(this.colors[element]['color_name'], style: TextStyle(fontSize: 10),),
              )
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