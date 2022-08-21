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
  List<Album>? getAlbumList() {
    return _albums;
  }
}
