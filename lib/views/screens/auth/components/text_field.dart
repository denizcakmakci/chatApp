import 'package:flutter/material.dart';
import '../../../../core/init/extensions/extension_shelf.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final bool isPrefix;
  final TextEditingController controller;
  const CustomTextField(
      {Key? key, this.hintText, this.isPrefix = true, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: context.primaryLightColor.withOpacity(.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: textFormField(context),
    );
  }

  TextFormField textFormField(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: context.headline3
          .copyWith(fontSize: (context.width + context.height) / .9),
      controller: controller,
      cursorHeight: (context.width + context.height / .9),
      cursorColor: context.primaryLightColor,
      keyboardType: TextInputType.phone,
      decoration: inputDecoration(context),
    );
  }

  InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
        prefixIcon: prefix(context),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 25,
        ),
        hintText: hintText,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(
            context.height * 2, context.height, 0, context.height),
        hintStyle: context.headline3.copyWith(
            fontSize: (context.width + context.height / .7),
            color: context.primaryLightColor.withOpacity(.5)),
        fillColor: Colors.white,
        filled: true,
        border: border());
  }

  Icon? prefix(BuildContext context) {
    return isPrefix
        ? Icon(
            Icons.phone,
            color: context.primaryLightColor,
          )
        : null;
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none);
  }
}
