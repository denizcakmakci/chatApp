import 'package:flutter/material.dart';
import '../../core/constants/navigation/string_constants.dart';

import '../../core/init/extensions/context/theme_extension.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? image;
  final VoidCallback? onTap;
  const CustomListTile({
    Key? key,
    this.title,
    this.subTitle,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          splashColor: context.primaryColor, shadowColor: context.primaryColor),
      child: ListTile(
        title: Text(title ?? ''),
        subtitle: Text(
          subTitle ?? '',
          maxLines: 2,
          style: context.softText,
        ),
        onTap: onTap,
        leading: SizedBox(
          width: 60,
          height: 66,
          child: ClipOval(
              child: FadeInImage.assetNetwork(
            placeholder: 'assets/gifs/loading.gif',
            image: image ?? defaultUserPhoto,
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}
