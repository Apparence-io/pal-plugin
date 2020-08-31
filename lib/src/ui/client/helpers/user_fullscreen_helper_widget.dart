import 'package:flutter/material.dart';

class UserFullscreenHelperWidget extends StatefulWidget {
  final Color bgColor, textColor;

  final String helperText;

  final double textSize;

  UserFullscreenHelperWidget(
      {this.bgColor, this.textColor, this.helperText, this.textSize, Key key})
      : assert(bgColor != null),
        assert(textColor != null),
        assert(helperText != null),
        super(key: key);

  @override
  _UserFullscreenHelperWidgetState createState() =>
      _UserFullscreenHelperWidgetState();
}

class _UserFullscreenHelperWidgetState
    extends State<UserFullscreenHelperWidget> {
  double helperOpacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() => helperOpacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        opacity: helperOpacity,
        child: Container(
          color: widget.bgColor,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.helperText,
                        key: ValueKey('palFullscreenHelperTitleText'),
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: widget.textSize ??
                              Theme.of(context).textTheme.bodyText1.fontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: InkWell(
                          key: ValueKey("positiveFeedback"),
                          child: Text(
                            "Ok, thanks !",
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: InkWell(
                          key: ValueKey("negativeFeedback"),
                          child: Text(
                            "This is not helping",
                            style: TextStyle(
                                color: widget.textColor, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
