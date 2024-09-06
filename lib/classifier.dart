import 'package:flutter/services.dart';
// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  // Name of the model file
  final _modelFile = 'assets/spamham.tflite';

  // TensorFlow Lite Interpreter object
  late Interpreter _interpreter;

  Classifier() {
    // Load model when the classifier is initialized.
    _loadModel();
  }

  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  List<double> classify(String rawText) {
    // Tokenize input text. Assuming the model can directly take raw text.
    List<int> input = _preprocessText(rawText);

    // Output of shape [4, 1].
    var output = List<double>.filled(4, 0).reshape([4, 1]);

    // The run method will run inference and store the resulting values in output.
    _interpreter.run(input, output);

    return [output[0][0], output[1][0], output[2][0], output[3][0]];
  }

  // Preprocess text function
  List<int> _preprocessText(String text) {
    // Convert the raw text to a list of integers.
    // This is a placeholder for actual preprocessing logic. Adjust according to your model's requirements.
    List<int> input = text.codeUnits;
    if (input.length > 256) {
      input = input.sublist(0, 256); // Truncate to max length
    } else if (input.length < 256) {
      input += List<int>.filled(256 - input.length, 0); // Pad to max length
    }
    return input;
  }
}
