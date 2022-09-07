import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../models/GalleryClass.dart';
import '../models/SharedPreferencesClass.dart';
import './ClassifiedViewPage.dart';

class ClassifiedAlbumPage extends StatefulWidget {
  final int classifiedAlbumIndex;
  const ClassifiedAlbumPage({Key? key, required this.classifiedAlbumIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ClassifiedAlbumPageState();
}

class ClassifiedAlbumPageState extends State<ClassifiedAlbumPage> {
  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final HashMap<String, ClassifiedAlbum> classifiedAlbumSet =
        galleryClass.sharedPreferencesClass.getSavedClassifiedAlbumsSet();
    final ClassifiedAlbum classifiedAlbum =
        classifiedAlbumSet.values.elementAt(widget.classifiedAlbumIndex);

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
        /*
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: <Widget>[
            for (int assetIndex = 0;
                assetIndex < classifiedAlbum.getAssetSet().length;
                assetIndex++)
              EachClassifiedImageWidget(
                  classifiedAlbumIndex: widget.classifiedAlbumIndex,
                  assetIndex: assetIndex)
          ],
        ),
        */
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
            ),
            itemCount: classifiedAlbum.getAssetSet().length,
            itemBuilder: (BuildContext context, int assetIndex) {
              return EachClassifiedImageWidget(
                  classifiedAlbumIndex: widget.classifiedAlbumIndex,
                  assetIndex: assetIndex);
            }),
      ),
    );
  }
}

class EachClassifiedImageWidget extends StatelessWidget {
  const EachClassifiedImageWidget(
      {Key? key, required this.classifiedAlbumIndex, required this.assetIndex})
      : super(key: key);

  final int assetIndex;
  final int classifiedAlbumIndex;
  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final HashMap<String, ClassifiedAlbum> classifiedAlbumSet =
        galleryClass.sharedPreferencesClass.getSavedClassifiedAlbumsSet();
    final ClassifiedAlbum classifiedAlbum =
        classifiedAlbumSet.values.elementAt(classifiedAlbumIndex);
    final AssetEntity asset =
        classifiedAlbum.getAssetSet().elementAt(assetIndex);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassifiedViewerPage(
              classifiedAlbumIndex: classifiedAlbumIndex,
              assetIndex: assetIndex))),
      child: Container(
        color: Colors.grey[300],
        child: AssetEntityImage(
          asset,
          isOriginal: false, // Defaults to `true`.
          thumbnailSize: const ThumbnailSize.square(200), // Preferred value.
          thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
        ),
      ),
    );
  }
}
