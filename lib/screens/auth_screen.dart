import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/helpers/responsive_size.dart';
import 'package:help_ukraine_dk/helpers/size_config.dart';
import 'package:help_ukraine_dk/widgets/auth_form_widget.dart';

class AuthScreen extends StatelessWidget with ResponsiveSize {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return const Scaffold(
      body: AuthFormWidget(),
    );
  }
}
