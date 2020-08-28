import 'package:flutter/material.dart';

class FullscreenHelperNotifier {
  ValueNotifier<String> titleNotifier = ValueNotifier(null);
  ValueNotifier<String> fontColorNotifier = ValueNotifier(null);
  ValueNotifier<String> backgroundColorNotifier = ValueNotifier(null);
  ValueNotifier<String> borderColorNotifier = ValueNotifier(null);
  ValueNotifier<int> languageIdNotifier = ValueNotifier(null);

  FullscreenHelperNotifier({
    String title,
    String fontColor,
    String backgroundColor,
    String borderColor,
    int languageId,
  }) {
    this.titleNotifier = ValueNotifier(title);
    this.fontColorNotifier = ValueNotifier(fontColor);
    this.backgroundColorNotifier = ValueNotifier(backgroundColor);
    this.borderColorNotifier = ValueNotifier(borderColor);
    this.languageIdNotifier = ValueNotifier(languageId);
  }
}

class FullscreenHelperWidget extends StatefulWidget {
  final Color bgColor, textColor;

  final String helperText;

  final double textSize;

  final bool isEditMode;

  final FullscreenHelperNotifier fullscreenHelperNotifier;

  final Function(String) onTitleTextChanged;

  final Function(bool, Size, Offset) onTitleFocusChanged;

  // TODO: Need to merge all params with ValueNotifiers
  FullscreenHelperWidget(
      {this.bgColor,
      this.textColor,
      this.helperText,
      this.textSize,
      this.isEditMode = false,
      this.onTitleFocusChanged,
      this.onTitleTextChanged,
      this.fullscreenHelperNotifier,
      Key key})
      : assert(bgColor != null),
        assert(textColor != null),
        assert(helperText != null),
        super(key: key);

  factory FullscreenHelperWidget.user({
    Key key,
    @required Color bgColor,
    @required Color textColor,
    @required String helperText,
    @required double textSize,
  }) {
    return FullscreenHelperWidget(
      bgColor: bgColor,
      textColor: textColor,
      helperText: helperText,
      textSize: textSize,
    );
  }

  factory FullscreenHelperWidget.editor({
    Key key,
    Function(String) onTitleTextChanged,
    Function(bool, Size, Offset) onTitleFocusChanged,
    FullscreenHelperNotifier fullscreenHelperNotifier,
  }) {
    return FullscreenHelperWidget(
      bgColor: Colors.blueAccent,
      textColor: Colors.white,
      helperText: 'Edit me!',
      textSize: 80.0,
      onTitleFocusChanged: onTitleFocusChanged,
      onTitleTextChanged: onTitleTextChanged,
      isEditMode: true,
      fullscreenHelperNotifier: fullscreenHelperNotifier,
    );
  }

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

    // TODO: Refactor this init because this is so ugly :/
    // TODO: Create util file to handle color conversion
    // FIXME: Use FullscreenHelperWidget params or only notifier ??
    if (widget.fullscreenHelperNotifier != null) {
      widget.fullscreenHelperNotifier.backgroundColorNotifier.value =
          '${widget.bgColor.value.toRadixString(16)}';
      widget.fullscreenHelperNotifier.borderColorNotifier.value =
          '${widget.bgColor.value.toRadixString(16)}';
      widget.fullscreenHelperNotifier.fontColorNotifier.value =
          '${widget.textColor.value.toRadixString(16)}';
      widget.fullscreenHelperNotifier.languageIdNotifier.value = 1;
      widget.fullscreenHelperNotifier.titleNotifier.value = widget.helperText;
    }
  }

  _onTitleTextChanged() {
    widget.fullscreenHelperNotifier.titleNotifier.value = _titleController?.value?.text;
  }

  _onTitleFocusChanged() {
    if (widget.onTitleFocusChanged != null) {
      final RenderBox titleRenderBox =
          _titleKey.currentContext.findRenderObject();
      final titleWidgetSize = titleRenderBox.size;
      final titleWidgetOffset = titleRenderBox.localToGlobal(Offset.zero);

      widget.onTitleFocusChanged(
        _titleFocus.hasFocus,
        titleWidgetSize,
        titleWidgetOffset,
      );
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
                          key: _titleKey,
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
      key: ValueKey('palFullscreenHelperTitleField'),
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
      key: ValueKey('palFullscreenHelperTitleText'),
      style: TextStyle(
        color: widget.textColor,
        fontSize:
            widget.textSize ?? Theme.of(context).textTheme.bodyText1.fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}
