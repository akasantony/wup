import 'package:flutter/cupertino.dart';

class Flips {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  int id;

  String mediaType;
  String mediaFilePath;
  String mediaThumbnailPath;
  String description;
  String visibility;
  int timestamp;

  Flips({
    this.mediaThumbnailPath,
    this.mediaType,
    this.timestamp,
    this.mediaFilePath,
    this.description,
    this.visibility
  });

  Map<String, dynamic> toMap() {
    return {
      'mediathumbnailpath': mediaThumbnailPath,
      'mediatype': mediaType,
      'mediafilepath': mediaFilePath,
      'timestamp': timestamp,
      'description': description,
      'visibility': visibility,
    };
  }

  static Flips fromMap(Map<String, dynamic> map) {
    return Flips(
      mediaThumbnailPath: map['mediathumbnailpath'],
      mediaFilePath: map['mediafilepath'],
      mediaType: map['mediatype'],
      timestamp: map['timestamp'],
      description: map['description'],
      visibility: map['visibility'],
    );
  }
}