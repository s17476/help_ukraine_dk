import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  static const route = '/schedule';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('SCHEDULE'),
      ),
    );
  }
}
