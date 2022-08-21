// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import '../models/AlbumListClass.dart';
import '../screens/AlbumPage.dart';
// import './EachAlbumWidget.dart';
import '../screens/ClassifiedAlbumPage.dart';
import './ClassifiedHomePage.dart';
import '../models/ClassifiedAlbumListClass.dart';
import '../screens/ClassifiedAlbumPage.dart';
import '../models/ClassifierClass.dart';

class ClassifiedHomePage extends StatefulWidget {
  Classifier classifier;
  AlbumListClass albumListClass;
  late ClassifiedAlbumListClass classifiedAlbumListClass;

  ClassifiedHomePage({required this.classifier, required this.albumListClass}) {
    classifiedAlbumListClass = ClassifiedAlbumListClass(
        classifier: classifier, albumListClass: albumListClass);
  }

  @override
  _ClassifiedHomePageState createState() => _ClassifiedHomePageState();
}

class _ClassifiedHomePageState extends State<ClassifiedHomePage> {
  // const EachAlbumWidget({Key? key}) : super(key: key);
  bool _loading = false;

  @override
  void initState() {
    _loading = true;
    initAsync();
  }

  void initAsync() async {
    print("order check - 0");
    await widget.classifiedAlbumListClass.makeClassifiedAlbumList();
    print("order check - 1");
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final classifiedAlbumListClass =
    //     Provider.of<ClassifiedAlbumListClass>(context, listen: true);
/*
    return LayoutBuilder(
      builder: (context, constraints) {
        double gridWidth = (constraints.maxWidth - 20) / 3;
        double gridHeight = gridWidth + 33;
        double ratio = gridWidth / gridHeight;
        return Container(
          padding: EdgeInsets.all(5),
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.count(
                  childAspectRatio: ratio,
                  crossAxisCount: 3,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  children: <Widget>[
                    ...?widget.classifiedAlbumListClass.getClassifiedAlbumList()?.map(
                          (classifiedAlbum) => EachClassifiedAlbumWidget(
                              gridWidth: gridWidth, classifiedAlbum : classifiedAlbum),
                        ),
                  ],
                ),
        );
      },
    );
    */

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // title: Text(widget.classifiedAlbum.name ?? "Unnamed Album"),
            title: const Text("Unnamed Album"),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              double gridWidth = (constraints.maxWidth - 20) / 3;
              double gridHeight = gridWidth + 33;
              double ratio = gridWidth / gridHeight;
              return Container(
                padding: EdgeInsets.all(5),
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.count(
                        childAspectRatio: ratio,
                        crossAxisCount: 3,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        children: <Widget>[
                          ...?widget.classifiedAlbumListClass
                              .getClassifiedAlbumList()
                              ?.map(
                                (classifiedAlbum) => EachClassifiedAlbumWidget(
                                    gridWidth: gridWidth,
                                    classifiedAlbum: classifiedAlbum),
                              ),
                        ],
                      ),
              );
            },
          )),
    );
  }
}

class EachClassifiedAlbumWidget extends StatelessWidget {
  final double gridWidth;
  final List<Medium> classifiedAlbum;

  EachClassifiedAlbumWidget({
    required this.gridWidth,
    required this.classifiedAlbum,
  }) {
    print("order check - 2");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ClassifiedAlbumPage(classifiedAlbum: classifiedAlbum))),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: Colors.grey[300],
              height: gridWidth,
              width: gridWidth,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: MemoryImage(kTransparentImage),
                image: MemoryImage(kTransparentImage),
                /*
                image: AlbumThumbnailProvider(
                  albumId: album.id,
                  mediumType: album.mediumType,
                  highQuality: true,
                ),
                */
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 2.0),
            child: const Text(
              // album.name ?? "Unnamed Album",
              "Unnamed Album",
              maxLines: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                height: 1.2,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 2.0),
            child: Text(
              classifiedAlbum.length.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                height: 1.2,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
