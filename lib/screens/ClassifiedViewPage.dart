import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../models/GalleryClass.dart';
import 'package:smart_gallery_flutter_app/models/SharedPreferencesClass.dart'
    as spc;
import '../models/SharedPreferencesClass.dart';

class ClassifiedViewerPage extends StatefulWidget {
  final int classifiedAlbumIndex;
  final int assetIndex;

  Uint8List bytes = Uint8List.fromList([]);
  ClassifiedViewerPage(
      {Key? key, required this.classifiedAlbumIndex, required this.assetIndex})
      : super(key: key);

  @override
  ClassifiedViewerPageState createState() => ClassifiedViewerPageState();
}

class ClassifiedViewerPageState extends State<ClassifiedViewerPage> {
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
    final HashMap<String, ClassifiedAlbum> classifiedAlbumSet =
        galleryClass.sharedPreferencesClass.getSavedClassifiedAlbumsSet();
    final ClassifiedAlbum classifiedAlbum =
        classifiedAlbumSet.values.elementAt(widget.classifiedAlbumIndex);
    final AssetEntity asset =
        classifiedAlbum.getAssetSet().elementAt(widget.assetIndex);

    if (widget.bytes.isEmpty) {
      processAsset(asset, galleryClass);
      // getCategory(asset, galleryClass);
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
            : Container(
                alignment: Alignment.center,
                child: Image.memory(widget.bytes),
              ),
        /*
                  const SizedBox(
                    height: 36,
                  ),
                  Text(
                    category != null ? category!.label : '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    category != null
                        ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                        : '',
                    style: TextStyle(fontSize: 16),
                  ),
                  */
      ),
    );
  }
}
