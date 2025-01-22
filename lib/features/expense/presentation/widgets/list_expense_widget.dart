import 'package:expense_tracker/core/extensions/number_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/shared_widget/card_container.dart';

class ListExpenseWidget extends StatelessWidget {
  const ListExpenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_circle_left_outlined,
              ),
              Text("Today"),
              Icon(
                Icons.arrow_circle_right_outlined,
              )
            ],
          ),
          const SizedBox(
            height: Dimens.medium,
          ),
          const Divider(),
          const SizedBox(
            height: Dimens.medium,
          ),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _ListItemExpenseWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItemExpenseWidget extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.xxLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            child: Icon(
              Icons.food_bank,
              size: 40,
            ),
          ),
          const SizedBox(
            width: Dimens.medium,
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Food",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Eat together with family"),
              ],
            ),
          ),
          Text(
            (200).toEuroFormat,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
