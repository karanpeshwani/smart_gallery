// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/ClassifierClass.dart';
import '../models/GalleryClass.dart';
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
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    // final classifiedAlbumListClass = Provider.of<ClassifiedAlbumListClass>(context, listen: true);
    final List<List<AssetEntity>> _gallery = galleryClass.getGallery();

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

              // ...albumIndexList.map((albumIndex) => EachAlbumWidget(
              //     classifier: classifier,
              //     gridWidth: gridWidth,
              //     albumIndex: albumIndex)),

              for (int albumIndex = 0;
                  albumIndex < _gallery.length;
                  albumIndex++)
                EachAlbumWidget(
                    classifier: classifier,
                    gridWidth: gridWidth,
                    albumIndex: albumIndex),
              /*
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ClassifiedHomePage(
                            classifier: classifier,
                            albumListClass: albumListClass,
                            sharedPreferencesClass: sharedPreferencesClass,
                          ))),
                  child: const Text("ML")),
              */
            ],
          ),
        );
      },
    );
  }
}

class EachAlbumWidget extends StatelessWidget {
  final Classifier classifier;
  final double gridWidth;
  final int albumIndex;

  EachAlbumWidget({
    Key? key,
    required this.classifier,
    required this.gridWidth,
    required this.albumIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final _gallery = galleryClass.getGallery();
    // final List<AssetEntity> album = _gallery.elementAt(albumIndex);
    final albumNameList = galleryClass.getAlbumNameList();
    final thumbnailList = galleryClass.getAlbumThumbnails();

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
                // child: FadeInImage(
                //   fit: BoxFit.cover,
                //   placeholder: MemoryImage(kTransparentImage),
                //   // image: AlbumThumbnailProvider(
                //   //   albumId: album.id,
                //   //   mediumType: album.albumType,
                //   //   highQuality: true,
                //   // image: MemoryImage(),
                // ),

                child: AssetEntityImage(
                  thumbnailList.elementAt(albumIndex),
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
                albumNameList.elementAt(albumIndex),
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
              _gallery.elementAt(albumIndex).length.toString(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  height: 1.2,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ));
  }
}
