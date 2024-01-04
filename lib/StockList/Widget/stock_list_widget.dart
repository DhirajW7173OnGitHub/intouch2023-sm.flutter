import 'package:flutter/material.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';

class StockListWidget extends StatelessWidget {
  const StockListWidget({
    super.key,
    this.onTap,
    this.createdAt,
    this.id,
    this.transType,
  });

  final Function()? onTap;
  final String? transType;
  final int? id;
  final String? createdAt;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
          child: Card(
            color: CommonColor.CARD_COLOR,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Request id : ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "$id",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Product Transaction-Type : ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "$transType",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        "Created Time : ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "$createdAt",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
