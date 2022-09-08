import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_gallery_flutter_app/models/classifier_float.dart';
import './models/ClassifierClass.dart';
import 'screens/HomePage.dart';
import 'models/GalleryClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/SharedPreferencesClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const _MyApp());
}

class _MyApp extends StatefulWidget {
  const _MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> with WidgetsBindingObserver {
  final GalleryClass _galleryClass = GalleryClass();
  late SharedPreferencesClass sharedPreferencesClass;
  late dynamic prefs;
  final Classifier classifier = ClassifierFloat();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      await _galleryClass.setUpGallery();

      setState(() {
        _loading = false;
      });

      prefs = await SharedPreferences.getInstance();

      await classifier.loadModel();

      _galleryClass.setClassifier(classifier);
      sharedPreferencesClass = SharedPreferencesClass(
          prefs.getString('saved_predictions_map_as_string'),
          prefs.getString('saved_classified_albums_set_as_string'));

      _galleryClass.setSharedPreferencesClass(sharedPreferencesClass);

      _galleryClass.classifyAllAssets();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    String updatedPredictionsMapAsString =
        sharedPreferencesClass.getUpdatedPredictionsMapAsString();
    await prefs.setString(
        'saved_predictions_map_as_string', updatedPredictionsMapAsString);

    String updatedClassifiedAlbumsSetAsString =
        sharedPreferencesClass.getUpdatedClassifiedAlbumsMapAsString();
    await prefs.setString('saved_classified_albums_set_as_string',
        updatedClassifiedAlbumsSetAsString);
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _galleryClass),
      ],
      child: MaterialApp(
        home: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : HomePage(classifier),
      ),
    );
  }
}
