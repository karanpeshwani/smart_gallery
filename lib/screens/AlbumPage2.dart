// import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:provider/provider.dart';
// import 'package:transparent_image/transparent_image.dart';
// import '../models/ClassifierClass.dart';
// import '../models/SharedPreferencesClass.dart';
// import './ViewerPage.dart';
// import '../constants/Heights.dart';
// import '../constants/Icons.dart' as icons;
// import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

// class AlbumPage extends StatefulWidget {
//   final Album album;
//   Classifier classifier;
//   AlbumPage(this.album, this.classifier);

//   @override
//   State<StatefulWidget> createState() => AlbumPageState();
// }

// class AlbumPageState extends State<AlbumPage> {
//   List<Medium>? _media;
//   bool selectOn = false;

//   @override
//   void initState() {
//     super.initState();
//     initAsync();
//   }

//   void initAsync() async {
//     MediaPage mediaPage = await widget.album.listMedia();
//     setState(() {
//       _media = mediaPage.items;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(icons.backArrowIcon),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           actions: <Widget>[
//             Container(
//               margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
//               // margin:  const EdgeInsets.fromLTRB(40, 0, 0, 0),
//               child: const Icon(
//                 icons.selectIcon,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 size: 25,
//                 semanticLabel: 'Text to announce in accessibility modes',
//               ),
//             ),
//           ],
//           title: Text(widget.album.name ?? "Unnamed Album"),
//         ),
//         body: Column(
//           children: [
//             SizedBox(
//               height: (MediaQuery.of(context).size.height -
//                   2 * appBarHeight -
//                   MediaQuery.of(context).padding.top),
//               child: GridView.count(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 1.0,
//                 crossAxisSpacing: 1.0,
//                 children: <Widget>[
//                   ...?_media?.map(
//                     (medium) => EachImageWidget(medium, widget.classifier),
//                   ),
//                 ],
//               ),
//             ),
//             AppBar(
//               actions: const [
//                 Text("hello"),
//                 Icon(
//                   icons.shareIcon,
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   size: 25,
//                   semanticLabel: 'Text to announce in accessibility modes',
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EachImageWidget extends StatelessWidget {
//   const EachImageWidget(this.medium, this.classifier);

//   // final AlbumPage widget;
//   final Medium medium;
//   final Classifier classifier;
//   @override
//   Widget build(BuildContext context) {
//     final sharedPreferencesClass =
//         Provider.of<SharedPreferencesClass>(context, listen: true);

//     return GestureDetector(
//       onTap: () => Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) =>
//               ViewerPage(medium, classifier, sharedPreferencesClass))),
//       child: Container(
//         color: Colors.grey[300],
//         child: FadeInImage(
//           fit: BoxFit.cover,
//           placeholder: MemoryImage(kTransparentImage),
//           image: ThumbnailProvider(
//             mediumId: medium.id,
//             mediumType: medium.mediumType,
//             highQuality: true,
//           ),
//         ),
//       ),
//     );
//   }
// }
