import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import './ClassifierClass.dart';
import './AlbumListClass.dart';
import 'package:image/image.dart' as img;
import 'dart:collection';
import '../models/SharedPreferencesClass.dart';

class ClassifiedAlbumListClass extends ChangeNotifier {
  // final _classifiedAlbumList = List<List<Medium>>.filled(2, <Medium>[]);
  final List<List<Medium>> _classifiedAlbumList = List.generate(2, (i) => []);
  // List<List<Medium>>? _classifiedAlbumList;
  Classifier classifier;
  AlbumListClass albumListClass;
  HashMap map1 = HashMap<String, String>();
  HashMap map2 = HashMap<String, int>();
  ClassifiedAlbumListClass(
      {required this.classifier, required this.albumListClass}) {
    map1["tiger cat"] = "Animal";
    map1["orange"] = "Fruit";
    map2["Animal"] = 0;
    map2["Fruit"] = 1;
  }

  var b = Uint8List.fromList([
    137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0,
    1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 10, 73, 68, 65,
    84, 120, 156, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 45, 180, 0, 0, 0, 0, 73,
    69, 78, 68, 174, 66, 96, 130 // prevent dartfmt
  ]);

  void _addImageToCategory(Medium img, int category) {
    // print("adding in category ${category}");
    // print("length of category 0 is ${_classifiedAlbumList[0].length}");
    // print("length of category 1 is ${_classifiedAlbumList[1].length}");
    _classifiedAlbumList[category].add(img);
    // print("length of category 0 is ${_classifiedAlbumList[0].length}");
    // print("length of category 1 is ${_classifiedAlbumList[1].length}");
  }

  Future<String> _predict(
      Medium medium, SharedPreferencesClass sharedPreferencesClass) async {
    String? label = sharedPreferencesClass.getPrediction(meduimId: medium.id);
    if (label != null) {
      return label;
    }

    var file = await PhotoGallery.getFile(
        mediumId: medium.id, mediumType: MediumType.image, mimeType: null);
    Uint8List bytes = await file.readAsBytes();

    img.Image imageInput = img.decodeImage(bytes)!;
    print("kkkkkkkkkkkkkkkkkkkkkkkkk-000000000000000");
    var pred = classifier.predict(imageInput);

    sharedPreferencesClass.savePediction(
        meduimId: medium.id, prediction: pred.label);
    return pred.label;
  }

/*
    MediaPage mediaPage = await widget.album.listMedia();
    setState(() {
      _media = mediaPage.items;
    });
*/
  Future<void> makeClassifiedAlbumList(
      SharedPreferencesClass sharedPreferencesClass) async {
    List<Album>? Albums = albumListClass.getAlbumList();
    // int? count = Albums?.length;
    int count = 1;
    for (var i = 0; i < count; i++) {
      Album album = Albums![i];
      MediaPage mediaPage = await album.listMedia();
      List<Medium> Mediums = mediaPage.items;
      // print("length of animals category = ${_classifiedAlbumList[0].length}");
      // print("length of Fruits category = ${_classifiedAlbumList[1].length}");
      for (var medium in Mediums) {
        // predict and add to respective category
        String label = await _predict(medium, sharedPreferencesClass);
        print("sending ${label} to ${map2[map1[label]]}");
        _addImageToCategory(medium, map2[map1[label]]);
      }
      // print(
      //     "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
      // print("length of animals category = ${_classifiedAlbumList[0].length}");
      // print("length of Fruits category = ${_classifiedAlbumList[1].length}");
    }
  }

  // final _classifiedAlbum = <Medium>[];
  List<List<Medium>>? getClassifiedAlbumList() {
    return _classifiedAlbumList;
  }
}
