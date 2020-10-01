import 'package:flutter/widgets.dart';

class LabeledForm extends StatelessWidget {
  final String label;
  final Widget widget;

  const LabeledForm({
    Key key,
    @required this.label,
    @required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        this.widget,
      ],
    );
  }
}
