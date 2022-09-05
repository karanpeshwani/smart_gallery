import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/GalleryClass.dart';
import '../models/ClassifierClass.dart';
import '../models/SharedPreferencesClass.dart';
import './ViewerPage.dart';
import '../constants/Heights.dart';
import '../constants/Icons.dart' as icons;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'dart:io' as io;

class AlbumPage extends StatefulWidget {
  // final Album album;

  final int albumIndex;
  Classifier classifier;
  bool doneOnes = false;
  AlbumPage(this.albumIndex, this.classifier, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  List<Medium>? _media;
  bool selectOn = false;
  bool _loading = true;
  bool selectIsOff = true;
  List<AssetEntity> _album = [];

  final MultiSelectController<AssetEntity> _controller =
      MultiSelectController();
  // final MultiSelectController<String> _controller = MultiSelectController();
  static const lis = [1, 2, 3, 4, 5, 6];

  void initAsync(Album album) async {
    MediaPage mediaPage = await album.listMedia();
    setState(() {
      _media = mediaPage.items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final gallery = galleryClass.getGallery();
    final album = gallery.elementAt(widget.albumIndex);
    final albumNameList = galleryClass.getAlbumNameList();

    return selectIsOff
        ? MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(icons.backArrowIcon),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: TextButton.icon(
                      onPressed: () => {
                        setState(() {
                          selectIsOff = false;
                        })
                      },
                      icon: const Icon(
                        icons.selectIcon,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 25,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      label: Container(),
                    ),
                  ),
                ],
                title: Text(albumNameList.elementAt(widget.albumIndex)),
              ),
              body: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: <Widget>[
                        for (int assetIndex = 0;
                            assetIndex < album.length;
                            assetIndex++)
                          EachImageWidget(
                              widget.albumIndex, assetIndex, widget.classifier),
                      ],
                    ),
            ),
          )
        : MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(icons.backArrowIcon),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      // margin:  const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: TextButton(
                        onPressed: () => {
                          setState(() {
                            selectIsOff = true;
                          })
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      )),
                ],
                title: Text(albumNameList.elementAt(widget.albumIndex)),
              ),
              body: Column(
                      children: [
                        SizedBox(
                          height: (MediaQuery.of(context).size.height -
                              2 * appBarHeight -
                              MediaQuery.of(context).padding.top),
                          child: MultiSelectCheckList(
                            maxSelectableCount: 100,
                            textStyles: const MultiSelectTextStyles(
                                selectedTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            itemsDecoration: MultiSelectDecorations(
                                selectedDecoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.8))),

                            listViewSettings: ListViewSettings(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      height: 0,
                                    )),

                            controller: _controller,

                            items: [
                              for (int assetIndex = 0;
                                  assetIndex < album.length;
                                  assetIndex++)
                                CheckListCard(
                                  // [...lis.map((e) => CheckListCard(
                                  // value: EachImageWidget(medium, widget.classifier),
                                  value: album.elementAt(assetIndex),
                                  // title: EachImageWidget(medium, widget.classifier),
                                  title: EachImageWidget(widget.albumIndex,
                                      assetIndex, widget.classifier),
                                  subtitle: const Text("karan"),
                                  // title: Text(_items[index].title),
                                  // subtitle: Text(_items[index].subTitle),
                                  selectedColor: Colors.white,
                                  checkColor: Colors.indigo,
                                  // selected: index == 3,
                                  // enabled: !(index == 5),
                                  checkBoxBorderSide:
                                      const BorderSide(color: Colors.blue),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(5))
                                )
                            ],

                            onChange: (allSelectedItems, selectedItem) {},
                            //
                          ),
                        ),
                        AppBar(
                          actions: [
                            TextButton.icon(
                              onPressed: (() async{      // if we put async here, it will give error
                                selectIsOff = true;
                                await galleryClass.deleteAsset(
                                    _controller.getSelectedItems(),widget.albumIndex);
                              }),
                              icon: const Icon(
                                icons.deleteIcon,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 25,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                              label: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          );
  }
}

class EachImageWidget extends StatelessWidget {
  const EachImageWidget(this.albumIndex,this.assetIndex, this.classifier, {Key? key})
      : super(key: key);

  // final AlbumPage widget;
  final int albumIndex;
  final int assetIndex;
  final Classifier classifier;
  @override
  Widget build(BuildContext context) {
    // final sharedPreferencesClass =
    //     Provider.of<SharedPreferencesClass>(context, listen: true);
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final gallery = galleryClass.getGallery();
    final album = gallery.elementAt(albumIndex);

    return GestureDetector(
      // onTap: () => Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) =>
      //         ViewerPage(medium, classifier, sharedPreferencesClass))),
      child: Container(
        color: Colors.grey[300],
        child: AssetEntityImage(
          album.elementAt(assetIndex),
          isOriginal: false, // Defaults to `true`.
          thumbnailSize: const ThumbnailSize.square(200), // Preferred value.
          thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
        ),
      ),
    );
  }
}
