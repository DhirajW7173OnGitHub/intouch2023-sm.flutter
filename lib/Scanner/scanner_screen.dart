import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../utils/session_manager.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  String scannedCode = '';

  ImagePicker image = ImagePicker();

  bool isFlashOn = false;
  bool isScanCompleted = false;

  @override
  void initState() {
    super.initState();

    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  _clickOnImageIcon() async {
    var img = await image.pickImage(source: ImageSource.gallery);

    setState(() {
      if (img != null) {
        var selectedImage = File(img.path);
        log('Selected Image :${selectedImage.path}');
        controller.analyzeImage(selectedImage.path);
      }
    });
  }

  void closeScan() {
    isScanCompleted = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('QR-Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    allowDuplicates: true,
                    onDetect: (barcode, args) {
                      if (!isScanCompleted) {
                        setState(() {
                          scannedCode = barcode.rawValue ?? '--';
                          log('BarCode Value : $scannedCode');
                          isScanCompleted = true;
                          Container(
                            color: Colors.red,
                          );
                        });

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ScannerDetailsScreen(
                        //       code: scannedCode,
                        //     ),
                        //   ),
                        // );
                        Navigator.pop(context, scannedCode);
                      }
                    },
                  ),
                  QRScannerOverlay(
                    scanAreaHeight: 250,
                    scanAreaWidth: 250,
                    borderColor: Colors.white,
                    overlayColor: Colors.black,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _clickOnImageIcon();
                      print('Image Icon Press for selection of Image ');
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFlashOn = !isFlashOn;
                      });
                      controller.toggleTorch();
                    },
                    icon: isFlashOn
                        ? const Icon(
                            Icons.flash_off,
                            color: Colors.white,
                          )
                        : const Icon(Icons.flash_on),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
