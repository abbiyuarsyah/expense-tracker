import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.child,
    this.isTopRounded = false,
    this.isBottomRounded = false,
    this.margin,
    this.color = Colors.white,
    this.shadow,
  });

  final Widget child;
  final bool isTopRounded;
  final bool isBottomRounded;
  final EdgeInsets? margin;
  final Color color;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: margin,
      padding: const EdgeInsets.all(Dimens.large),
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: isTopRounded
              ? const Radius.circular(Dimens.large)
              : const Radius.circular(0),
          topRight: isTopRounded
              ? const Radius.circular(Dimens.large)
              : const Radius.circular(0),
          bottomLeft: isBottomRounded
              ? const Radius.circular(Dimens.large)
              : const Radius.circular(0),
          bottomRight: isBottomRounded
              ? const Radius.circular(Dimens.large)
              : const Radius.circular(0),
        ),
      ),
      child: child,
    );
  }
}
