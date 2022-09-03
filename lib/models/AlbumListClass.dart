import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class AlbumListClass extends ChangeNotifier {
  List<Album>? _albums;

  AlbumListClass(this._albums);
/*
  void setAlbumList(List<Album>? A) {
    _albums = A;
    notifyListeners();
  }
*/

  void updateAlbums() async {
    print("beginning update");
    _albums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
    print("after update");
    notifyListeners();
    print("after notifying listeners");
  }

  List<Album>? getAlbumList() {
    return _albums;
  }
}
