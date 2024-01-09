import 'package:flutter/material.dart';
import 'package:stock_management/StockList/Model/stock_details_model.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';

class StockDetailsWidget extends StatelessWidget {
  const StockDetailsWidget({
    super.key,
    // this.id,
    // this.prodName,
    // this.qty,
    this.stockData,
  });

  final StockDatum? stockData;
  // final int? id;
  // final String? prodName;
  // final int? qty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Card(
            elevation: 8,
            color: CommonColor.CARD_COLOR,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TweenAnimationBuilder(
                duration: const Duration(seconds: 1),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, Widget? child) {
                  return Opacity(
                    opacity: value,
                    child: Padding(
                      padding: EdgeInsets.only(left: value * 5),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: Row(
                        children: [
                          Text(
                            "Request Id : ",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const Spacer(),
                          Text(
                            '${stockData!.reqid}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: Row(
                        children: [
                          Text(
                            "Product Name : ",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const Spacer(),
                          Text(
                            '${stockData!.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: Row(
                        children: [
                          Text(
                            "Product quntity : ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '${stockData!.qty}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({
    super.key,
    this.tCount,
    this.userId,
    this.userName,
  });

  final String? userName;
  final String? tCount;
  final int? userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: CommonColor.CONTAINER_COLOR,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 1),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, Widget? child) {
            return Opacity(
              opacity: value,
              child: Padding(
                padding: EdgeInsets.only(left: value * 5),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Total product Count : ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$tCount',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'User Id : ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$userId',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(
                    'User Name : ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$userName',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
