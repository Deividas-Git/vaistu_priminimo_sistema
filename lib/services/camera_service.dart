import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  final TextRecognizer _textRecognizer = TextRecognizer();

  final _detectedController = StreamController<String>.broadcast();
  Stream<String> get onMedicationDetected => _detectedController.stream;

  bool _isCameraAccessGranted = false;
  bool get isCameraAccessGranted => _isCameraAccessGranted;

  bool _isProcessing = false;
  bool _isStreaming = false;

  CameraController? get controller => _controller;

  Future<void> updateCameraAccessStatus() async {
    final status = await Permission.camera.status;
    _isCameraAccessGranted = status.isGranted;
  }

  Future<void> init() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  void startStream() {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isStreaming) {
      return;
    }

    _isStreaming = true;

    _controller!.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) return;

        final text = await _textRecognizer.processImage(inputImage);
        final reg = _extractRegNumber(text.text);
        debugPrint("APTIKTAS KODAS: $reg");
        if (reg != null) {
          _detectedController.add(reg);
        }
      } finally {
        _isProcessing = false;
      }
    });
  }

  Future<void> stopStream() async {
    if (_controller != null && _controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
      _isStreaming = false;
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    await _detectedController.close();
  }

  InputImage? _convertCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  String? _extractRegNumber(String text) {
    final regex = RegExp(r'LT\/\d+\/\d+\/\d+\/\d+');
    return regex.firstMatch(text)?.group(0);
  }
}
