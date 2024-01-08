import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    sessionManager.updateLoggedInTimeAndLoggedStatus();

    // var globalBloc.doFetchProductList(
    //     userId: StorageUtil.getString(localStorageKey.ID!.toString()));
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
                      if (!isScanCompleted) {
                        setState(() {
                          scannedCode = barcode.rawValue ?? '--';
                          //beacause Scanned Data get in json format hence decode it
                          Map<String, dynamic> json = jsonDecode(scannedCode);
                          // Decode Data user by String
                          code = json['code'] ?? '--';

                          log('BarCode Value : $scannedCode &&& Code : $code');
                          isScanCompleted = true;
                          Container(
                            color: Colors.red,
                          );
                        });

                        var productList = await globalBloc.doFetchProductList(
                            userId: StorageUtil.getString(
                                localStorageKey.ID!.toString()));
                        //check decode Scanned code data Present in product list
                        bool codeExist = productList.any(
                          (product) => product.code == code,
                        );
                        setState(
                          () {
                            if (codeExist) {
                              isScanCompleted = true;
                              Navigator.pop(context, code);
                            } else {
                              isScanCompleted = false;

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Scanned Code Data is not exist in list",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Please, Scanned Correct Code",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        );

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ScannerDetailsScreen(
                        //       code: scannedCode,
                        //     ),
                        //   ),
                        // );
                        // Navigator.pop(context, scannedCode);
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
