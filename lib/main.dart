import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:smart_gallery_flutter_app/models/classifier_float.dart';
import './models/ClassifierClass.dart';

// import 'package:smart_gallery/screens/AlbumPage.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:video_player/video_player.dart';
import './widgets/HomePage.dart';
import './models/AlbumListClass.dart';
import './models/ClassifiedAlbumListClass.dart';
import './models/classifier_quant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print("start");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Classifier classifier = ClassifierQuant();
  Classifier classifier = ClassifierFloat();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// class MyApp extends StatelessWidget {
  List<Album>? _albums;
  late AlbumListClass albumListClass;
  // List<List<Medium>>? _classifiedAlbums;

  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _loading = true;
    // await classifier.getModel();
    initAsync();    
  }

  Future<void> initAsync() async {
    print("1");
    if (await _promptPermissionSetting()) {
      print("2");
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      print("3");
      _albums = albums;
      albumListClass = AlbumListClass(_albums);
    }
    print("100");
    await widget.classifier.loadModel();
    // if (!widget.classifier.isInterpreterActive()) {
    //   print("101");
    //   await widget.classifier.loadModel();
    //   print("102");
    // }
    print("103");
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print("500");

    // if (widget.classifier.isInterpreterActive()) {
    //   print("yes");
    // } else {
    //   print("NO");
    // }
    print("hola");
/*
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => AlbumListClass(_albums)),
        // ChangeNotifierProvider(create: (context) => ClassifiedAlbumListClass(_classifiedAlbums)),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Photo gallery'),
          ),
          body: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : HomePage(widget.classifier),
        ),
      ),
    );
*/

    return Container(
        child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Photo gallery'),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : HomePage(widget.classifier, albumListClass),
      ),
    ));
  }
}


/*
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Album>? _albums;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      setState(() {
        _albums = albums;
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Photo gallery example'),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : EachAlbumWidget(),
      ),
    );
  }
}
*/