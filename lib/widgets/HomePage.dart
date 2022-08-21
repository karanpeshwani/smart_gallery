import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import '../models/AlbumListClass.dart';
import '../screens/AlbumPage.dart';
import './EachAlbumWidget.dart';
import '../screens/ClassifiedAlbumPage.dart';
import './ClassifiedHomePage.dart';
import '../models/ClassifiedAlbumListClass.dart';
class HomePage extends StatelessWidget {
  // const EachAlbumWidget({Key? key}) : super(key: key);
  Classifier classifier;
  AlbumListClass albumListClass;
  HomePage(this.classifier, this.albumListClass);

  @override
  Widget build(BuildContext context) {
    // final albumListClass = Provider.of<AlbumListClass>(context, listen: true);
    // final classifiedAlbumListClass = Provider.of<ClassifiedAlbumListClass>(context, listen: true);

    return LayoutBuilder(
      builder: (context, constraints) {
        double gridWidth = (constraints.maxWidth - 20) / 3;
        double gridHeight = gridWidth + 33;
        double ratio = gridWidth / gridHeight;
        return Container(
          padding: EdgeInsets.all(5),
          child: GridView.count(
            childAspectRatio: ratio,
            crossAxisCount: 3,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: <Widget>[
              ...?albumListClass.getAlbumList()?.map(
                    (album) => EachAlbumWidget(
                        classifier: classifier, gridWidth: gridWidth, album: album),
                  ),
                  ElevatedButton(onPressed:  () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassifiedHomePage(classifier: classifier, albumListClass : albumListClass))) , child: Text("ML")),
            ],
          ),
        );
      },
    );
  }
}

class EachAlbumWidget extends StatelessWidget {
  const EachAlbumWidget({
    Key? key,
    required this.classifier,
    required this.gridWidth,
    required this.album,
  }) : super(key: key);

  final Classifier classifier;
  final double gridWidth;
  final Album album;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AlbumPage(album, classifier))),
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
                image: AlbumThumbnailProvider(
                  albumId: album.id,
                  mediumType: album.mediumType,
                  highQuality: true,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 2.0),
            child: Text(
              album.name ?? "Unnamed Album",
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
              album.count.toString(),
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
