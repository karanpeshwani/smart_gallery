import 'dart:convert';
import 'dart:collection';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class ClassifiedAlbum {
  final String _name;
  ClassifiedAlbum(this._name);
  final HashSet<AssetEntity> _assetSet = HashSet();
  void addAssetIfAbsent(AssetEntity asset) {
    if (!_assetSet.contains(asset)) {
      _assetSet.add(asset);
    }
  }

  HashSet<AssetEntity> getAssetSet() {
    return _assetSet;
  }

  void deleteAssetFromClassifiedAlbum(AssetEntity asset) {
    _assetSet.remove(asset);
  }

  String getName() {
    return _name;
  }

  AssetEntity getThumbnail() {
    // if not null
    return _assetSet.elementAt(0);
  }

  int getAssetCount() {
    return _assetSet.length;
  }
}

class Category {
  String label;
  double score;
  Category({required this.label, required this.score});
}

class SharedPreferencesClass extends ChangeNotifier {
  String? savedPredictionsMapAsString = "";
  String? savedClassifiedAlbumsSetAsString = "";
  HashMap<String, Category> savedPredictionsMap =
      HashMap<String, Category>(); // asset.id, category
  // List<ClassifiedAlbum> savedClassifiedAlbumsList = [];
  HashMap<String, ClassifiedAlbum> savedClassifiedAlbumsSet = HashMap();

  SharedPreferencesClass(
      this.savedPredictionsMapAsString, this.savedClassifiedAlbumsSetAsString) {
    if (savedPredictionsMapAsString != null) {
      savedPredictionsMap = json.decode(savedPredictionsMapAsString!);
    }
    if (savedClassifiedAlbumsSetAsString != null) {
      savedClassifiedAlbumsSet = json.decode(savedClassifiedAlbumsSetAsString!);
    }
  }

  void savePediction({required String assetID, required Category category}) {
    savedPredictionsMap.putIfAbsent(assetID, () => category);
  }

  Category? getPrediction({required String assetID}) {
    if (savedPredictionsMap.containsKey(assetID)) {
      return savedPredictionsMap[assetID];
    }
    return null;
  }

  String getUpdatedPredictionsMapAsString() {
    String encodedMap = json.encode(savedPredictionsMap);
    return encodedMap;
  }

  String getUpdatedClassifiedAlbumsMapAsString() {
    String encodedList = json.encode(savedClassifiedAlbumsSet);
    return encodedList;
  }

  // List<ClassifiedAlbum> getClassifiedAlbumList() {
  //   List<ClassifiedAlbum> lis = [];

  //   for (var classifiedAlbum in savedClassifiedAlbumsSet.values) {
  //     lis.add(classifiedAlbum);
  //   }

  //   return lis;
  // }

  HashMap<String, ClassifiedAlbum> getSavedClassifiedAlbumsSet() {
    return savedClassifiedAlbumsSet;
  }
}
