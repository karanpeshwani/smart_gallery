import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryClass extends ChangeNotifier {
  List<List<AssetEntity>> _gallery = [];
  List<AssetEntity> _albumThumbnailList = [];
  List<String> _albumNameList = [];

  Future<void> setUpGallery() async {
    _gallery = [];
    _albumThumbnailList = [];
    _albumNameList = [];
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    for (AssetPathEntity album in albums) {
      _albumNameList.add(album.name);
      List<AssetEntity> albumAssetsList = await album.getAssetListRange(
        start: 0,
        end: 8000,
      );
      _gallery.add(albumAssetsList);
    }

    for (List<AssetEntity> album in _gallery) {
      AssetEntity thumbnailAsset = album.elementAt(0);
      _albumThumbnailList.add(thumbnailAsset);
    }
    notifyListeners();
  }

  // Future<List<String>> deleteAsset(List<AssetEntity> deleteAssetList) async {
  Future<void> deleteAsset(List<AssetEntity> deleteAssetList) async {
    List<String> lis = [];
    for (var asset in deleteAssetList) {
      lis.add(asset.id);
    }
    List<String> result = await PhotoManager.editor.deleteWithIds(lis);

    setUpGallery();

    // return result;
    return;
  }

  List<List<AssetEntity>> getGallery() {
    return _gallery;
  }

  List<AssetEntity> getAlbumThumbnails() {
    return _albumThumbnailList;
  }

  int getNumberOfAlbums() {
    return _gallery.length;
  }

  List<String> getAlbumNameList() {
    return _albumNameList;
  }
}
