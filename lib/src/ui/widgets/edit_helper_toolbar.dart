import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

class EditHelperToolbar extends StatelessWidget {

  const EditHelperToolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      color: PalTheme.of(context).toolbarBackgroundColor,
    );
  }
}
