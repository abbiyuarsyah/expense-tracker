import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'expense',
      locale: context.locale,
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}
