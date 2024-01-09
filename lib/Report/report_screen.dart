import 'package:flutter/material.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';
import 'package:stock_management/utils/session_manager.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndexForBottomBar = 1;

  Color _color = Colors.green;

  bool _isClicked = false;
  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();
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
      appBar: AppBar(
        title: const Text('Stock Report'),
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
            label: 'Stock Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            width: 200,
            height: 200,
            margin: EdgeInsets.all(_margin),
            color: _color,
            duration: const Duration(seconds: 1),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _margin = 50;
                      _color = Colors.pink;
                      _isClicked = true;
                    });
                  },
                  child: _isClicked
                      ? Container(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _margin = 0;
                                _color = Colors.green;
                                _isClicked = false;
                              });
                            },
                            child: Text('No'),
                          ),
                        )
                      : Text('Ok'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _margin = 0;
}
