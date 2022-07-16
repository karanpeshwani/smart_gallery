import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import './ViewerPage.dart';

class AlbumPage extends StatefulWidget {
  final Album album;
  Classifier classifier;
  AlbumPage(this.album, this.classifier);

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  List<Medium>? _media;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    MediaPage mediaPage = await widget.album.listMedia();
    setState(() {
      _media = mediaPage.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.album.name ?? "Unnamed Album"),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: <Widget>[
            ...?_media?.map(
              (medium) => EachImageWidget(medium, widget.classifier),
            ),
          ],
        ),
      ),
    );
  }
}

class EachImageWidget extends StatelessWidget {
  const EachImageWidget(this.medium, this.classifier);

  // final AlbumPage widget;
  final Medium medium;
  final Classifier classifier;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewerPage(medium, classifier))),
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
