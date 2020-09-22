import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';

class EditableTextField extends StatefulWidget {
  // Keys
  // static final GlobalKey<_EditableTextFieldState> globalKey = GlobalKey();
  final Key textFormFieldKey;
  final Key backgroundContainerKey;
  final Key helperToolbarKey;

  // Textfield stuff
  final bool autovalidate;
  final BoxDecoration backgroundBoxDecoration;
  final EdgeInsetsGeometry backgroundPadding;
  final EdgeInsetsGeometry textFormFieldPadding;
  final String Function(String) validator;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final TextStyle textStyle;
  final int maxLines;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final Stream<bool> outsideTapStream;

  EditableTextField({
    Key key,
    this.textFormFieldKey,
    this.backgroundContainerKey,
    this.helperToolbarKey,
    this.outsideTapStream,
    this.autovalidate = true,
    this.backgroundPadding,
    this.textFormFieldPadding,
    this.validator,
    this.backgroundBoxDecoration,
    this.maxLines = 1,
    this.inputFormatters,
    this.hintText = 'Edit me!',
    @required this.textEditingController,
    this.keyboardType,
    @required this.textStyle,
  }) : super();

  factory EditableTextField.fixed({
    Key key,
    final Key textFormFieldKey,
    final Key backgroundContainerKey,
    final Key helperToolbarKey,
    final Stream outsideTapStream,
    final bool autovalidate = true,
    final BoxDecoration backgroundBoxDecoration,
    final EdgeInsetsGeometry backgroundPadding,
    final EdgeInsetsGeometry textFormFieldPadding,
    final String Function(String) validator,
    @required final TextEditingController textEditingController,
    final TextInputType keyboardType,
    final String hintText = 'Edit me!',
    @required final TextStyle textStyle,
    final int maxLines = 1,
    final List<TextInputFormatter> inputFormatters,
  }) =>
      EditableTextField(
        key: key,
        outsideTapStream: outsideTapStream,
        textFormFieldKey: textFormFieldKey,
        backgroundContainerKey: backgroundContainerKey,
        helperToolbarKey: helperToolbarKey,
        autovalidate: autovalidate,
        backgroundPadding: backgroundPadding,
        textFormFieldPadding: textFormFieldPadding,
        validator: validator,
        hintText: hintText,
        backgroundBoxDecoration: backgroundBoxDecoration,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        textEditingController: textEditingController,
        keyboardType: keyboardType,
        textStyle: textStyle,
      );

  /// used to show textfield even if a keyboard is shown
  factory EditableTextField.floating({
    Key key,
    final Key textFormFieldKey,
    final Key backgroundContainerKey,
    final Key helperToolbarKey,
    final bool autovalidate = true,
    final Stream outsideTapStream,
    final BoxDecoration backgroundBoxDecoration,
    final EdgeInsetsGeometry backgroundPadding,
    final EdgeInsetsGeometry textFormFieldPadding,
    final String Function(String) validator,
    @required final TextEditingController textEditingController,
    final TextInputType keyboardType,
    @required final TextStyle textStyle,
    final String hintText = 'Edit me!',
    final int maxLines = 1,
    final List<TextInputFormatter> inputFormatters,
  }) =>
      EditableTextField(
        key: key,
        textFormFieldKey: textFormFieldKey,
        backgroundContainerKey: backgroundContainerKey,
        helperToolbarKey: helperToolbarKey,
        outsideTapStream: outsideTapStream,
        autovalidate: autovalidate,
        backgroundPadding: backgroundPadding,
        textFormFieldPadding: textFormFieldPadding,
        validator: validator,
        backgroundBoxDecoration: backgroundBoxDecoration,
        maxLines: maxLines,
        hintText: hintText,
        inputFormatters: inputFormatters,
        textEditingController: textEditingController,
        keyboardType: keyboardType,
        textStyle: textStyle,
      );

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isToolbarVisible = false;
  FocusNode _focusNode = FocusNode();
  StreamSubscription _outsideSub;

  @override
  void initState() {
    super.initState();

    // Install listener when focus change
    _focusNode.addListener(_onFocusChange);

    // Listen on stream when outside tap is detected
    _outsideSub = widget.outsideTapStream?.listen((event) {
      if (event) {
        this._onCloseTap();
      }
    });
  }

  @override
  void dispose() {
    _outsideSub?.cancel();
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          if (_isToolbarVisible)
            EditHelperToolbar(
              key: widget.helperToolbarKey,
              onChangeBorderTap: _onChangeBorderTap,
              onCloseTap: _onCloseTap,
              onChangeFontTap: _onChangeFontTap,
              onEditTextTap: _onTextFieldTapped,
            ),
          Padding(
            // FIXME: This is used to show element even if keyboard is shown
            // should be better to find a way to not use it :/
            padding: widget.backgroundPadding ?? EdgeInsets.zero,
            child: DottedBorder(
              dashPattern: [6, 3],
              color: Colors.black45,
              child: Container(
                decoration: widget.backgroundBoxDecoration,
                key: widget.backgroundContainerKey,
                child: Padding(
                  padding: widget.textFormFieldPadding ?? EdgeInsets.zero,
                  child: TextFormField(
                    key: widget.textFormFieldKey,
                    autovalidate: widget.autovalidate,
                    focusNode: _focusNode,
                    controller: widget.textEditingController,
                    onTap: _onTextFieldTapped,
                    validator: widget.validator,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    onFieldSubmitted: _onFieldSubmitted,
                    cursorColor: widget.textStyle.color,
                    inputFormatters: widget.inputFormatters,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: widget.textStyle.color.withAlpha(80),
                        decoration: TextDecoration.none,
                        fontSize: widget.textStyle.fontSize,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: widget.textStyle ??
                        TextStyle(
                          color: PalTheme.of(context).simpleHelperFontColor,
                          fontSize: 14.0,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Textfield stuff
  _onTextFieldTapped() {
    _focusNode.requestFocus();
    setState(() {
      _isToolbarVisible = true;
    });
  }

  _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isToolbarVisible = false;
      });
    }
  }

  _onFieldSubmitted(String newValue) {
    this._onCloseTap();
  }

  // Toolbar stuff
  _onChangeBorderTap() {}
  _onCloseTap() {
    _focusNode.unfocus();

    setState(() {
      _isToolbarVisible = false;
    });
  }

  _onChangeFontTap() {}
}
