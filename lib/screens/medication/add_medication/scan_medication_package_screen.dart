import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/services/camera_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class ScanMedicationPackageScreen extends StatefulWidget {
  const ScanMedicationPackageScreen({super.key});

  @override
  State<ScanMedicationPackageScreen> createState() =>
      _ScanMedicationPackageScreenState();
}

class _ScanMedicationPackageScreenState
    extends State<ScanMedicationPackageScreen>
    with WidgetsBindingObserver {
  late CameraService _cameraService;
  StreamSubscription? _streamSubscription;
  bool _isDetectedMedicationDialogShown = false;

  Future<void> _requestCameraDialog() async {
    if (_cameraService.isCameraAccessGranted) {
      await _cameraService.init();
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
          await _cameraService.updateCameraAccessStatus();
          await _cameraService.init();
          setState(() {});
        } else if (mounted) {
          Navigator.pop(context);
        }
      } else if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _onMedicationDetected(String registrationNr) async {
    _cameraService.stopStream();
    // final result = await FirebaseFirestore.instance
    //     .collection('medications')
    //     .where('normalized', isEqualTo: normalized)
    //     .limit(1)
    //     .get();

    //is db pranesti ar pagal koda rastas vaistas ar ne ir pakeisti pranesima nuo to

    //debugPrint("APTIKTAS KODAS: $registrationNr");

    if (!mounted || _isDetectedMedicationDialogShown) return;
    _isDetectedMedicationDialogShown = true;
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
      _cameraService.startStream();
    }
    _isDetectedMedicationDialogShown = false;
  }

  @override
  void initState() {
    super.initState();

    _cameraService = CameraService();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _cameraService.updateCameraAccessStatus();
      await _requestCameraDialog();
      if (_cameraService.isCameraAccessGranted) {
        _cameraService.startStream();

        _streamSubscription = _cameraService.onMedicationDetected.listen(
          (registrationNr) => _onMedicationDetected(registrationNr),
        );
      }

      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraService.controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _cameraService.init();
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CameraController? cameraController = _cameraService.controller;

    if (!_cameraService.isCameraAccessGranted ||
        cameraController != null && !cameraController.value.isInitialized) {
      return const Scaffold(
        appBar: AddMedicationAppBar(title: "Vaisto kodo skenavimas"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final ColorScheme colorScheme = ColorScheme.of(context);

    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vaisto kodo skenavimas"),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ThemedContainerWidget(
                doesHeightExpand: true,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "Ieškokite vaisto kodo ant pakuotės formatu:\n",
                      ),
                      TextSpan(
                        text: "LT/0/00/0000/000",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "Laikykite aptiktą vaisto kodą pažymėtame laukelyje",
                style: TextStyle(color: colorScheme.onPrimary, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: cameraController!.value.previewSize!.height,
                      height: cameraController.value.previewSize!.width,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.5),
                      BlendMode.srcOut,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            backgroundBlendMode: BlendMode.dstOut,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
