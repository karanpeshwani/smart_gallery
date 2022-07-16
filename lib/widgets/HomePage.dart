import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import '../models/AlbumListClass.dart';
import '../screens/AlbumPage.dart';
import './EachAlbumWidget.dart';
class HomePage extends StatelessWidget {
  // const EachAlbumWidget({Key? key}) : super(key: key);
  Classifier classifier;
  HomePage(this.classifier);

  @override
  Widget build(BuildContext context) {
    final albumListClass = Provider.of<AlbumListClass>(context, listen: true);
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
            ],
          ),
        );
      },
    );
  }
}

