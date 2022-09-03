import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/AlbumListClass.dart';
import '../models/ClassifierClass.dart';
import '../models/SharedPreferencesClass.dart';
import './ViewerPage.dart';
import '../constants/Heights.dart';
import '../constants/Icons.dart' as icons;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'dart:io' as io;

class AlbumPage extends StatefulWidget {
  // final Album album;
  late AlbumListClass albumListClass;
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
  final MultiSelectController<Widget> _controller = MultiSelectController();
  // final MultiSelectController<String> _controller = MultiSelectController();

  static const lis = [1, 2, 3, 4, 5, 6];
  @override
  void initState() {
    super.initState();
  }

  void initAsync(Album album) async {
    MediaPage mediaPage = await album.listMedia();
    setState(() {
      _media = mediaPage.items;
      _loading = false;
    });
  }

  deleteSelectedItems() async {
    // var listOfItemsToBeDeleted =  <io.File>[];
    for (var element in _controller.getSelectedItems()) {
      // The deleted id will be returned, if it fails, an empty array will be returned.
      // Medium mediumToBeDeleted =
      //     ((element as EachImageWidget).medium);
      io.File fileToBeDeleted =
          await ((element as EachImageWidget).medium).getFile();
/*
      try {
        // await fileToBeDeleted
        //     .delete()
        //     .then((value) => print("deleted successfully"));
        // widget.albumListClass.updateAlbums();

        fileToBeDeleted.deleteSync(recursive: false);
        setState(() {
          widget.doneOnes = false;
        });
      } catch (e) {
        print("Error while deleting the image.");
      }
*/
      
      fileToBeDeleted.deleteSync(recursive: true);
      
      setState(() {
        widget.doneOnes = false;
      });

      // listOfItemsToBeDeleted.add(mediumToBeDeleted.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final albumListClass = Provider.of<AlbumListClass>(context, listen: true);
    print("Albumpage build function running.");
    if (widget.doneOnes == false) {
      widget.doneOnes = true;
      albumListClass.updateAlbums();
      widget.albumListClass = albumListClass;
      widget.doneOnes = true;
      initAsync(albumListClass.getAlbumList()!.elementAt(widget.albumIndex));
    }
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
                    // margin:  const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    // child: const Icon(
                    //   icons.selectIcon,
                    //   color: Color.fromARGB(255, 255, 255, 255),
                    //   size: 25,
                    //   semanticLabel: 'Text to announce in accessibility modes',
                    // ),
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
                title: Text(albumListClass
                        .getAlbumList()!
                        .elementAt(widget.albumIndex)
                        .name ??
                    "Unnamed Album"),
              ),
              body: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: <Widget>[
                        ...?_media?.map(
                          (medium) =>
                              EachImageWidget(medium, widget.classifier),
                        ),
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
                title: Text(albumListClass
                        .getAlbumList()!
                        .elementAt(widget.albumIndex)
                        .name ??
                    "Unnamed Album"),
              ),
              body: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
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
                              ...?_media?.map((medium) => CheckListCard(
                                    // [...lis.map((e) => CheckListCard(
                                    // value: EachImageWidget(medium, widget.classifier),
                                    value: EachImageWidget(
                                        medium, widget.classifier),
                                    // title: EachImageWidget(medium, widget.classifier),
                                    title: EachImageWidget(
                                        medium, widget.classifier),
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
                                  )),
                            ],
                            /*
                items: [... lis.map((e) =>  CheckListCard(
                        // value: EachImageWidget(medium, widget.classifier),
                        value: Container(
                          height: 100,
                          child: Container(
                            height: 50,
                            color: Colors.amberAccent,
                          ),
                        ),
                        title: Container(
                          height: 100,
                          child: Container(
                            height: 50,
                            color: Color.fromARGB(255, 64, 179, 255),
                          ),
                        ),
                        subtitle: Text(e.toString()),
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
                      ))],
                */

                            onChange: (allSelectedItems, selectedItem) {},
                            //
                          ),
                        ),
                        AppBar(
                          actions: [
                            TextButton.icon(
                              onPressed: () async {
                                await deleteSelectedItems();
                                setState(() {
                                  selectIsOff = true;
                                });
                              },
                              icon: const Icon(
                                icons.deleteIcon,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 25,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                              label: Container(),
                            ),
                            const Icon(
                              icons.shareIcon,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 25,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
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
  const EachImageWidget(this.medium, this.classifier, {Key? key})
      : super(key: key);

  // final AlbumPage widget;
  final Medium medium;
  final Classifier classifier;
  @override
  Widget build(BuildContext context) {
    final sharedPreferencesClass =
        Provider.of<SharedPreferencesClass>(context, listen: true);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ViewerPage(medium, classifier, sharedPreferencesClass))),
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
