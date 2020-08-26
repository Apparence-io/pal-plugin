import 'package:flutter/material.dart';

class FullscreenHelperWidget extends StatefulWidget {

  final Color bgColor, textColor;

  final String helperText;

  final double textSize;

  FullscreenHelperWidget({
    @required this.bgColor,
    @required this.textColor,
    @required this.helperText,
    this.textSize,
    Key key
  }): assert(bgColor != null),
      assert(textColor != null),
      assert(helperText != null),
      super(key: key);

  @override
  _FullscreenHelperWidgetState createState() => _FullscreenHelperWidgetState();
}

class _FullscreenHelperWidgetState extends State<FullscreenHelperWidget> {

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
    var deviceSize = MediaQuery.of(context).size;
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
              Positioned(
                top: deviceSize.height / 2,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        widget.helperText,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: widget.textSize ?? Theme.of(context).textTheme.bodyText1.fontSize
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
                              color: widget.textColor,
                              fontSize: 10
                            ),
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
