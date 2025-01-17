import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/shared_widget/card_container.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.large),
      isTopRounded: true,
      isBottomRounded: true,
      shadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1), // Shadow color
          spreadRadius: 2, // Spread radius
          blurRadius: 5, // Blur radius
          offset: const Offset(0, 4), // Shadow position (x, y)
        ),
      ],
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Spent this week",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "20.000,56",
            style: TextStyle(
              fontSize: 38,
            ),
          ),
        ],
      ),
    );
  }
}
