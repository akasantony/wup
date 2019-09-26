import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class ImageTemplate{
  List images = List();
  int _current = 0;
  List<Widget> widgetList = [Text("Color: "),];

  ImageTemplate(this.images);

  changeState(index){
    _current = index;
  }

  createTemplate() {

    return Container(
      margin: EdgeInsets.all(10),
      width: 200,
      child: Stack(
          children: [
            CarouselSlider(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              height: 100.0,
              items: images.map((imageUri) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
//                                  color: Colors.amber
                      ),
                      child: Image.network(imageUri),
                    );
                  },
                );
              }).toList(),
              onPageChanged: changeState,
            ),
            Positioned(
                top: 80.0,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().map((index, imageUri) {
                    return MapEntry(index, Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)
                      ),
                    ),
                    );
                  }).values.toList(),
                )
            )
          ]
      ),
    );
  }
}