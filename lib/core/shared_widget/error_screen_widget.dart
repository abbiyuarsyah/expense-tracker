import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class ErrorScreenWidget extends StatelessWidget {
  const ErrorScreenWidget({
    super.key,
    required this.message,
    this.onPressed,
  });

  final String message;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.large),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: Dimens.medium),
            if (onPressed != null)
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.extraLarge),
                  ),
                ),
                child: Text(
                  tr('retry'),
                  style: const TextStyle(fontSize: 16.0),
                ),
              )
          ],
        ),
      ),
    );
  }
}
