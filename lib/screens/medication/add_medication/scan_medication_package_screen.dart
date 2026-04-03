import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_medication_info_screen.dart';
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
  late MedicationProvider _medicationProvider;
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

  String _getMessageOnMedicationDetected(
    String registrationNr,
    UserMedication? medication,
  ) {
    String message = "Pagal kodą $registrationNr";
    message = medication == null
        ? "$message nerasta duomenų sistemoje, ar norite įvesti duomenis patys?"
        : "$message rastas vaistas ${medication.name}, ar norite jį pridėti?";
    return message;
  }

  void _onMedicationDetected(String registrationNr) async {
    _cameraService.stopStream();
    UserMedication? medication = await _medicationProvider
        .getMedicationFromRegistrationCode(registrationNr);

    if (!mounted || _isDetectedMedicationDialogShown) return;
    _isDetectedMedicationDialogShown = true;
    bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        message: _getMessageOnMedicationDetected(registrationNr, medication),
        title: "Vaistas aptiktas",
        rightOptionText: "Tęsti",
        leftOptionText: "Atšaukti",
        rightSideHighlighted: true,
      ),
    );
    if (!mounted) return;
    if (didConfirm == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddMedicationInfoScreen(prefilledMedication: medication),
        ),
      );
    } else {
      _cameraService.startStream();
    }
    _isDetectedMedicationDialogShown = false;
  }

  @override
  void initState() {
    super.initState();

    _cameraService = CameraService();
    _medicationProvider = context.read<MedicationProvider>();

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
      backgroundColor: colorScheme.secondary,
      appBar: AddMedicationAppBar(title: "Vaisto kodo skenavimas"),
      body: GestureDetector(
        onTapDown: (details) {
          final box = context.findRenderObject() as RenderBox;
          final offset = details.localPosition;
          final dx = offset.dx / box.size.width;
          final dy = offset.dy / box.size.height;
          _cameraService.focusOnPoint(Offset(dx, dy));
        },
        child: Column(
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
                    child: Center(
                      child: AspectRatio(
                        aspectRatio:
                            cameraController!.value.previewSize!.height /
                            cameraController.value.previewSize!.width,
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
      ),
    );
  }
}
