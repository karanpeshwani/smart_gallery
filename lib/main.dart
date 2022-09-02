import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:smart_gallery_flutter_app/models/classifier_float.dart';
import './models/ClassifierClass.dart';
import 'screens/HomePage.dart';
import './models/AlbumListClass.dart';
import './models/ClassifiedAlbumListClass.dart';
import './models/classifier_quant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/SharedPreferencesClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  print("start");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Classifier classifier = ClassifierQuant();
  Classifier classifier = ClassifierFloat();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
// class MyApp extends StatelessWidget {
  List<Album>? _albums;
  late AlbumListClass albumListClass;
  late final SharedPreferencesClass sharedPreferencesClass;
  late final dynamic prefs;
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

    // Load shared preferences
    // Instance of SharedPreferencesClass class.
    prefs = await SharedPreferences.getInstance();

    sharedPreferencesClass = SharedPreferencesClass(prefs.getString('savedPredictionsString'));

    await widget.classifier.loadModel();

    print("103");
    setState(() {
      _loading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    String updatedSavedPredictionsString =  sharedPreferencesClass.saveUpdatedSharedPreferences();
    await prefs.setString('savedPredictionsString', updatedSavedPredictionsString);
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

    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => AlbumListClass(_albums)),
        // ChangeNotifierProvider(create: (context) => ClassifiedAlbumListClass(_classifiedAlbums)),
        ChangeNotifierProvider(
            create: (context) =>
                sharedPreferencesClass),
      ],
      child: Container(
          child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Photo gallery'),
          ),
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : HomePage(widget.classifier, albumListClass),
        ),
      )),
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