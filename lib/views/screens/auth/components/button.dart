import 'package:flutter/material.dart';
import '../../../../core/init/extensions/extension_shelf.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onpressed;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 4,
      width: context.width * 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.primaryColor,
            context.lightPink,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onpressed,
        child: Text(
          buttonText,
          style: context.headline1
              .copyWith(fontSize: (context.width + context.height) / .85),
        ),
      ),
    );
  }
}
