import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../core/init/extensions/string/locale_text_extensions.dart';

class LocaleText extends StatelessWidget {
  final String value;
  final TextStyle? style;
  final TextAlign? textAlign;

  const LocaleText({
    required this.value,
    this.style,
    this.textAlign,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      value.translate,
      textAlign: textAlign ?? TextAlign.right,
      style: style ?? const TextStyle(),
    );
  }
}
