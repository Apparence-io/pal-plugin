import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class EditorFullscreenHelperWidget extends StatefulWidget {
  final FullscreenHelperViewModel fullscreenHelperViewModel;
  final Function(String) onTitleTextChanged;
  final Function(bool, Size, Offset) onTitleFocusChanged;

  EditorFullscreenHelperWidget({
    @required this.fullscreenHelperViewModel,
    this.onTitleFocusChanged,
    this.onTitleTextChanged,
    Key key,
  }) : super(key: key);

  @override
  _EditorFullscreenHelperWidgetState createState() =>
      _EditorFullscreenHelperWidgetState();
}

class _EditorFullscreenHelperWidgetState
    extends State<EditorFullscreenHelperWidget> {
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
    widget.fullscreenHelperViewModel.title?.value =
        _titleController?.value?.text;
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          opacity: helperOpacity,
          child: Container(
            color: widget.fullscreenHelperViewModel.backgroundColor?.value,
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
                          child: _buildTitle(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: InkWell(
                            key: ValueKey("positiveFeedback"),
                            child: Text(
                              "Ok, thanks !",
                              style: TextStyle(
                                color: widget
                                    .fullscreenHelperViewModel.fontColor?.value,
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
                                color: widget
                                    .fullscreenHelperViewModel.fontColor?.value,
                                fontSize: 10,
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
      ),
    );
  }

  Widget _buildTitle() {
    return TextField(
      key: ValueKey('palFullscreenHelperTitleField'),
      focusNode: _titleFocus,
      controller: _titleController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Edit me!',
        hintStyle: TextStyle(
          color:
              widget.fullscreenHelperViewModel.fontColor?.value?.withAlpha(80),
          decoration: TextDecoration.none,
          fontSize: widget.fullscreenHelperViewModel.fontSize?.value ??
              Theme.of(context).textTheme.headline2.fontSize,
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: widget.fullscreenHelperViewModel.fontColor?.value,
        decoration: TextDecoration.none,
        fontSize: widget.fullscreenHelperViewModel.fontSize?.value ??
            Theme.of(context).textTheme.headline2.fontSize,
      ),
    );
  }
}
