import 'package:flutter/material.dart';

extension ImagePathExtension on String {
  String get toSVG => 'assets/svg/$this.svg';
  String get toBgSVG => 'assets/svg/background/$this.svg';

  Image get pngImageAsset => Image.asset('assets/images/$this.png');
  Image get pngLogoAsset => Image.asset('assets/logo/$this.png');
  Image get pngIconAsset => Image.asset('assets/icons/$this.png');
}
