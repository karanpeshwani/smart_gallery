// Not in use currently



// import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:provider/provider.dart';
// import 'package:transparent_image/transparent_image.dart';
// import '../models/ClassifierClass.dart';
// import '../models/AlbumListClass.dart';
// import '../screens/AlbumPage.dart';


// class EachAlbumWidget extends StatelessWidget {
//   const EachAlbumWidget({
//     Key? key,
//     required this.classifier,
//     required this.gridWidth,
//     required this.album,
//   }) : super(key: key);

//   final Classifier classifier;
//   final double gridWidth;
//   final Album album;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => AlbumPage(album, classifier))),
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
//                 image: AlbumThumbnailProvider(
//                   albumId: album.id,
//                   mediumType: album.mediumType,
//                   highQuality: true,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.topLeft,
//             padding: EdgeInsets.only(left: 2.0),
//             child: Text(
//               album.name ?? "Unnamed Album",
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
//             padding: EdgeInsets.only(left: 2.0),
//             child: Text(
//               album.count.toString(),
//               textAlign: TextAlign.start,
//               style: TextStyle(
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
