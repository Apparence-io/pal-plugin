import 'package:flutter/material.dart';

class FullscreenHelperWidget extends StatefulWidget {
  final Color bgColor, textColor;

  final String helperText;

  final double textSize;

  final bool isEditMode;

  final Function(String) onTitleTextChanged;

  final Function(bool, Size, Offset) onTitleFocusChanged;

  FullscreenHelperWidget(
      {this.bgColor = Colors.blueAccent,
      this.textColor = Colors.white,
      this.helperText = 'Edit me!',
      this.textSize = 80.0,
      this.isEditMode = false,
      this.onTitleFocusChanged,
      this.onTitleTextChanged,
      Key key})
      : assert(bgColor != null),
        assert(textColor != null),
        assert(helperText != null),
        super(key: key);

  @override
  _FullscreenHelperWidgetState createState() => _FullscreenHelperWidgetState();
}

class _FullscreenHelperWidgetState extends State<FullscreenHelperWidget> {
  double helperOpacity = 0;
  GlobalKey _titleKey = new GlobalKey();
  FocusNode _titleFocus = new FocusNode();
  TextEditingController _titleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleFocus.addListener(_onTitleFocusChanged);
    _titleController.addListener(_onTitleTextChanged);
    Future.delayed(Duration(seconds: 1), () {
      setState(() => helperOpacity = 1);
    });
  }

  _onTitleTextChanged() {
    print('TEST');
    print(_titleController.value);
  }

  _onTitleFocusChanged() {
    if (widget.onTitleFocusChanged != null) {
      final RenderBox titleRenderBox =
          _titleKey.currentContext.findRenderObject();
      final titleWidgetSize = titleRenderBox.size;
      final titleWidgetOffset = titleRenderBox.localToGlobal(Offset.zero);

      widget.onTitleFocusChanged(
          _titleFocus.hasFocus, titleWidgetSize, titleWidgetOffset);
    }
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus all textfield when tapping outside
        if (widget.isEditMode) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Material(
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
                        Container(
                          color: Colors.white12,
                          key: ValueKey('palFullScreenHelperTitle'),
                          child: (widget.isEditMode)
                              ? _buildEditMode()
                              : _buildUserMode(),
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
      ),
    );
  }

  Widget _buildEditMode() {
    return TextField(
      key: _titleKey,
      focusNode: _titleFocus,
      controller: _titleController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Edit me!',
        hintStyle: TextStyle(
          color: widget.textColor.withAlpha(80),
          decoration: TextDecoration.none,
          fontSize:
              widget.textSize ?? Theme.of(context).textTheme.headline2.fontSize,
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: widget.textColor,
        decoration: TextDecoration.none,
        fontSize:
            widget.textSize ?? Theme.of(context).textTheme.headline2.fontSize,
      ),
    );
  }

  Widget _buildUserMode() {
    return Text(
      widget.helperText,
      style: TextStyle(
        color: widget.textColor,
        fontSize:
            widget.textSize ?? Theme.of(context).textTheme.bodyText1.fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}
