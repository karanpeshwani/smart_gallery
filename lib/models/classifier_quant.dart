import './ClassifierClass.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ClassifierQuant extends Classifier {
  // ClassifierQuant({int numThreads: 2}) : super(numThreads: numThreads);
  ClassifierQuant({int numThreads = 1}) : super(numThreads: numThreads);
  @override
  // String get modelName => 'tf_Lite_Model.tflite';
  String get modelName => 'mobilenet_v1_1.0_224.tflite';
  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
