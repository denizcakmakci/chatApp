import 'package:flutter/material.dart';
import '../../../../core/init/extensions/extension_shelf.dart';

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: context.width * 6),
        child: Text(
          text.translate,
          style: context.headline1
              .copyWith(fontSize: (context.width + context.height) / .6),
        ),
      ),
    );
  }
}
