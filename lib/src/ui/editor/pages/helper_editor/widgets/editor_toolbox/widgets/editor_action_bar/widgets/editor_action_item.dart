import 'package:flutter/material.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: this.onTap,
      child: Container(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 65),
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
