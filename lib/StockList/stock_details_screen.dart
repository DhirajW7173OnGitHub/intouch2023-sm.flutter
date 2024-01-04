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

  @override
  void initState() {
    super.initState();
    // print('@@@@@@@@@@@@@:${widget.reqId}');
    globalBloc.dofetchStockDetailsData(
      userId: StorageUtil.getString(localStorageKey.ID!.toString()),
      reqId: widget.reqId.toString(),
    );
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
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedBottomBarindex!,
      //   onTap: (value) {
      //     _selectedIndexFromBottomBar(value);
      //   },
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
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
          StreamBuilder<List<StockDatum>>(
            stream: globalBloc.getProductDetails.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data found'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      StockDetailsWidget(
                        id: snapshot.data![index].id,
                        prodName: snapshot.data![index].name,
                        qty: snapshot.data![index].qty,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
