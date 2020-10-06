import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

class FontListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onTap;

  const FontListTile({
    Key key,
    @required this.title,
    @required this.subTitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subTitle,
        style: TextStyle(
          color: PalTheme.of(context).colors.dark.withAlpha(140),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: PalTheme.of(context).colors.dark,
      ),
      onTap: onTap,
    );
  }
}
