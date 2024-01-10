import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/StockList/Model/stock_list_model.dart';
import 'package:stock_management/StockList/Widget/stock_list_widget.dart';
import 'package:stock_management/StockList/stock_details_screen.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';
import 'package:stock_management/utils/local_storage.dart';
import 'package:stock_management/utils/session_manager.dart';

class StackListScreen extends StatefulWidget {
  const StackListScreen({super.key});

  @override
  State<StackListScreen> createState() => _StackListScreenState();
}

class _StackListScreenState extends State<StackListScreen> {
  DateTime now = DateTime.now();

  List<String> _selectedChips = [];
  int? _selectedIndex;
  String? currentDate;

  int? _selectedIndexForBottomBar = 1;

  final List<String> _listOfStockByDate = [
    "Today's Stock",
    "Tomorrow's Stock",
    "This Week Stock",
    "Custom Date"
  ];

  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();

    currentDate = DateFormat('yyyy-MM-dd ').format(now);

    _getInitialSelectedIndex();
  }

  void _getInitialSelectedIndex() {
    Future.delayed(const Duration(microseconds: 200), () async {
      try {
        Map args = ModalRoute.of(context)!.settings.arguments as Map;

        if (args != null) {
          print('${args['userSelectedIndex']}');
          if (args['userSelectedIndex'] == 0) {
            log('body in jp: ${currentDate}');
            setState(() {
              _selectedIndex = 0;
              _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
                  currentDate!, currentDate!);
            });
          } else if (args['userSelectedIndex'] == 1) {
            setState(() {
              _selectedIndex = 1;
              String startdate = DateFormat('yyyy-MM-dd').format(
                DateTime.now().add(const Duration(days: 1)),
              );
              String enddate = DateFormat('yyyy-MM-dd').format(
                DateTime.now().add(const Duration(days: 1)),
              );
              _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
                  startdate, enddate);
            });
          } else if (args['userSelectedIndex'] == 2) {
            setState(() {
              _selectedIndex = 2;
              String startdate = DateFormat('yyyy-MM-dd').format(
                DateTime.now().subtract(const Duration(days: -7)),
              );
              String enddate = DateFormat('yyyy-MM-dd').format(
                DateTime.now(),
              );
              _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
                  startdate, enddate);
            });
          } else if (args['userSelectedIndex'] == 3) {
            setState(() {
              _selectedIndex = 3;
              _getCustom(context);
            });
          } else {
            setState(() {
              _selectedIndex = 0;
              _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
                  currentDate!, currentDate!);
            });
          }
        }
      } catch (e) {
        print('ERROR in route: $e');
      }
    });
  }

  _getStock(String user, String sDate, String eDate) {
    globalBloc.doFetchListOfStockByDate(
      userId: user,
      endDate: eDate,
      startDate: sDate,
    );
  }

  _getCustom(BuildContext context) async {
    //  DateTime _selectTime = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month - 1, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[500],
            // colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    _getStock(
        StorageUtil.getString(localStorageKey.ID!.toString()),
        pickedDate.toString().split(" ")[0],
        pickedDate.toString().split(" ")[0]);
  }

  _showStockList(String days) {
    switch (days) {
      case "Today's Stock":
        _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
            currentDate!, currentDate!);
        break;
      case "Tomorrow's Stock":
        String endDate = DateFormat("yyyy-MM-dd").format(
          DateTime.now().add(
            const Duration(days: 1),
          ),
        );

        _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
            currentDate!, endDate);
        break;
      case "This Week Stock":
        String startDate = DateFormat('yyyy-MM-dd').format(
          DateTime.now().add(
            const Duration(days: -7),
          ),
        );
        // String endDate = DateFormat('yyyy-MM-dd').format(
        //   DateTime.now().add(
        //     const Duration(days: 1),
        //   ),
        // );
        _getStock(StorageUtil.getString(localStorageKey.ID!.toString()),
            startDate, currentDate!);
        break;
      case "Custom Date":
        _getCustom(context);
        break;
    }
  }

  _onTapStock(Stockdiary args) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailScreen(
          reqId: args.id,
        ),
        // settings: RouteSettings(
        //   arguments: args,
        // ),
      ),
    );
  }

  _selecctBottomNavigationBar(int index) {
    switch (index) {
      case 0:
        CommonCall.homeIconCall(context);
        break;
      case 2:
        CommonCall.personIconCall(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 230, 227, 227),
      appBar: AppBar(
        title: const Text('Stock List'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selecctBottomNavigationBar(index);
          });
        },
        selectedItemColor: CommonColor.BOTTOM_SELECT_COLOR,
        unselectedItemColor: CommonColor.BOTTOM_UNSELECT_COLOR,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndexForBottomBar!,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Stock List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _listOfStockByDate.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _selectedChips = [];
                        //log('INDEX $index ${_selectedIndex?[index]}');
                      });
                      _showStockList(_listOfStockByDate[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xffD6D6D6),
                        ),
                        color: (_selectedIndex == index)
                            ? Colors.red
                            : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            _listOfStockByDate[index],
                            style: (_selectedIndex == index)
                                ? Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(fontSize: 16, color: Colors.white)
                                : Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: StreamBuilder<List<Stockdiary>>(
              stream: globalBloc.getStockListdata.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No data found',
                      style: gse.textStyle,
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        StockListWidget(
                          onTap: () {
                            print('Tapped >>>');
                            _onTapStock(snapshot.data![index]);
                          },
                          id: snapshot.data![index].id,
                          createdAt: DateFormat('yyyy-MMM-dd').format(
                            DateTime.parse(snapshot.data![index].createdAt),
                          ),
                          transType: snapshot.data![index].transType,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
