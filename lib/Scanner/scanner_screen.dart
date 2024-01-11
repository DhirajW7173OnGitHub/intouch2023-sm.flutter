import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/utils/local_storage.dart';

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

  String? code;

  bool isFlashOn = false;
  bool isScanCompleted = false;

  bool allowScanning = true;

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
        isScanCompleted = false;
      }
    });
  }

  void closeScan() {
    isScanCompleted = false;
  }

  void handleScanData(BuildContext context, String scannedCode) async {
    try {
      // Decode Scanned Data in JSON format
      Map<String, dynamic> json = jsonDecode(scannedCode);
      code = json['code'] ?? '--';

      log('BarCode Value: $scannedCode &&& Code: $code');
      isScanCompleted = true;

      var productList = await globalBloc.doFetchProductList(
          userId: StorageUtil.getString(localStorageKey.ID!.toString()));

      // Check if the decoded code exists in the product list
      bool codeExist = productList.any((product) => product.code == code);
      if (codeExist) {
        isScanCompleted = true;
        Navigator.pop(context, code);
      } else {
        setState(() {
          //isScanCompleted = false;
          allowScanning = false;
          controller.stop();
        });
        showSnackbar(context, "Scanned Data is not Valid.Scan again?");
      }
    } catch (e) {
      setState(() {
        //isScanCompleted = false;
        allowScanning = false;
        controller.stop();
      });

      showSnackbar(context, "Scanned Data is not Valid.Scan again?");
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 10),
        content: Text(
          message,
          style: GoogleFonts.adamina(color: Colors.black),
        ),
        action: SnackBarAction(
          textColor: Colors.red,
          label: 'Scan Again',
          onPressed: () {
            scanAgain();
          },
        ),
      ),
    );
  }

  void scanAgain() {
    log('Scanning again...');
    setState(() {
      allowScanning = true;
      controller.start();
      //isScanCompleted = false;
    });
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
                    onDetect: (barcode, args) async {
                      if (!isScanCompleted && allowScanning) {
                        setState(() {
                          scannedCode = barcode.rawValue ?? '--';
                        });

                        handleScanData(context, scannedCode);
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
                      print('Image Icon Press for the selection of Image ');
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
