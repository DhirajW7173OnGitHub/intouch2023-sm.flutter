import 'package:flutter/material.dart';
import 'package:stock_management/utils/session_manager.dart';

class StackListScreen extends StatefulWidget {
  const StackListScreen({super.key});

  @override
  State<StackListScreen> createState() => _StackListScreenState();
}

class _StackListScreenState extends State<StackListScreen> {
  List<String> dropDownItem = ["IN", "OUT"];
  String? _selectCondition = "IN";

  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Stock List'),
      ),
      body: Card(
        color: Color.fromARGB(255, 223, 238, 245),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 15),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectCondition,
                    items: dropDownItem.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectCondition = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
