import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
// import 'package:smart_gallery/screens/AlbumPage.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:video_player/video_player.dart';
import './widgets/EachAlbumWidget.dart';
import 'models/AlbumListClass.dart';

void main() {
  print("start");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// class MyApp extends StatelessWidget {
  List<Album>? _albums;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
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
    }
    print("4");
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
    print("5");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AlbumListClass(_albums))
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
              : EachAlbumWidget(),
        ),
      ),
    );
  }
}



// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<Album>? _albums;
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loading = true;
//     initAsync();
//   }

//   Future<void> initAsync() async {
//     if (await _promptPermissionSetting()) {
//       List<Album> albums =
//           await PhotoGallery.listAlbums(mediumType: MediumType.image);
//       setState(() {
//         _albums = albums;
//         _loading = false;
//       });
//     }
//     setState(() {
//       _loading = false;
//     });
//   }

//   Future<bool> _promptPermissionSetting() async {
//     if (Platform.isIOS &&
//             await Permission.storage.request().isGranted &&
//             await Permission.photos.request().isGranted ||
//         Platform.isAndroid && await Permission.storage.request().isGranted) {
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Photo gallery example'),
//         ),
//         body: _loading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : EachAlbumWidget(),
//       ),
//     );
//   }
// }

