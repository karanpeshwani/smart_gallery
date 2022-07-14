import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:typed_data';
// import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
// import 'package:smart_gallery/screens/VideoPlayer.dart';
// import 'package:transparent_image/transparent_image.dart';

class ViewerPage extends StatefulWidget {
  final Medium medium;
  bool doneOnes = false;
  var b = Uint8List.fromList([
    137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0,
    1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 10, 73, 68, 65,
    84, 120, 156, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 45, 180, 0, 0, 0, 0, 73,
    69, 78, 68, 174, 66, 96, 130 // prevent dartfmt
  ]);
  ViewerPage(Medium medium) : medium = medium;
  @override
  ViewerPageState createState() => ViewerPageState();
}

class ViewerPageState extends State<ViewerPage> {
  // @override
  // void initState() async {
  //   super.initState();
  //   getImage();
  // }

  void getImage() async {
    widget.doneOnes = true;
    final file = await PhotoGallery.getFile(
        mediumId: widget.medium.id,
        mediumType: MediumType.image,
        mimeType: null);
    final Uint8List bytes = await file.readAsBytes();
    print("a______");
    setState(() {
      widget.b = bytes;
      print("b______");
    });
    final interpreter = await tfl.Interpreter.fromAsset('tf_Lite_Model.tflite')
        .then((value) => print("d______"));
  }

  @override
  Widget build(BuildContext context) {
    print("c______");
    if (widget.doneOnes == false) {
      getImage();
    }
    // getImage();
    DateTime? date = widget.medium.creationDate ?? widget.medium.modifiedDate;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: date != null ? Text(date.toLocal().toString()) : null,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Image.memory(widget.b),
        ),
      ),
    );
  }
}











//***************************************************//












// import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:smart_gallery/screens/VideoPlayer.dart';
// import 'package:transparent_image/transparent_image.dart';

// class ViewerPage extends StatelessWidget {
//   final Medium medium;

//   ViewerPage(Medium medium) : medium = medium;
//   // ViewerPage(this.medium);

//   @override
//   Widget build(BuildContext context) {

//     DateTime? date = medium.creationDate ?? medium.modifiedDate;
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () => Navigator.of(context).pop(),
//             icon: Icon(Icons.arrow_back_ios),
//           ),
//           title: date != null ? Text(date.toLocal().toString()) : null,
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           child: medium.mediumType == MediumType.image
//               ? FadeInImage(
//                   fit: BoxFit.cover,
//                   placeholder: MemoryImage(kTransparentImage),
//                   image: PhotoProvider(mediumId: medium.id), // medium into img
//                 )
//               : VideoProvider(
//                   mediumId: medium.id,
//                 ),
//         ),
//       ),
//     );
//   }
// }





