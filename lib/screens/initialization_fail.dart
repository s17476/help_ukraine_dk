import 'package:flutter/material.dart';

class InitializationFail extends StatelessWidget {
  const InitializationFail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Database initialization failed'),
      ),
    );
  }
}
