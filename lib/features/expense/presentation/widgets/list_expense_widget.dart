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
            height: 280,
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
    return const Padding(
      padding: EdgeInsets.only(bottom: Dimens.large),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.food_bank),
          SizedBox(
            width: Dimens.medium,
          ),
          Expanded(
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
            "200",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
