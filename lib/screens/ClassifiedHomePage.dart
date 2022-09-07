import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../models/ClassifierClass.dart';
import '../models/GalleryClass.dart';
import '../screens/ClassifiedAlbumPage.dart';
import '../models/SharedPreferencesClass.dart';

class ClassifiedHomePage extends StatefulWidget {
  Classifier classifier;

  ClassifiedHomePage({Key? key, required this.classifier}) : super(key: key);

  @override
  ClassifiedHomePageState createState() => ClassifiedHomePageState();
}

class ClassifiedHomePageState extends State<ClassifiedHomePage> {
  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final HashMap<String, ClassifiedAlbum> classifiedAlbumSet =
        galleryClass.sharedPreferencesClass.getSavedClassifiedAlbumsSet();

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
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
                padding: const EdgeInsets.all(5),
                child: GridView.count(
                  childAspectRatio: ratio,
                  crossAxisCount: 3,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  children: <Widget>[
                    for (var classifiedAlbumIndex = 0;
                        classifiedAlbumIndex < classifiedAlbumSet.length;
                        classifiedAlbumIndex++)
                      EachClassifiedAlbumWidget(
                          gridWidth: gridWidth,
                          classifiedAlbumIndex: classifiedAlbumIndex)
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
  final int classifiedAlbumIndex;

  const EachClassifiedAlbumWidget({
    Key? key,
    required this.gridWidth,
    required this.classifiedAlbumIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final HashMap<String, ClassifiedAlbum> classifiedAlbumSet =
        galleryClass.sharedPreferencesClass.getSavedClassifiedAlbumsSet();
    final ClassifiedAlbum classifiedAlbum =
        classifiedAlbumSet.values.elementAt(classifiedAlbumIndex);
    final AssetEntity thumbnailAsset = classifiedAlbum.getThumbnail();

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ClassifiedAlbumPage(classifiedAlbumIndex: classifiedAlbumIndex))),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: Colors.grey[300],
              height: gridWidth,
              width: gridWidth,
              child: AssetEntityImage(
                thumbnailAsset,
                isOriginal: false, // Defaults to `true`.
                thumbnailSize:
                    const ThumbnailSize.square(200), // Preferred value.
                thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              classifiedAlbum.getName(),
              // "Unnamed Album",
              maxLines: 1,
              textAlign: TextAlign.start,
              style: const TextStyle(
                height: 1.2,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              classifiedAlbum.getAssetCount().toString(),
              textAlign: TextAlign.start,
              style: const TextStyle(
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
