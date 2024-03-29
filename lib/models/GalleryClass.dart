import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import './SharedPreferencesClass.dart';
import 'package:image/image.dart' as img;
import './ClassifierClass.dart';

class GalleryClass extends ChangeNotifier {
  List<List<AssetEntity>> _gallery = [];
  List<AssetEntity> _albumThumbnailList = [];
  List<String> _albumNameList = [];
  late SharedPreferencesClass sharedPreferencesClass;
  late Classifier classifier;

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
      AssetEntity thumbnailAsset = albumAssetsList.elementAt(0); // if it exists
      _albumThumbnailList.add(thumbnailAsset);

      _gallery.add(albumAssetsList);
    }
    notifyListeners();
  }

  Future<Category?> _predict(AssetEntity asset) async {
    Category? category =
        sharedPreferencesClass.getPrediction(assetID: asset.id);
    if (category != null) {
      return category;
    }

    Uint8List? bytes = await asset.originBytes;

    img.Image? imageInput = img.decodeImage(bytes!);
    var pred = classifier.predict(imageInput!);

    sharedPreferencesClass.savePediction(
        assetID: asset.id,
        category: Category(label: pred.label, score: pred.score));
    return sharedPreferencesClass.getPrediction(assetID: asset.id);
  }

  void classifyAllAssets() async {
    for (var album in _gallery) {
      for (var asset in album) {
        if (!sharedPreferencesClass.savedPredictionsMap.containsKey(asset.id)) {
          Category? category = await _predict(asset);
          sharedPreferencesClass.savedPredictionsMap
              .putIfAbsent(asset.id, () => category!);
          if (sharedPreferencesClass
                  .savedClassifiedAlbumsSet[category!.label] ==
              null) {
            sharedPreferencesClass.savedClassifiedAlbumsSet[category.label] =
                ClassifiedAlbum(category.label);
            sharedPreferencesClass.savedClassifiedAlbumsSet[category.label]!
                .addAssetIfAbsent(asset);
          } else {
            sharedPreferencesClass.savedClassifiedAlbumsSet[category.label]!
                .addAssetIfAbsent(asset);
          }
        }
      }
    }
  }

  Future<Category?> classifyAsset(AssetEntity asset) async {
    // if model and shared predictions are loaded
    if (!sharedPreferencesClass.savedPredictionsMap.containsKey(asset.id)) {
      Category? category = await _predict(asset);
      sharedPreferencesClass.savedPredictionsMap
          .putIfAbsent(asset.id, () => category!);
      return category;
    }
    return sharedPreferencesClass.savedPredictionsMap[asset.id];
  }

  Future<void> deleteAsset(
      List<AssetEntity> deleteAssetList, int albumIndex) async {
    final deleteSet = HashSet<String>();
    for (var asset in deleteAssetList) {
      deleteSet.add(asset.id);
    }

    List<AssetEntity> newAlbum = [];
    if (albumIndex != 0) {
      for (var asset in _gallery.elementAt(albumIndex)) {
        if (deleteSet.contains(asset.id)) {
          continue;
        }
        newAlbum.add(asset);
      }
      if (newAlbum.isEmpty) {
        _gallery.removeAt(albumIndex);
        _albumThumbnailList.removeAt(albumIndex);
      } else {
        _gallery[albumIndex] = newAlbum;
        _albumThumbnailList[albumIndex] = newAlbum.elementAt(0);
      }
    } else {
      for (albumIndex = 1; albumIndex < _gallery.length; albumIndex++) {
        for (var asset in _gallery.elementAt(albumIndex)) {
          if (deleteSet.contains(asset.id)) {
            continue;
          }
          newAlbum.add(asset);
        }
        if (newAlbum.isEmpty) {
          _gallery.removeAt(albumIndex);
          _albumThumbnailList.removeAt(albumIndex);
        } else {
          _gallery[albumIndex] = newAlbum;
          _albumThumbnailList[albumIndex] = newAlbum.elementAt(0);
        }
      }
    }

    albumIndex = 0;
    newAlbum = [];
    for (var asset in _gallery.elementAt(albumIndex)) {
      if (deleteSet.contains(asset.id)) {
        continue;
      }
      newAlbum.add(asset);
    }
    if (newAlbum.isEmpty) {
      _gallery.removeAt(albumIndex);
      _albumThumbnailList.removeAt(albumIndex);
    } else {
      _gallery[albumIndex] = newAlbum;
      _albumThumbnailList[albumIndex] = newAlbum.elementAt(0);
    }

    for (var asset in deleteAssetList) {
      String label =
          (sharedPreferencesClass.savedPredictionsMap[asset.id])!.label;

      (sharedPreferencesClass.savedClassifiedAlbumsSet[label])!
          .deleteAssetFromClassifiedAlbum(asset);

      if (sharedPreferencesClass.savedClassifiedAlbumsSet[label]!
              .getAssetCount() ==
          0) {
        sharedPreferencesClass.savedClassifiedAlbumsSet.remove(label);
      }

      sharedPreferencesClass.savedPredictionsMap.remove(asset.id);
    }
    notifyListeners();

    List<String> lis = [];
    for (var asset in deleteAssetList) {
      lis.add(asset.id);
    }
    await PhotoManager.editor.deleteWithIds(lis);
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

  void setClassifier(Classifier classifier) {
    this.classifier = classifier;
  }

  void setSharedPreferencesClass(
      SharedPreferencesClass sharedPreferencesClass) {
    this.sharedPreferencesClass = sharedPreferencesClass;
  }
}
