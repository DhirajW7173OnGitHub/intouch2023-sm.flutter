import 'package:flutter/material.dart';

class CommonLogOut {
  static commonLogoutDialog(
    BuildContext context, {
    required Function() onTapYes,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Alert",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          content: Text(
            'Do you want Log-Out?',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: onTapYes,
                  child: const Text("Yes"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
