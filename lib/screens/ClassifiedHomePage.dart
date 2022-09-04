// import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:provider/provider.dart';
// import 'package:transparent_image/transparent_image.dart';
// import '../models/ClassifierClass.dart';
// import '../models/GalleryClass.dart';
// import '../screens/AlbumPage.dart';
// // import './EachAlbumWidget.dart';
// import '../screens/ClassifiedAlbumPage.dart';
// import './ClassifiedHomePage.dart';
// import '../models/ClassifiedAlbumListClass.dart';
// import '../screens/ClassifiedAlbumPage.dart';
// import '../models/ClassifierClass.dart';
// import '../models/SharedPreferencesClass.dart';
// import '../models/SharedPreferencesClass.dart';

// class ClassifiedHomePage extends StatefulWidget {
//   Classifier classifier;
//   GalleryClass albumListClass;
//   late ClassifiedAlbumListClass classifiedAlbumListClass;
//   SharedPreferencesClass sharedPreferencesClass;

//   ClassifiedHomePage({required this.classifier, required this.albumListClass, required this.sharedPreferencesClass}) {
//     classifiedAlbumListClass = ClassifiedAlbumListClass(
//         classifier: classifier, albumListClass: albumListClass);
//   }

//   @override
//   _ClassifiedHomePageState createState() => _ClassifiedHomePageState();
// }

// class _ClassifiedHomePageState extends State<ClassifiedHomePage> {
//   // const EachAlbumWidget({Key? key}) : super(key: key);
//   bool _loading = false;

//   @override
//   void initState() {
//     _loading = true;
//     initAsync();
//   }

//   void initAsync() async {
//     print("order check - 0");
//     await widget.classifiedAlbumListClass.makeClassifiedAlbumList(widget.sharedPreferencesClass);
//     print("order check - 1");
//     setState(() {
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final sharedPreferencesClass = Provider.of<SharedPreferencesClass>(context, listen: true);

//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             // title: Text(widget.classifiedAlbum.name ?? "Unnamed Album"),
//             title: const Text("Unnamed Album"),
//           ),
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               double gridWidth = (constraints.maxWidth - 20) / 3;
//               double gridHeight = gridWidth + 33;
//               double ratio = gridWidth / gridHeight;
//               return Container(
//                 padding: EdgeInsets.all(5),
//                 child: _loading
//                     ? Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : GridView.count(
//                         childAspectRatio: ratio,
//                         crossAxisCount: 3,
//                         mainAxisSpacing: 5.0,
//                         crossAxisSpacing: 5.0,
//                         children: <Widget>[
//                           ...?widget.classifiedAlbumListClass
//                               .getClassifiedAlbumList()
//                               ?.map(
//                                 (classifiedAlbum) => EachClassifiedAlbumWidget(
//                                     gridWidth: gridWidth,
//                                     classifiedAlbum: classifiedAlbum),
//                               ),
//                         ],
//                       ),
//               );
//             },
//           )),
//     );
//   }
// }

// class EachClassifiedAlbumWidget extends StatelessWidget {
//   final double gridWidth;
//   final List<Medium> classifiedAlbum;

//   EachClassifiedAlbumWidget({
//     required this.gridWidth,
//     required this.classifiedAlbum,
//   }) {
//     print("order check - 2");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) =>
//               ClassifiedAlbumPage(classifiedAlbum: classifiedAlbum))),
//       child: Column(
//         children: <Widget>[
//           ClipRRect(
//             borderRadius: BorderRadius.circular(5.0),
//             child: Container(
//               color: Colors.grey[300],
//               height: gridWidth,
//               width: gridWidth,
//               child: FadeInImage(
//                 fit: BoxFit.cover,
//                 placeholder: MemoryImage(kTransparentImage),
//                 image: MemoryImage(kTransparentImage),
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.topLeft,
//             padding: const EdgeInsets.only(left: 2.0),
//             child: const Text(
//               // album.name ?? "Unnamed Album",
//               "Unnamed Album",
//               maxLines: 1,
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 height: 1.2,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.topLeft,
//             padding: const EdgeInsets.only(left: 2.0),
//             child: Text(
//               classifiedAlbum.length.toString(),
//               textAlign: TextAlign.start,
//               style: const TextStyle(
//                 height: 1.2,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
