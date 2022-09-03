import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import '../models/AlbumListClass.dart';
import 'AlbumPage.dart';
import 'ClassifiedAlbumPage.dart';
import './ClassifiedHomePage.dart';
import '../models/SharedPreferencesClass.dart';

class HomePage extends StatelessWidget {
  final Classifier classifier;
  HomePage(this.classifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesClass =
        Provider.of<SharedPreferencesClass>(context, listen: true);
    final albumListClass = Provider.of<AlbumListClass>(context, listen: true);
    // final classifiedAlbumListClass = Provider.of<ClassifiedAlbumListClass>(context, listen: true);

    int numberOfAlbums = (albumListClass.getAlbumList())!.length;
    var albumIndexList = List<int>.generate(numberOfAlbums, (i) => i);

    return LayoutBuilder(
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
              // ...?albumListClass.getAlbumList()?.map(
              //       (album) => EachAlbumWidget(
              //           classifier: classifier,
              //           gridWidth: gridWidth,
              //           album: album),
              //     ),
              ...albumIndexList.map((albumIndex) => EachAlbumWidget(
                  classifier: classifier,
                  gridWidth: gridWidth,
                  albumIndex: albumIndex)),

              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ClassifiedHomePage(
                            classifier: classifier,
                            albumListClass: albumListClass,
                            sharedPreferencesClass: sharedPreferencesClass,
                          ))),
                  child: const Text("ML")),
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
    required this.albumIndex,
  }) : super(key: key);

  final Classifier classifier;
  final double gridWidth;
  final int albumIndex;
  @override
  Widget build(BuildContext context) {
    final albumListClass = Provider.of<AlbumListClass>(context, listen: true);
    final Album album = (albumListClass.getAlbumList())!.elementAt(albumIndex);
    print("Home page build function running");
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AlbumPage(albumIndex, classifier))),
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
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              album.name ?? "Unnamed Album",
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
              album.count.toString(),
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
