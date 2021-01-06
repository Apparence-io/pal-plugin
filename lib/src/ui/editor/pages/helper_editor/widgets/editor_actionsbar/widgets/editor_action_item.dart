import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditorActionItem extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onTap;

  EditorActionItem({
    Key key,
    @required this.icon,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  Widget build(BuildContext contexte) {
    return IgnorePointer(
      ignoring: this.onTap == null,
      child: Opacity(
        opacity: this.onTap != null ? 1 : 0.3,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            this.onTap?.call();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              this.icon,
              Divider(height: 8),
              Text(
                this.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
