import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';

class PageGroupsListItem extends StatelessWidget {

  final String? title, subtitle, version;
  final PalThemeData? palTheme;

  PageGroupsListItem({
    required this.title, 
    required this.subtitle, 
    required this.version,  
    required this.palTheme,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
              color: Color(0xFF2C77B6).withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(text: TextSpan(
            style: TextStyle(height: 1.5),
            children: <TextSpan>[
              TextSpan(text: "$title", style: _textStyle1),
              TextSpan(text: "\n$subtitle", style: _textStyle2),
            ]
          )),
          RichText(text: TextSpan(
            style: TextStyle(height: 1.4),
            children: <TextSpan>[
              TextSpan(text: "Versions", style: _textStyle3),
              TextSpan(text: "\n$version", style: _textStyle2),
            ]
          ))
        ],
      ),
    );
  }

  TextStyle get _textStyle1 => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: palTheme!.colors.dark,
  );

  TextStyle get _textStyle2 => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: palTheme!.colors.dark,
  );

  TextStyle get _textStyle3 => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: palTheme!.colors.dark,
  );

  

}