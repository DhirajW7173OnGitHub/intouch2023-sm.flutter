import 'package:flutter/material.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/StockList/Model/stock_details_model.dart';
import 'package:stock_management/StockList/Widget/stock_details_widget.dart';
import 'package:stock_management/utils/local_storage.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({
    super.key,
    required this.reqId,
  });

  final int? reqId;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
//  int? _selectedBottomBarindex = 1;

  List<StockDatum> listOfStockDetails = [];

  @override
  void initState() {
    super.initState();

    _getDetailsOnStart();
  }

  _getDetailsOnStart() async {
    var res = await globalBloc.dofetchStockDetailsData(
      userId: StorageUtil.getString(localStorageKey.ID!.toString()),
      reqId: widget.reqId.toString(),
    );

    listOfStockDetails = res.stockDetails;
  }

  // _clickOnHomeIcon() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const HomeScreen(),
  //     ),
  //   );
  // }

  // _clickOnPersonIcon() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const UserProfileScreen(),
  //     ),
  //   );
  // }

  // _selectedIndexFromBottomBar(int index) {
  //   switch (index) {
  //     case 0:
  //       _clickOnHomeIcon();
  //       break;
  //     case 2:
  //       _clickOnPersonIcon();
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedBottomBarindex!,
      //   onTap: (value) {
      //     _selectedIndexFromBottomBar(value);
      //   },
      //   backgroundColor: Colors.white,
      //   selectedItemColor: CommonColor.BOTTOM_UNSELECT_COLOR,
      //   unselectedItemColor:CommonColor.BOTTOM_SELECT_COLOR,
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Product Details',
      //       icon: Icon(Icons.list),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Person',
      //       icon: Icon(Icons.person),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          StreamBuilder<StockDetailsModel>(
            stream: globalBloc.getProductDetails.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No data found'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  UserDetailsWidget(
                    tCount: snapshot.data!.sumOfQty,
                    userId: snapshot.data!.user.userId,
                    userName: snapshot.data!.user.username,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listOfStockDetails.length,
                    itemBuilder: (context, index) {
                      final listStock = listOfStockDetails[index];
                      return Column(
                        children: [
                          StockDetailsWidget(
                            stockData: listStock,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
