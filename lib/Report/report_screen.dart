import 'package:flutter/material.dart';
import 'package:stock_management/utils/session_manager.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Report'),
      ),
    );
  }
}
  // TextEditingController searchController = TextEditingController();

  // bool _isAddInDetail = false;
  // List<ItemOfStockDetails> item = [];
  // String? _getScannedData = '';

  // int? count = 1;

  // String? _selectProductName;

  // bool _isSelectProduct = false;

  // List<String> dropdownItem = ["IN", "OUT"];
  // String? _selectValue; //= "IN";

  // @override
  // void initState() {
  //   super.initState();

  //   sessionManager.updateLoggedInTimeAndLoggedStatus();

  //   globalBloc.doFetchProductList(
  //       userId: StorageUtil.getString(localStorageKey.ID!.toString()));
  // }

  // _clickOnScanner() {
  //   Navigator.of(context)
  //       .push(
  //     MaterialPageRoute(
  //       builder: (ctx) => const ScannerScreen(),
  //     ),
  //   )
  //       .then((value) async {
  //     print("Result Of Scanned Data : $value");
  //     if (value != null) {
  //       setState(() {
  //         _getScannedData = value;
  //         _isSelectProduct = true;
  //       });
  //     }
  //   });
  // }

  // _addDetails() {
  //   log('Selected product : $_selectProductName');
  //   if (_selectValue == null && _selectProductName == null) {
  //     globalUtils.showValidationError('Select Priority And product Name');
  //   } else if (_selectValue != null && _selectProductName == null) {
  //     globalUtils.showValidationError('Enter or Scanned product Details');
  //   } else if (_selectValue == null && _selectProductName!.isNotEmpty) {
  //     globalUtils.showValidationError('Selecte Priority');
  //   } else {
  //     setState(() {
  //       item.add(
  //         ItemOfStockDetails(
  //           code: _getScannedData,
  //           count: count,
  //           productName: _selectProductName ?? _getScannedData,
  //           priority: _selectValue,
  //         ),
  //       );

  //       count = 1;
  //       _getScannedData = '';
  //       _selectValue == null;

  //       _isAddInDetail = true;
  //     });
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Stock Detail'),
  //     ),
  //     bottomSheet: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         ElevatedButton(
  //           onPressed: () {
  //             setState(() {
  //               for (int i = 0; i < item.length; i++) {
  //                 item.removeAt(i);
  //                 break;
  //               }
  //               // _isAddInDetail = false;
  //             });
  //           },
  //           child: const Text(
  //             'CANCEL',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         ElevatedButton(
  //             onPressed: () {
  //               globalUtils.showPositiveSnackBar(
  //                   context: context,
  //                   message: 'Scanned Data is submitted Successfully');
  //             },
  //             child: const Text(
  //               'SUBMIT',
  //               // style: TextStyle(color: Colors.white),
  //             ))
  //       ],
  //     ),
  //     body: Card(
  //       child: Padding(
  //         padding: const EdgeInsets.all(6.0),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                   margin: const EdgeInsets.only(left: 12),
  //                   width: MediaQuery.of(context).size.width * 0.3,
  //                   child: DropdownButton(
  //                     isExpanded: true,
  //                     value: _selectValue,
  //                     items: dropdownItem.map((String item) {
  //                       return DropdownMenuItem(
  //                         value: item,
  //                         child: Text(item),
  //                       );
  //                     }).toList(),
  //                     onChanged: (String? value) {
  //                       setState(() {
  //                         _selectValue = value;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 6,
  //             ),
  //             SizedBox(
  //               width: double.infinity,
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     flex: 4,
  //                     child: _getScannedData!.isNotEmpty
  //                         ? StreamBuilder<List<Product>>(
  //                             stream: globalBloc.getProductListofItem.stream,
  //                             builder: ((context, snapshot) {
  //                               if (!snapshot.hasData) {
  //                                 return Container();
  //                               }
  //                               if (snapshot.connectionState ==
  //                                   ConnectionState.waiting) {
  //                                 return const CircularProgressIndicator();
  //                               }
  //                               print(
  //                                   "Route List Length: ${snapshot.data!.length}");

  //                               // Map List<Product> to List<String>
  //                               List<String> productNames = snapshot.data!
  //                                   .map((product) =>
  //                                       "${product.name}(${product.code})")
  //                                   .toList();
  //                               List<String> productCode = snapshot.data!
  //                                   .map((product) => "${product.code}")
  //                                   .toList();
  //                               if (_getScannedData!.isNotEmpty &&
  //                                   productCode.contains(_getScannedData)) {
  //                                 _selectProductName = productNames[
  //                                     productCode.indexOf(_getScannedData!)];
  //                               }
  //                               String productNameText = '';
  //                               int scannedDataIndex =
  //                                   productCode.indexOf(_getScannedData!);

  //                               if (scannedDataIndex == -1) {
  //                                 productNameText =
  //                                     productNames[scannedDataIndex];
  //                               } else {
  //                                 productNameText =
  //                                     'Product not found'; // Provide a default value or handle accordingly
  //                               }

  //                               return Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 10.0, right: 10),
  //                                 child: Container(
  //                                   height: 50,
  //                                   decoration: BoxDecoration(
  //                                     border: Border.all(),
  //                                     borderRadius: BorderRadius.circular(10),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Row(
  //                                       children: [
  //                                         // Text(
  //                                         //   productNameText,
  //                                         //   style: Theme.of(context)
  //                                         //       .textTheme
  //                                         //       .bodyLarge,
  //                                         // ),

  //                                         Text(
  //                                           "${productNames[productCode.indexOf(_getScannedData!)]}",
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .bodyLarge,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               );
  //                             }),
  //                           )
  //                         : StreamBuilder<List<Product>>(
  //                             stream: globalBloc.getProductListofItem.stream,
  //                             builder: ((context, snapshot) {
  //                               if (!snapshot.hasData ||
  //                                   snapshot.data == null) {
  //                                 return Container();
  //                               }
  //                               if (snapshot.connectionState ==
  //                                   ConnectionState.waiting) {
  //                                 return const CircularProgressIndicator();
  //                               }
  //                               print(
  //                                   "Route List Length: ${snapshot.data!.length}");

  //                               // Map List<Product> to List<String>
  //                               List<String> productNames = snapshot.data!
  //                                   .map((product) =>
  //                                       "${product.name}(${product.code})")
  //                                   .toList();
  //                               List<String> productCode = snapshot.data!
  //                                   .map((product) => "${product.code}")
  //                                   .toList();
  //                               if (_getScannedData!.isNotEmpty &&
  //                                   productCode.contains(_getScannedData)) {
  //                                 _selectProductName = productNames[
  //                                     productCode.indexOf(_getScannedData!)];
  //                               }

  //                               return Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 10.0, right: 10),
  //                                 child: DropdownSearch<String>(
  //                                   dropdownDecoratorProps:
  //                                       const DropDownDecoratorProps(
  //                                     dropdownSearchDecoration: InputDecoration(
  //                                       labelText: "Select Product",
  //                                       labelStyle: TextStyle(
  //                                           fontWeight: FontWeight.w600),
  //                                       enabledBorder: OutlineInputBorder(),
  //                                     ),
  //                                   ),
  //                                   popupProps: const PopupProps.menu(
  //                                     searchFieldProps: TextFieldProps(
  //                                       cursorColor: Colors.blue,
  //                                     ),
  //                                     scrollbarProps: ScrollbarProps(),
  //                                     showSearchBox: true,
  //                                     menuProps: MenuProps(
  //                                       elevation: 8,
  //                                       borderRadius: BorderRadius.all(
  //                                         Radius.circular(16),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   autoValidateMode:
  //                                       AutovalidateMode.onUserInteraction,
  //                                   items: productNames,
  //                                   onChanged: (value) {
  //                                     setState(() {
  //                                       print("Selected Product: $value");

  //                                       _selectProductName = value;
  //                                       _isSelectProduct = true;
  //                                     });
  //                                   },
  //                                 ),
  //                               );
  //                             }),
  //                           ),
  //                   ),
  //                   Expanded(
  //                     flex: 1,
  //                     child: IconButton(
  //                       onPressed: _clickOnScanner,
  //                       icon: const Icon(
  //                         Icons.qr_code_scanner,
  //                         size: 38,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Container(
  //               height: 50,
  //               alignment: Alignment.bottomRight,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   _addDetails();
  //                 },
  //                 child: const Text(
  //                   'Add In Details',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Expanded(
  //               child: Scrollbar(
  //                 child: SingleChildScrollView(
  //                   scrollDirection: Axis.vertical,
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         (item.isEmpty)
  //                             ? Container(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.5,
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Data Not added',
  //                                     style: Theme.of(context)
  //                                         .textTheme
  //                                         .bodyLarge!
  //                                         .copyWith(
  //                                             fontWeight: FontWeight.w500),
  //                                   ),
  //                                 ),
  //                               )
  //                             : Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: List.generate(
  //                                   item.length,
  //                                   (index) {
  //                                     print('Length : ${item.length}');
  //                                     // log('Data of List :${item[index]}');
  //                                     return Card(
  //                                       elevation: 8,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: SizedBox(
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 '${item[index].code} ',
  //                                                 style: Theme.of(context)
  //                                                     .textTheme
  //                                                     .bodyLarge!
  //                                                     .copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                               ),
  //                                               Text(
  //                                                 "Product Name : ${item[index].productName} ",
  //                                                 style: Theme.of(context)
  //                                                     .textTheme
  //                                                     .bodyLarge!
  //                                                     .copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                               ),
  //                                               Text(
  //                                                 'Stock Given Priority : ${item[index].priority} ',
  //                                                 style: Theme.of(context)
  //                                                     .textTheme
  //                                                     .bodyLarge!
  //                                                     .copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                               ),
  //                                               Row(
  //                                                 children: [
  //                                                   Expanded(
  //                                                     flex: 1,
  //                                                     child: Container(
  //                                                       height: 30,
  //                                                       decoration: BoxDecoration(
  //                                                           borderRadius:
  //                                                               const BorderRadius
  //                                                                   .all(Radius
  //                                                                       .circular(
  //                                                                           5)),
  //                                                           border: Border.all(
  //                                                               color: Colors
  //                                                                   .black)),
  //                                                       child: Padding(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                 .symmetric(
  //                                                                 horizontal: 0,
  //                                                                 vertical: 2),
  //                                                         child: Row(
  //                                                           crossAxisAlignment:
  //                                                               CrossAxisAlignment
  //                                                                   .center,
  //                                                           mainAxisAlignment:
  //                                                               MainAxisAlignment
  //                                                                   .spaceEvenly,
  //                                                           children: [
  //                                                             Visibility(
  //                                                               visible: true,
  //                                                               child:
  //                                                                   GestureDetector(
  //                                                                 onTap: () {
  //                                                                   print(
  //                                                                       'MINUS PRESS');
  //                                                                   _updateItemCount(
  //                                                                       index,
  //                                                                       -1);
  //                                                                 },
  //                                                                 child: Text(
  //                                                                   '-',
  //                                                                   style: Theme.of(context).textTheme.headline1!.copyWith(
  //                                                                       fontSize:
  //                                                                           24,
  //                                                                       fontWeight:
  //                                                                           FontWeight
  //                                                                               .w500,
  //                                                                       height:
  //                                                                           1,
  //                                                                       color: Colors
  //                                                                           .grey[800]),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                             const SizedBox(
  //                                                               width: 10,
  //                                                             ),
  //                                                             Text(item[index]
  //                                                                 .count
  //                                                                 .toString()),
  //                                                             const SizedBox(
  //                                                               width: 10,
  //                                                             ),
  //                                                             Visibility(
  //                                                               visible: true,
  //                                                               child:
  //                                                                   GestureDetector(
  //                                                                 onTap: () {
  //                                                                   print(
  //                                                                       'MINUS PRESS');
  //                                                                   _updateItemCount(
  //                                                                       index,
  //                                                                       1);
  //                                                                 },
  //                                                                 child: Text(
  //                                                                   '+',
  //                                                                   style: Theme.of(context).textTheme.headline1!.copyWith(
  //                                                                       fontSize:
  //                                                                           24,
  //                                                                       fontWeight:
  //                                                                           FontWeight
  //                                                                               .w500,
  //                                                                       height:
  //                                                                           1,
  //                                                                       color: Colors
  //                                                                           .grey[800]),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Expanded(
  //                                                       flex: 2,
  //                                                       child: Container()),
  //                                                   Expanded(
  //                                                     flex: 1,
  //                                                     child: IconButton(
  //                                                       onPressed: () {
  //                                                         setState(() {
  //                                                           item.removeAt(
  //                                                               index);
  //                                                         });
  //                                                       },
  //                                                       icon: const Icon(
  //                                                         Icons.delete,
  //                                                         color: Colors.red,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               )
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _updateItemCount(int index, int change) {
  //   setState(() {
  //     int updateCount = item[index].count! + change;
  //     if (updateCount >= 1) {
  //       item[index].count = updateCount;
  //     }
  //   });
  // }








 // TextEditingController searchController = TextEditingController();

  // bool _isAddInDetail = false;
  // List<ItemOfStockDetails> item = [];
  // String? _getScannedData = '';

  // int? count = 1;
  // List<Product> productList = [];

  // bool _isClickScanner = false;

  // bool _isSelectProduct = false;

  // String? _selectProductFromDrop = "";

  // List<String> dropdownItem = ["IN", "OUT"];
  // String? _selectValue; //= "IN";

  // @override
  // void initState() {
  //   super.initState();

  //   sessionManager.updateLoggedInTimeAndLoggedStatus();

  //   globalBloc.doFetchProductList(
  //       userId: StorageUtil.getString(localStorageKey.ID!.toString()));
  // }

  // _clickOnScanner() {
  //   Navigator.of(context)
  //       .push(
  //     MaterialPageRoute(
  //       builder: (ctx) => const ScannerScreen(),
  //     ),
  //   )
  //       .then((value) async {
  //     print("Result Of Scanned Data : $value");
  //     if (value != null) {
  //       setState(() {
  //         _getScannedData = value;
  //         _isSelectProduct = true;
  //       });
  //       _isClickScanner = true;
  //     }
  //   });
  // }

  // _addDetails() {
  //   if (_getScannedData!.isEmpty && _selectValue == null) {
  //     globalUtils.showValidationError('Select Priority And product Name');
  //   } else if (_selectValue != null && _getScannedData!.isEmpty) {
  //     globalUtils.showValidationError('Enter or Scanned product Details');
  //   } else if (_selectValue == null && _getScannedData!.isNotEmpty) {
  //     globalUtils.showValidationError('Selecte Priority');
  //   } else {
  //     setState(() {
  //       //   List<String> proName = productList
  //       //       .map((product) => "${product.name}(${product.code}")
  //       //       .toList();
  //       //   List<String> proCode =
  //       //       productList.map((product) => "${product.code}").toList();
  //       //   _selectProductFromDrop = proName[proCode.indexOf(_getScannedData!)];
  //       //   log('000000000000000:$_selectProductFromDrop');
  //       item.add(
  //         ItemOfStockDetails(
  //           code: _getScannedData,
  //           count: count,
  //           productName: _getScannedData,
  //           priority: _selectValue,
  //         ),
  //       );

  //       //Reset count and hide details section
  //       count = 1;
  //       _getScannedData = '';
  //       _selectValue == null;
  //       //_selectProductFromDrop = "";

  //       _isAddInDetail = true;
  //     });
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return 
  //   Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Stock Detail'),
  //     ),
  //     bottomSheet: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         ElevatedButton(
  //           onPressed: () {
  //             setState(() {
  //               for (int i = 0; i < item.length; i++) {
  //                 item.removeAt(i);
  //                 break;
  //               }
  //               // _isAddInDetail = false;
  //             });
  //           },
  //           child: const Text(
  //             'CANCEL',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         ElevatedButton(
  //             onPressed: () {
  //               globalUtils.showPositiveSnackBar(
  //                   context: context,
  //                   message: 'Scanned Data is submitted Successfully');
  //             },
  //             child: const Text(
  //               'SUBMIT',
  //               // style: TextStyle(color: Colors.white),
  //             ))
  //       ],
  //     ),
  //     body: Card(
  //       child: Padding(
  //         padding: const EdgeInsets.all(6.0),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                   margin: const EdgeInsets.only(left: 12),
  //                   width: MediaQuery.of(context).size.width * 0.3,
  //                   child: DropdownButton(
  //                     isExpanded: true,
  //                     value: _selectValue,
  //                     items: dropdownItem.map((String item) {
  //                       return DropdownMenuItem(
  //                         value: item,
  //                         child: Text(item),
  //                       );
  //                     }).toList(),
  //                     onChanged: (String? value) {
  //                       setState(() {
  //                         _selectValue = value;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 6,
  //             ),
  //             SizedBox(
  //               width: double.infinity,
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     flex: 4,
  //                     child: StreamBuilder<List<Product>>(
  //                       stream: globalBloc.getProductListofItem.stream,
  //                       builder: ((context, snapshot) {
  //                         if (!snapshot.hasData) {
  //                           return Container();
  //                         }
  //                         if (snapshot.connectionState ==
  //                             ConnectionState.waiting) {
  //                           return const CircularProgressIndicator();
  //                         }
  //                         print("Route List Length: ${snapshot.data!.length}");

  //                         // Map List<Product> to List<String>
  //                         List<String> productNames = snapshot.data!
  //                             .map((product) =>
  //                                 "${product.name}(${product.code})")
  //                             .toList();
  //                         List<String> productCode = snapshot.data!
  //                             .map((product) => "${product.code}")
  //                             .toList();

  //                         return Padding(
  //                           padding:
  //                               const EdgeInsets.only(left: 10.0, right: 10),
  //                           child: DropdownSearch<String>(
  //                             dropdownDecoratorProps: DropDownDecoratorProps(
  //                               dropdownSearchDecoration: InputDecoration(
  //                                 labelText: (_getScannedData!.isNotEmpty &&
  //                                         productCode.contains(_getScannedData))
  //                                     ? "${productNames[productCode.indexOf(_getScannedData!)]}"
  //                                     : "Select Product",
  //                                 labelStyle: const TextStyle(
  //                                     fontWeight: FontWeight.w600),
  //                                 enabledBorder: OutlineInputBorder(),
  //                               ),
  //                             ),
  //                             popupProps: const PopupProps.menu(
  //                               searchFieldProps: TextFieldProps(
  //                                 cursorColor: Colors.blue,
  //                               ),
  //                               scrollbarProps: ScrollbarProps(),
  //                               showSearchBox: true,
  //                               menuProps: MenuProps(
  //                                 elevation: 8,
  //                                 borderRadius: BorderRadius.all(
  //                                   Radius.circular(16),
  //                                 ),
  //                               ),
  //                             ),
  //                             autoValidateMode:
  //                                 AutovalidateMode.onUserInteraction,
  //                             items: productNames,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 print("Selected Product: $value");

  //                                 _getScannedData = value;

  //                                 _isSelectProduct = true;
  //                               });
  //                             },
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 1,
  //                     child: IconButton(
  //                       onPressed: _clickOnScanner,
  //                       icon: const Icon(
  //                         Icons.qr_code_scanner,
  //                         size: 38,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Container(
  //               height: 50,
  //               alignment: Alignment.bottomRight,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   _addDetails();
  //                 },
  //                 child: const Text(
  //                   'Add In Details',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Expanded(
  //               child: Scrollbar(
  //                 child: SingleChildScrollView(
  //                   scrollDirection: Axis.vertical,
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         (item.isEmpty)
  //                             ? Container(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.5,
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Data Not added',
  //                                     style: Theme.of(context)
  //                                         .textTheme
  //                                         .bodyLarge!
  //                                         .copyWith(
  //                                             fontWeight: FontWeight.w500),
  //                                   ),
  //                                 ),
  //                               )
  //                             : Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: List.generate(
  //                                   item.length,
  //                                   (index) {
  //                                     print('Length : ${item.length}');
  //                                     // log('Data of List :${item[index]}');
  //                                     return Card(
  //                                       elevation: 8,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: SizedBox(
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 '${item[index].code} ',
  //                                                 style: Theme.of(context)
  //                                                     .textTheme
  //                                                     .bodyLarge!
  //                                                     .copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                               ),
  //                                               Text(
  //                                                 "Product Name : ${item[index].productName} ",
  //                                                 style: Theme.of(context)
  //                                                     .textTheme
  //                                                     .bodyLarge!
  //                                                     .copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                               ),
  //                                               Text(
  //                                                 'Stock Given Priority : ${item[index].priority} ',
  //                                                 style: Theme.of(context)
  //                                                     .textTheme
  //                                                     .bodyLarge!
  //                                                     .copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                               ),
  //                                               Row(
  //                                                 children: [
  //                                                   Expanded(
  //                                                     flex: 1,
  //                                                     child: Container(
  //                                                       height: 30,
  //                                                       decoration: BoxDecoration(
  //                                                           borderRadius:
  //                                                               const BorderRadius
  //                                                                   .all(Radius
  //                                                                       .circular(
  //                                                                           5)),
  //                                                           border: Border.all(
  //                                                               color: Colors
  //                                                                   .black)),
  //                                                       child: Padding(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                 .symmetric(
  //                                                                 horizontal: 0,
  //                                                                 vertical: 2),
  //                                                         child: Row(
  //                                                           crossAxisAlignment:
  //                                                               CrossAxisAlignment
  //                                                                   .center,
  //                                                           mainAxisAlignment:
  //                                                               MainAxisAlignment
  //                                                                   .spaceEvenly,
  //                                                           children: [
  //                                                             Visibility(
  //                                                               visible: true,
  //                                                               child:
  //                                                                   GestureDetector(
  //                                                                 onTap: () {
  //                                                                   print(
  //                                                                       'MINUS PRESS');
  //                                                                   _updateItemCount(
  //                                                                       index,
  //                                                                       -1);
  //                                                                 },
  //                                                                 child: Text(
  //                                                                   '-',
  //                                                                   style: Theme.of(context).textTheme.headline1!.copyWith(
  //                                                                       fontSize:
  //                                                                           24,
  //                                                                       fontWeight:
  //                                                                           FontWeight
  //                                                                               .w500,
  //                                                                       height:
  //                                                                           1,
  //                                                                       color: Colors
  //                                                                           .grey[800]),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                             const SizedBox(
  //                                                               width: 10,
  //                                                             ),
  //                                                             Text(item[index]
  //                                                                 .count
  //                                                                 .toString()),
  //                                                             const SizedBox(
  //                                                               width: 10,
  //                                                             ),
  //                                                             Visibility(
  //                                                               visible: true,
  //                                                               child:
  //                                                                   GestureDetector(
  //                                                                 onTap: () {
  //                                                                   print(
  //                                                                       'MINUS PRESS');
  //                                                                   _updateItemCount(
  //                                                                       index,
  //                                                                       1);
  //                                                                 },
  //                                                                 child: Text(
  //                                                                   '+',
  //                                                                   style: Theme.of(context).textTheme.headline1!.copyWith(
  //                                                                       fontSize:
  //                                                                           24,
  //                                                                       fontWeight:
  //                                                                           FontWeight
  //                                                                               .w500,
  //                                                                       height:
  //                                                                           1,
  //                                                                       color: Colors
  //                                                                           .grey[800]),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Expanded(
  //                                                       flex: 2,
  //                                                       child: Container()),
  //                                                   Expanded(
  //                                                     flex: 1,
  //                                                     child: IconButton(
  //                                                       onPressed: () {
  //                                                         setState(() {
  //                                                           item.removeAt(
  //                                                               index);
  //                                                         });
  //                                                       },
  //                                                       icon: const Icon(
  //                                                         Icons.delete,
  //                                                         color: Colors.red,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               )
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _updateItemCount(int index, int change) {
  //   setState(() {
  //     int updateCount = item[index].count! + change;
  //     if (updateCount >= 1) {
  //       item[index].count = updateCount;
  //     }
  //   });
  // }