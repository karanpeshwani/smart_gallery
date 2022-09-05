import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import './ClassifiedViewPage.dart';

class ClassifiedAlbumPage extends StatefulWidget {
  final int classifiedAlbumIndex;
  ClassifiedAlbumPage({required this.classifiedAlbumIndex});

  @override
  State<StatefulWidget> createState() => ClassifiedAlbumPageState();
}

class ClassifiedAlbumPageState extends State<ClassifiedAlbumPage> {
  // List<Medium>? _media;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
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
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: <Widget>[
            ...widget.classifiedAlbum.map(
              (medium) => EachClassifiedImageWidget(medium: medium),
            ),
          ],
        ),
      ),
    );
  }
}

class EachClassifiedImageWidget extends StatelessWidget {
  const EachClassifiedImageWidget({required this.medium});

  // final AlbumPage widget;
  final Medium medium;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassifiedViewerPage(medium: medium))),
      child: Container(
        color: Colors.grey[300],
        child: FadeInImage(
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          image: ThumbnailProvider(
            mediumId: medium.id,
            mediumType: medium.mediumType,
            highQuality: true,
          ),
        ),
      ),
    );
  }
}
