import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  final _detectedController = StreamController<String>.broadcast();
  Stream<String> get onMedicationDetected => _detectedController.stream;

  bool _isCameraAccessGranted = false;
  bool get isCameraAccessGranted => _isCameraAccessGranted;

  bool _isProcessing = false;
  bool _isStreaming = false;

  int _frameCount = 0;

  CameraController? get controller => _controller;

  Future<void> updateCameraAccessStatus() async {
    final status = await Permission.camera.status;
    _isCameraAccessGranted = status.isGranted;
  }

  Future<void> init() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
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
      _frameCount++;
      if (_isProcessing || _frameCount % 15 != 0) {
        return;
      }
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) return;

        final text = await _textRecognizer.processImage(inputImage);
        final reg = _extractRegNumber(text.text);
        debugPrint("APTIKTAS KODAS: $reg, TEKSTAS: ${text.text}");
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

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> focusOnPoint(Offset offset) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      await _controller!.setFocusPoint(offset);
      await _controller!.setExposurePoint(offset);
    } catch (e) {
      debugPrint("Nepavyko sufokusuoti kameros: $e");
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    if (_controller == null || !_controller!.value.isInitialized) return null;

    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    if (bytes.isEmpty) return null;

    final rotation = _controller!.description.sensorOrientation;
    final format = image.format.group == ImageFormatGroup.bgra8888
        ? InputImageFormat
              .bgra8888 //ios
        : InputImageFormat.nv21; //android
    final bytesPerRow = image.planes.isNotEmpty
        ? image.planes[0].bytesPerRow
        : image.width * 4;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: _rotationIntToImageRotation(rotation),
        format: format,
        bytesPerRow: bytesPerRow,
      ),
    );
  }

  String? _extractRegNumber(String text) {
    final regex = RegExp(r'LT\/\d+\/\d+\/\d+\/\d+');
    return regex.firstMatch(text)?.group(0);
  }
}
