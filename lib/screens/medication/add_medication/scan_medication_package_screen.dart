import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';

class ScanMedicationPackageScreen extends StatefulWidget {
  const ScanMedicationPackageScreen({super.key});

  @override
  State<ScanMedicationPackageScreen> createState() =>
      _ScanMedicationPackageScreenState();
}

class _ScanMedicationPackageScreenState
    extends State<ScanMedicationPackageScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraAccessGranted = false;
  bool _isProcessingImage = false;
  bool _isStreamingImages = false;
  final TextRecognizer textRecognizer = TextRecognizer();

  Future<void> _checkIsCameraAllowed() async {
    final status = await Permission.camera.status;
    _isCameraAccessGranted = status.isGranted;
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    await _cameraController!
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                //TODO pranesti kad nesuteikia kameros leidimo
                break;
              default:
                break;
            }
          }
        });
  }

  Future<void> _requestCameraDialog() async {
    await _checkIsCameraAllowed();
    if (_isCameraAccessGranted) {
      await _initializeCamera();
      setState(() {});
    } else if (mounted) {
      final bool? didConfirm = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          message:
              "Ar leisite kitame lange suteikti kameros prieigą, kad būtų galima skenuoti vaisto pakuotę?",
          title: "Kameros suteikimas",
          rightOptionText: "Suteikti",
          leftOptionText: "Atšaukti",
          rightSideHighlighted: true,
        ),
      );
      if (didConfirm == true) {
        final requestResult = await Permission.camera.request();
        if (requestResult.isGranted) {
          _isCameraAccessGranted = true;
          await _initializeCamera();
          setState(() {});
        } else if (mounted) {
          Navigator.pop(context);
        }
      } else if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _stopImageStream() async {
    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
      _isStreamingImages = false;
    }
  }

  void _onMedicationDetected(String registrationNr) async {
    await _stopImageStream();

    // final result = await FirebaseFirestore.instance
    //     .collection('medications')
    //     .where('normalized', isEqualTo: normalized)
    //     .limit(1)
    //     .get();

    if (!mounted) return;
    bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        message:
            "Pagal kodą $registrationNr aptiktas VAISTAS, ar norite jį pridėti?",
        title: "Vaistas aptiktas",
        rightOptionText: "Pridėti",
        leftOptionText: "Atšaukti",
        rightSideHighlighted: true,
      ),
    );
    if (!mounted) return;
    if (didConfirm == true) {
      //prefilled vaistas i kita screen
    } else {
      _startImageStream();
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: InputImageRotation.rotation0deg, // adjust if needed
        format: InputImageFormat.nv21, // Android typically
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    return inputImage;
  }

  String? extractRegNumber(String text) {
    final regex = RegExp(r'LT\/\d+\/\d+\/\d+\/\d+');
    final match = regex.firstMatch(text);
    return match?.group(0);
  }

  void _startImageStream() {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isStreamingImages) {
      debugPrint(
        "NULLAI TAI NEPRAEJO: $_cameraController, ${_cameraController!.value.isInitialized}, $_isStreamingImages",
      );
      return;
    }
    _isStreamingImages = true;
    _cameraController!.startImageStream((CameraImage image) async {
      if (_isProcessingImage) return;
      _isProcessingImage = true;
      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) return;

        final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage,
        );
        final String text = recognizedText.text;
        final String? registrationNr = extractRegNumber(text);

        debugPrint("VAISTO KODAS: $registrationNr");

        if (registrationNr != null) {
          _onMedicationDetected(registrationNr);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _isProcessingImage = false;
      }
    });
  }

  // Future<void> _onTakePhoto() async {
  //   XFile photo = await _cameraController!.takePicture();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestCameraDialog();
      _startImageStream();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraAccessGranted ||
        _cameraController != null && !_cameraController!.value.isInitialized) {
      return const Scaffold(
        appBar: AddMedicationAppBar(title: "Vaisto kodo skenavimas"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final ColorScheme colorScheme = ColorScheme.of(context);

    return Scaffold(
      //backgroundColor: ColorScheme.of(context).primary,
      appBar: AddMedicationAppBar(title: "Vaisto kodo skenavimas"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CameraPreview(_cameraController!),
            IconButton(
              onPressed: () {},
              icon: TweenAnimationBuilder<double>(
                curve: Curves.easeOutSine,
                duration: const Duration(milliseconds: 150),
                tween: Tween(begin: 0, end: 55),
                builder: (BuildContext context, double value, Widget? child) {
                  return Icon(
                    Icons.camera_alt,
                    size: value,
                    color: colorScheme.onPrimary,
                  );
                },
              ),
              style: IconButton.styleFrom(backgroundColor: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
