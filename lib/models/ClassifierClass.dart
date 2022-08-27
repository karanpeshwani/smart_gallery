// import 'package:flutter/cupertino.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// class ClassifierClass {
//   var _interpreter;
//   bool _interpreterActive = false;
//   late List<String> labels;
//   final int _labelsLength = 2;
//   loadModel() async {
//     _interpreter = await tfl.Interpreter.fromAsset('tf_Lite_Model.tflite');
//     print("d_____");
//     _interpreterActive = true;
//   }

//   bool isInterpreterActive() {
//     return _interpreterActive;
//   }

//   dynamic getInterpreter() {
//     return _interpreter;
//   }

//   Future<void> loadLabels() async {
//     labels = await FileUtil.loadLabels("assets/labels.txt");
//     if (labels.length == _labelsLength) {
//       print('Labels loaded successfully');
//     } else {
//       print('Unable to load labels');
//     }
//   }

//   TensorImage _preProcess() {
//     int cropSize = min(_inputImage.height, _inputImage.width);
//     return ImageProcessorBuilder()
//         .add(ResizeWithCropOrPadOp(cropSize, cropSize))
//         .add(ResizeOp(
//             _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
//         .add(preProcessNormalizeOp)
//         .build()
//         .process(_inputImage);
//   }

//   Category predict(Image image) {
//     final pres = DateTime.now().millisecondsSinceEpoch;
//     _inputImage = TensorImage(_inputType);
//     _inputImage.loadImage(image);
//     _inputImage = _preProcess();
//     final pre = DateTime.now().millisecondsSinceEpoch - pres;

//     print('Time to load image: $pre ms');

//     final runs = DateTime.now().millisecondsSinceEpoch;
//     interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
//     final run = DateTime.now().millisecondsSinceEpoch - runs;

//     print('Time to run inference: $run ms');

//     Map<String, double> labeledProb = TensorLabel.fromList(
//             labels, _probabilityProcessor.process(_outputBuffer))
//         .getMapWithFloatValue();
//     final pred = getTopProbability(labeledProb);

//     return Category(pred.key, pred.value);
//   }
// }

//*********************************************************************/

import 'dart:math';

import 'package:image/image.dart';
import 'package:collection/collection.dart';
// import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  // var logger = Logger();

  late List<int> _inputShape;
  late List<int> _outputShape;

  late TensorImage _inputImage;
  late TensorBuffer _outputBuffer;

  late TfLiteType _inputType;
  // TfLiteType? _inputType;
  late TfLiteType _outputType;

  final String _labelsFileName = 'assets/labels.txt';

  // final int _labelsLength = 2;
  final int _labelsLength = 1001;
  // final int _labelsLength = 2;
  late var _probabilityProcessor;

  late List<String> labels;
  // List<String>? labels;
  String get modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

    // loadModel();

    loadLabels();
  }

  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      print('Interpreter Created Successfully');

      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _inputType = interpreter.getInputTensor(0).type;
      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
    print("sequence-1");
/*
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("sequence-2");
    FirebaseModelDownloader.instance
        .getModel(
            "mobilenet_v1_10_224",
            FirebaseModelDownloadType.localModel,
            FirebaseModelDownloadConditions(
              iosAllowsCellularAccess: true,
              iosAllowsBackgroundDownloading: false,
              androidChargingRequired: false,
              androidWifiRequired: false,
              androidDeviceIdleRequired: false,
            ))
        .then((customModel) {
      print("sequence-3");
      // Download complete. Depending on your app, you could enable the ML
      // feature, or switch from the local model to the remote model, etc.

      // The CustomModel object contains the local path of the model file,
      // which you can use to instantiate a TensorFlow Lite interpreter.
      final localModelPath = customModel.file;
      try {
        print("sequence-4");
        interpreter = Interpreter.fromFile(localModelPath);
        print("sequence-5");
        // interpreter = await Interpreter.fromAsset(modelName, options: _interpreterOptions);
        print('Interpreter Created Successfully');

        _inputShape = interpreter.getInputTensor(0).shape;
        _outputShape = interpreter.getOutputTensor(0).shape;
        _inputType = interpreter.getInputTensor(0).type;
        _outputType = interpreter.getOutputTensor(0).type;

        _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
        _probabilityProcessor =
            TensorProcessorBuilder().add(postProcessNormalizeOp).build();
      } catch (e) {
        print(
            'Unable to create interpreter, Caught Exception: ${e.toString()}');
      }
      print("sequence-6");
    });
    print("sequence-7");
*/
  
  }

  Future<void> loadLabels() async {
    print("ppppppppppppppppppppppppp++++++++++++++++");
    labels = await FileUtil.loadLabels(_labelsFileName);
    print("pppppppppppppppppppppppp--------------------");
    print(labels.length);
    if (labels.length == _labelsLength) {
      print('Labels loaded successfully');
    } else {
      print('Unable to load labels');
    }
  }

  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  // Category predict(Image image) {
  Category predict(Image image) {
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage(_inputType);
    _inputImage.loadImage(image);
    _inputImage = _preProcess();
    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('Time to load image: $pre ms');

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');

    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);

    return Category(pred.key, pred.value);
  }

  void close() {
    interpreter.close();
  }
}

MapEntry<String, double> getTopProbability(Map<String, double> labeledProb) {
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProb.entries);

  return pq.first;
}

int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}
