import 'package:flutter/material.dart';

import '../../../../../theme.dart';

class CreateHelperButton extends StatefulWidget {
  final PalThemeData? palTheme;
  final Function? onTap;

  CreateHelperButton({this.palTheme, this.onTap, Key? key}) : super(key: key);

  @override
  _CreateHelperButtonState createState() => _CreateHelperButtonState();
}

class _CreateHelperButtonState extends State<CreateHelperButton> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2C77B6).withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ]),
      child: Material(
        color: PalTheme.of(context)!.colors.color4,
        child: InkWell(
          onTap: _onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() => Row(
        children: [
          Icon(Icons.add, size: 32),
          SizedBox(width: 8),
          RichText(
              text:
                  TextSpan(style: TextStyle(height: 1.5), children: <TextSpan>[
            TextSpan(text: "Create new helper", style: _textStyle1),
            TextSpan(text: "\non this page", style: _textStyle2),
          ])),
        ],
      );

  void _onTap() {
    if (widget.onTap != null) widget.onTap!();
  }

  TextStyle get _textStyle1 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: widget.palTheme!.colors.dark,
      );

  TextStyle get _textStyle2 => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: widget.palTheme!.colors.dark,
      );
}
