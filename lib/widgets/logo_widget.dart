import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/helpers/size_config.dart';

class Logo extends StatelessWidget {
  const Logo(
      {Key? key,
      required this.greenLettersSize,
      required this.whitheLettersSize})
      : super(key: key);

  final double greenLettersSize;
  final double whitheLettersSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'H',
              style: TextStyle(
                // color: Colors.black,
                fontSize: SizeConfig.blockSizeHorizontal * greenLettersSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'elp ',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * whitheLettersSize,
                fontWeight: FontWeight.w500,
                // color: Colors.black,
              ),
            ),
            Text(
              'U',
              style: TextStyle(
                // color: Colors.blue,
                fontSize: SizeConfig.blockSizeHorizontal * greenLettersSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'kraine ',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * whitheLettersSize,
                fontWeight: FontWeight.w500,
                // color: Colors.black,
              ),
            ),
            Text(
              'DK',
              style: TextStyle(
                color: Colors.blue,
                fontSize: SizeConfig.blockSizeHorizontal * greenLettersSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
