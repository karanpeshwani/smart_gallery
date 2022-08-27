import 'dart:convert';
import 'dart:collection';
import '../models/SharedPreferencesClass.dart';

import 'package:flutter/cupertino.dart';

class SharedPreferencesClass extends ChangeNotifier {
  // final dynamic prefs;\
  final String? savedPredictionsString;
  HashMap<String, String>? savedPredictions;

  SharedPreferencesClass(this.savedPredictionsString) {
    if ((savedPredictionsString == "") || (savedPredictionsString == null)) {
      savedPredictions = HashMap<String, String>();
    } else {
      savedPredictions = json.decode(savedPredictionsString!);
    }
  }

/*
  SharedPreferencesClass(this.prefs) {
    String? savedPredictionsString = prefs.getString('savedPredictionsString');
    if ((savedPredictionsString == "") || (savedPredictionsString == null)) {
      savedPredictions = HashMap<String, String>();
    } else {
      savedPredictions = json.decode(savedPredictionsString);
    }
  }
*/

/*
  HashMap<String, String>? getSavedPredictions() {
    if (savedPredictions == null) {
      return (savedPredictions = HashMap<String, String>());
    }
    return savedPredictions;
  }
*/

  void savePediction({required String meduimId, required String prediction}) {
    savedPredictions!.putIfAbsent(meduimId, () => prediction);
  }

  String? getPrediction({required String meduimId}) {
    if (savedPredictions!.containsKey(meduimId)) {
      return savedPredictions![meduimId];
    }
    return null;
  }

  String saveUpdatedSharedPreferences() {
    String encodedMap = json.encode(savedPredictions);

    return encodedMap;
    // prefs.setString('savedPredictionsString', encodedMap);
  }
}
