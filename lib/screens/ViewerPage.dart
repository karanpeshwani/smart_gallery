import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:smart_gallery_flutter_app/models/SharedPreferencesClass.dart'
    as spc;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../constants/Heights.dart';
import '../models/GalleryClass.dart';

class ViewerPage extends StatefulWidget {
  final int assetIndex;
  final int albumIndex;
  Uint8List bytes = Uint8List.fromList([]);
  ViewerPage({Key? key, required this.albumIndex, required this.assetIndex})
      : super(key: key);
  @override
  ViewerPageState createState() => ViewerPageState();
}

class ViewerPageState extends State<ViewerPage> {
  spc.Category category = spc.Category(label: "No Label", score: 0);
  bool _loading = true;

  Future<void> processAsset(
      AssetEntity asset, GalleryClass galleryClass) async {
    Uint8List? b = await asset.originBytes;
    (b != null) ? (widget.bytes = b) : (widget.bytes = Uint8List.fromList([1]));

    spc.Category? predictedCategory = await galleryClass.classifyAsset(asset);
    if (predictedCategory != null) {
      category = predictedCategory;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final galleryClass = Provider.of<GalleryClass>(context, listen: true);
    final gallery = galleryClass.getGallery();
    final album = gallery.elementAt(widget.albumIndex);
    final AssetEntity asset = album.elementAt(widget.assetIndex);

    if (widget.bytes.isEmpty) {
      processAsset(asset, galleryClass);
    }

    DateTime date =
        (asset.createDateTime == DateTime.fromMillisecondsSinceEpoch(0))
            ? asset.modifiedDateTime
            : asset.createDateTime;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(date.toLocal().toString()),
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
                        MediaQuery.of(context).padding.top -
                        2*paddingHeight -
                        2 * textHeight),

                    /*
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.memory(widget.bytes),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        Text(
                          category.label,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Confidence: ${category.score.toStringAsFixed(3)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    */

                    child: Container(
                      alignment: Alignment.center,
                      child: Image.memory(widget.bytes),
                    ),
                  ),
                  const SizedBox(
                    height: paddingHeight,
                  ),
                  SizedBox(
                    height: textHeight,
                    child: Text(
                      category.label,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: textHeight,
                    child: Text(
                      'Confidence: ${category.score.toStringAsFixed(3)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: paddingHeight,
                  ),
                  AppBar(
                    actions: const [
                      Text("hello"),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
