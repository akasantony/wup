import 'package:flutter/material.dart';


class DescriptionTemplate {
  String description;
  List<Widget> widgetList = [Text("Description", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),),];

  DescriptionTemplate(this.description);

  createTemplate() {
    widgetList.add(Text(description, style: TextStyle(fontSize: 20),));

    return Column(
      children: widgetList,
    );
  }
}