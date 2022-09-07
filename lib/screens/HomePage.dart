import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../models/ClassifierClass.dart';
import '../models/GalleryClass.dart';
import 'AlbumPage.dart';
import '../constants/Heights.dart';
import '../screens/ClassifiedHomePage.dart';

class HomePage extends StatelessWidget {
  final Classifier classifier;
  const HomePage(this.classifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final List<List<AssetEntity>> gallery = galleryClass.getGallery();

    return Column(
      children: <Widget>[
        SizedBox(
          height: (MediaQuery.of(context).size.height -
              appBarHeight -
              MediaQuery.of(context).padding.top -
              intelligentClassificationBarHeight -
              24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double gridWidth = (constraints.maxWidth - 20) / 3;
              double gridHeight = gridWidth + 33;
              double ratio = gridWidth / gridHeight;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: ratio,
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  ),
                  itemCount: gallery.length,
                  itemBuilder: (BuildContext context, int albumIndex) {
                    return EachAlbumWidget(
                        classifier: classifier,
                        gridWidth: gridWidth,
                        albumIndex: albumIndex);
                  });
            },
          ),
        ),
        SizedBox(
          height: intelligentClassificationBarHeight,
          child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ClassifiedHomePage(
                        classifier: classifier,
                      ))),
              child: const Text("ML")),
        ),
      ],
    );
  }
}

class EachAlbumWidget extends StatelessWidget {
  final Classifier classifier;
  final double gridWidth;
  final int albumIndex;

  const EachAlbumWidget({
    Key? key,
    required this.classifier,
    required this.gridWidth,
    required this.albumIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final gallery = galleryClass.getGallery();
    final albumNameList = galleryClass.getAlbumNameList();
    final thumbnailList = galleryClass.getAlbumThumbnails();

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
              // padding: const EdgeInsets.only(left: 2.0),
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
              // padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                gallery.elementAt(albumIndex).length.toString(),
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
