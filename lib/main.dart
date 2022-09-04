import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:smart_gallery_flutter_app/models/classifier_float.dart';
import './models/ClassifierClass.dart';
import 'screens/HomePage.dart';
import 'models/GalleryClass.dart';
import './models/ClassifiedAlbumListClass.dart';
import './models/classifier_quant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/SharedPreferencesClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:photo_manager/photo_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("start");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(_MyApp());
}

class _MyApp extends StatefulWidget {
  // Classifier classifier = ClassifierQuant();
  final Classifier classifier = ClassifierFloat();
  _MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> with WidgetsBindingObserver {
  // List<AssetPathEntity>? _albums;
  GalleryClass _galleryClass = GalleryClass();
  late final SharedPreferencesClass sharedPreferencesClass;
  late final dynamic prefs;
  // List<List<Medium>>? _classifiedAlbums;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    // _loading = true;
    // await classifier.getModel();
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      print("2");

      await _galleryClass.setUpGallery();

      print("3");
      // GalleryClass = GalleryClass(_albums);
    }

    // Load shared preferences
    // Instance of SharedPreferencesClass class.
    prefs = await SharedPreferences.getInstance();

    sharedPreferencesClass =
        SharedPreferencesClass(prefs.getString('savedPredictionsString'));

    await widget.classifier.loadModel();

    print("103");
    setState(() {
      _loading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    String updatedSavedPredictionsString =
        sharedPreferencesClass.saveUpdatedSharedPreferences();
    await prefs.setString(
        'savedPredictionsString', updatedSavedPredictionsString);
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
        // ChangeNotifierProvider(create: (context) => GalleryClass(_albums)),
        // ChangeNotifierProvider(create: (context) => ClassifiedGalleryClass(_classifiedAlbums)),
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _galleryClass),
        ChangeNotifierProvider(create: (context) => sharedPreferencesClass),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Photo gallery'),
          ),
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : HomePage(widget.classifier),
        ),
      ),
    );
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