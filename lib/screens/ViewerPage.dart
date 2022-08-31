import 'package:smart_gallery_flutter_app/models/SharedPreferencesClass.dart'
    as spc;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:smart_gallery/screens/VideoPlayer.dart';
// import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import '../constants/Heights.dart';

class ViewerPage extends StatefulWidget {
  final Medium medium;
  Classifier classifier;
  bool doneOnes = false;
  spc.SharedPreferencesClass sharedPreferencesClass;
  String pred = "";
  var b = Uint8List.fromList([
    137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0,
    1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 10, 73, 68, 65,
    84, 120, 156, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 45, 180, 0, 0, 0, 0, 73,
    69, 78, 68, 174, 66, 96, 130 // prevent dartfmt
  ]);
  ViewerPage(this.medium, this.classifier, this.sharedPreferencesClass);
  @override
  ViewerPageState createState() => ViewerPageState();
}

class ViewerPageState extends State<ViewerPage> {
  late final spc.Category? category;
  bool _loading = true;

  void getImage() async {
    widget.doneOnes = true;
    final file = await PhotoGallery.getFile(
        mediumId: widget.medium.id,
        mediumType: MediumType.image,
        mimeType: null);
    final Uint8List bytes = await file.readAsBytes();
    print("a______");
    setState(() {
      widget.b = bytes;
      print("b______");
    });

    // here we have to predict the image
    _predict();
    setState(() {
      _loading = false;
    });

    // _predict();
  }

  void _predict() {
    if (widget.sharedPreferencesClass.savedPredictions!
        .containsKey(widget.medium.id)) {
      setState(() {
        category =
            widget.sharedPreferencesClass.savedPredictions![widget.medium.id];
      });
      return;
    }
    img.Image imageInput = img.decodeImage(widget.b)!;
    print("kkkkkkkkkkkkkkkkkkkkkkkkk-000000000000000");
    final pred = widget.classifier.predict(imageInput);
    print("kkkkkkkkkkkkkkkkkkkkkkkkk-11111111111111");
    setState(() {
      category = spc.Category(label: pred.label, score: pred.score);
      // _loading = false;
    });
    setState(() {
      _loading = false;
    });
    print("kkkkkkkkkkkkkkkkkkkkkkkkk-2222222222222222222");
  }

  @override
  Widget build(BuildContext context) {
    print("c______");
    print(_loading);
    if (widget.doneOnes == false) {
      getImage();
    }
    // getImage();
    DateTime? date = widget.medium.creationDate ?? widget.medium.modifiedDate;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: date != null ? Text(date.toLocal().toString()) : null,
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height - 2*appBarHeight - MediaQuery.of(context).padding.top),
                  child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.memory(widget.b),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        Text(
                          category != null ? category!.label : '',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          category != null
                              ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                              : '',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                ),
                AppBar(
                  actions: const [
                    Text("hello"),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}











//***************************************************//











/*
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:smart_gallery/screens/VideoPlayer.dart';
import 'package:transparent_image/transparent_image.dart';

class ViewerPage extends StatelessWidget {
  final Medium medium;

  ViewerPage(Medium medium) : medium = medium;
  // ViewerPage(this.medium);

  @override
  Widget build(BuildContext context) {

    DateTime? date = medium.creationDate ?? medium.modifiedDate;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: date != null ? Text(date.toLocal().toString()) : null,
        ),
        body: Container(
          alignment: Alignment.center,
          child: medium.mediumType == MediumType.image
              ? FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: PhotoProvider(mediumId: medium.id), // medium into img
                )
              : VideoProvider(
                  mediumId: medium.id,
                ),
        ),
      ),
    );
  }
}
*/



