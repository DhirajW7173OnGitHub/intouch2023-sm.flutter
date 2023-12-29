import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stock_management/Database/apicaller.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/Scanner/scanner_screen.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/home_screen.dart';
import 'package:stock_management/model/product_list_model.dart';
import 'package:stock_management/utils/local_storage.dart';

import '../model/item_data.dart';
import '../utils/session_manager.dart';

class ScannerDetailsScreen extends StatefulWidget {
  const ScannerDetailsScreen({
    super.key,
  });

  @override
  State<ScannerDetailsScreen> createState() {
    return _ScannerDetailsScreenState();
  }
}

class _ScannerDetailsScreenState extends State<ScannerDetailsScreen> {
  final _apiCaller = ApiCaller();
  TextEditingController searchController = TextEditingController();

  bool _isAddInDetail = false;
  List<ItemOfStockDetails> productItem = [];
  String? _getScannedData = '';

  int? count = 1;
  int? _selectId;

  String? _selectProductName;

  bool _isSelectProduct = false;

  List<String> dropdownItem = ["IN", "OUT"];
  String? _selectValue = "IN";

  @override
  void initState() {
    super.initState();

    sessionManager.updateLoggedInTimeAndLoggedStatus();

    globalBloc.doFetchProductList(
        userId: StorageUtil.getString(localStorageKey.ID!.toString()));
  }

  _clickOnScanner() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (ctx) => const ScannerScreen(),
      ),
    )
        .then((value) async {
      print("Result Of Scanned Data : $value");
      if (value != null) {
        setState(() {
          _getScannedData = value;
          _isSelectProduct = true;
        });
      }
    });
  }

  _addDetails() {
    log('Selected product : ${_selectProductName!.isEmpty}');
    log('Selected Scanned Data : ${_getScannedData!.isEmpty}');

    if (_selectProductName == null && _getScannedData!.isEmpty) {
      globalUtils.showValidationError('Select product');
    } else if (_selectProductName!.isEmpty) {
      globalUtils.showValidationError('Select product');
    } //else if (_selectValue == null && _selectProductName!.isNotEmpty) {
    //   globalUtils.showValidationError('Selecte Priority');
    // }
    else {
      setState(() {
        productItem.add(
          ItemOfStockDetails(
            id: _selectId,
            code: _getScannedData,
            count: count,
            productName: _selectProductName ?? _getScannedData,
            //condition: _selectValue,
          ),
        );

        count = 1;
        _getScannedData = '';
        _selectValue == null;
        _isSelectProduct = true;
        _selectId = null;
        _selectProductName = "";
        _isAddInDetail = true;
      });
    }
  }

  _clickSubmit() {
    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("NO"),
    );
    Widget continueButton = ElevatedButton(
      onPressed: () async {
        Navigator.of(context).pop();
        if (productItem.length > 0) {
          placeStockInList();
        } else {
          globalUtils.showValidationError('Product List is Empty');
        }
      },
      child: const Text("YES"),
    );
    //Setup Dialog
    AlertDialog alert = AlertDialog(
      title: const Text('Are you sure you want to submit this Stock List?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  placeStockInList() async {
    var checkInternet = await InternetConnectionChecker().hasConnection;
    if (checkInternet == false) {
      globalUtils.showValidationError("Please,check Internet!");
    } else {
      Map<String, dynamic> item;

      Map<String, dynamic> productData = {
        "products": [],
      };
      for (var i = 0; i < productItem.length; i++) {
        item = {
          "name": productItem[i].productName,
          "prod_id": productItem[i].id,
          "quantity": productItem[i].count,
        };
        print('ProductItem : $item');

        productData["products"].add(item);
      }
      String userId = StorageUtil.getString(localStorageKey.ID!.toString());
      String condition = _selectValue.toString().toLowerCase();

      Map<String, dynamic> res = await _apiCaller.placedStockedInOutBySubmit(
        condition,
        userId,
        jsonEncode(productData),
      );
      if (res["errorcode"] == 1) {
        globalUtils.showValidationError(res['msg']);
      } else if (res["msg"] == "Stock added successfully") {
        globalUtils.showSlabDialog(
          barrierColor: Colors.transparent.withOpacity(0.6),
          context: context,
          widget: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Image(
                    image: AssetImage('assets/images/appLogo.png'),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "${res["msg"]}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  height: 12,
                ),
                Text("Congratulations! You have succesfully added}"),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      } else if (res['msg'] == "Stock Remove successfully") {
        globalUtils.showSlabDialog(
          barrierColor: Colors.transparent.withOpacity(0.6),
          context: context,
          widget: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Image(
                    image: AssetImage('assets/images/appLogo.png'),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "${res["msg"]}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  height: 12,
                ),
                Text("Congratulations! You have succesfully remove}"),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Detail'),
        actions: [
          IconButton(
            onPressed: () {
              //this code refresh _getScannedData
              setState(() {
                _getScannedData = "";
              });
            },
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                //By for loop we can remove added data from 0 to productItem.length
                for (int i = 0; i < productItem.length; i++) {
                  productItem.removeAt(i);
                  break;
                }
                // _isAddInDetail = false;
              });
            },
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                //check for displaying click submit button
                if (productItem.length > 0) {
                  _clickSubmit();
                } else {
                  globalUtils.showValidationError('No,Product Added yet');
                }
              },
              child: const Text(
                'SUBMIT',
                // style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          child: Column(
            children: [
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 8, left: 6, right: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: DropdownButton(
                              isExpanded: true,
                              value: _selectValue,
                              items: dropdownItem.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectValue = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: _getScannedData!.isNotEmpty
                                  ? StreamBuilder<List<Product>>(
                                      stream: globalBloc
                                          .getProductListofItem.stream,
                                      builder: ((context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        print(
                                            "Route List Length: ${snapshot.data!.length}");

                                        // Map List<Product> to List<String>
                                        List<String> productNames = snapshot
                                            .data!
                                            .map((product) => "${product.name}")
                                            .toList();
                                        List<String> productId = snapshot.data!
                                            .map((product) => "${product.id}")
                                            .toList();

                                        List<String> productCode = snapshot
                                            .data!
                                            .map((product) => "${product.code}")
                                            .toList();
                                        if (_getScannedData!.isNotEmpty &&
                                            productCode
                                                .contains(_getScannedData)) {
                                          _selectProductName = productNames[
                                              productCode
                                                  .indexOf(_getScannedData!)];
                                          _selectId = int.parse(
                                            productId[productCode
                                                .indexOf(_getScannedData!)],
                                          );
                                        }
                                        log('@@@@@@@@@@@@:${_selectId}');

                                        // else {
                                        //   globalUtils.showNegativeSnackBar(
                                        //       message:
                                        //           'Product Does not Exist in list.');
                                        // }

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    //check _getScannedData exist in list or not
                                                    Text(
                                                      productCode.contains(
                                                              _getScannedData!)
                                                          ? "${productNames[productCode.indexOf(_getScannedData!)]}"
                                                          : "Scanned Correct code.Product Does Not Exist in List",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    )
                                  : StreamBuilder<List<Product>>(
                                      stream: globalBloc
                                          .getProductListofItem.stream,
                                      builder: ((context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return Container();
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        print(
                                            "Route List Length: ${snapshot.data!.length}");

                                        // Map List<Product> to List<String>
                                        List<String> productNames = snapshot
                                            .data!
                                            .map((product) => "${product.name}")
                                            .toList();
                                        List<String> productId = snapshot.data!
                                            .map((product) => "${product.id}")
                                            .toList();

                                        List<String> productCode = snapshot
                                            .data!
                                            .map((product) => "${product.code}")
                                            .toList();
                                        //check is right then _selectProductName pass for next logic
                                        if (_getScannedData!.isNotEmpty &&
                                            productCode
                                                .contains(_getScannedData)) {
                                          _selectProductName = productNames[
                                              productCode
                                                  .indexOf(_getScannedData!)];
                                          // _selectId = int.parse(
                                          //   productNames[productId
                                          //       .indexOf(_selectProductName!)],
                                          // );
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: DropdownSearch<String>(
                                            //required to search bar label and more
                                            dropdownDecoratorProps:
                                                const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                labelText: "Select Product",
                                                labelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                              ),
                                            ),
                                            popupProps: const PopupProps.menu(
                                              searchFieldProps: TextFieldProps(
                                                cursorColor: Colors.blue,
                                              ),
                                              scrollbarProps: ScrollbarProps(),
                                              showSearchBox: true,
                                              menuProps: MenuProps(
                                                elevation: 8,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                            ),
                                            autoValidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            items: productNames,
                                            onChanged: (value) {
                                              setState(() {
                                                print(
                                                    "Selected Product: $value");
                                                _selectProductName = value;
                                                _selectId = int.parse(productId[
                                                    productNames
                                                        .indexOf(value!)]);
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: _clickOnScanner,
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  size: 38,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _addDetails();
                          },
                          child: const Text(
                            'ADD IN DETAILS',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          (productItem.isEmpty)
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text(
                                      'Data Not added',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    productItem.length,
                                    (index) {
                                      print('Length : ${productItem.length}');
                                      // log('Data of List :${item[index]}');
                                      return Card(
                                        elevation: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${productItem[index].code} ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(
                                                  "Product ID : ${productItem[index].id} ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(
                                                  "Product Name : ${productItem[index].productName} ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                // Text(
                                                //   "Condition : ${productItem[index].condition} ",
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodyLarge!
                                                //       .copyWith(
                                                //           fontWeight:
                                                //               FontWeight.bold),
                                                // ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 2),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Visibility(
                                                                visible: true,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        'MINUS PRESS');
                                                                    _updateItemCount(
                                                                        index,
                                                                        -1);
                                                                  },
                                                                  child: Text(
                                                                    '-',
                                                                    style: Theme.of(context).textTheme.headline1!.copyWith(
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(productItem[
                                                                      index]
                                                                  .count
                                                                  .toString()),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Visibility(
                                                                visible: true,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        'MINUS PRESS');
                                                                    _updateItemCount(
                                                                        index,
                                                                        1);
                                                                  },
                                                                  child: Text(
                                                                    '+',
                                                                    style: Theme.of(context).textTheme.headline1!.copyWith(
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container()),
                                                    Expanded(
                                                      flex: 1,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            productItem
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateItemCount(int index, int change) {
    setState(() {
      int updateCount = productItem[index].count! + change;
      if (updateCount >= 1) {
        productItem[index].count = updateCount;
      }
    });
  }
}
