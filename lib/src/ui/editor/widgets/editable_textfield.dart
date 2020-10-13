import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';

enum ToolbarType { text, border }

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
  final Function(Key, String) onChanged;
  final TextInputType keyboardType;
  final TextStyle textStyle;
  final int maxLines;
  final int maximumCharacterLength;
  final int minimumCharacterLength;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final Stream<bool> outsideTapStream;
  final ToolbarType toolbarType;

  EditableTextField({
    Key key,
    this.textFormFieldKey,
    this.backgroundContainerKey,
    this.helperToolbarKey,
    this.outsideTapStream,
    this.maximumCharacterLength,
    this.minimumCharacterLength,
    this.onChanged,
    this.autovalidate = true,
    this.backgroundPadding,
    this.textFormFieldPadding,
    this.validator,
    this.backgroundBoxDecoration,
    this.maxLines = 1,
    this.inputFormatters,
    this.hintText = 'Edit me!',
    this.keyboardType,
    this.toolbarType = ToolbarType.text,
    @required this.textStyle,
  }) : super();

  factory EditableTextField.text({
    Key key,
    final Key textFormFieldKey,
    final Key backgroundContainerKey,
    final Key helperToolbarKey,
    final bool autovalidate = true,
    final BoxDecoration backgroundBoxDecoration,
    final EdgeInsetsGeometry backgroundPadding,
    final EdgeInsetsGeometry textFormFieldPadding,
    final String Function(String) validator,
    final Function(Key, String) onChanged,
    final TextInputType keyboardType,
    final TextStyle textStyle,
    final int maxLines = 1,
    final int maximumCharacterLength,
    final int minimumCharacterLength,
    final String hintText = 'Edit me!',
    final List<TextInputFormatter> inputFormatters,
    final Stream<bool> outsideTapStream,
  }) {
    return EditableTextField(
      key: key,
      textFormFieldKey: textFormFieldKey,
      backgroundContainerKey: backgroundContainerKey,
      helperToolbarKey: helperToolbarKey,
      outsideTapStream: outsideTapStream,
      maximumCharacterLength: maximumCharacterLength,
      minimumCharacterLength: minimumCharacterLength,
      onChanged: onChanged,
      autovalidate: autovalidate,
      backgroundPadding: backgroundPadding,
      textFormFieldPadding: textFormFieldPadding,
      validator: validator,
      backgroundBoxDecoration: backgroundBoxDecoration,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      hintText: hintText,
      keyboardType: keyboardType,
      textStyle: textStyle,
      toolbarType: ToolbarType.text,
    );
  }

  factory EditableTextField.border({
    Key key,
    final Key textFormFieldKey,
    final Key backgroundContainerKey,
    final Key helperToolbarKey,
    final bool autovalidate = true,
    final BoxDecoration backgroundBoxDecoration,
    final EdgeInsetsGeometry backgroundPadding,
    final EdgeInsetsGeometry textFormFieldPadding,
    final String Function(String) validator,
    final Function(Key, String) onChanged,
    final TextInputType keyboardType,
    final TextStyle textStyle,
    final int maxLines = 1,
    final int maximumCharacterLength,
    final int minimumCharacterLength,
    final String hintText = 'Edit me!',
    final List<TextInputFormatter> inputFormatters,
    final Stream<bool> outsideTapStream,
  }) {
    return EditableTextField(
      key: key,
      textFormFieldKey: textFormFieldKey,
      backgroundContainerKey: backgroundContainerKey,
      helperToolbarKey: helperToolbarKey,
      outsideTapStream: outsideTapStream,
      maximumCharacterLength: maximumCharacterLength,
      minimumCharacterLength: minimumCharacterLength,
      onChanged: onChanged,
      autovalidate: autovalidate,
      backgroundPadding: backgroundPadding,
      textFormFieldPadding: textFormFieldPadding,
      validator: validator,
      backgroundBoxDecoration: backgroundBoxDecoration,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      hintText: hintText,
      keyboardType: keyboardType,
      textStyle: textStyle,
      toolbarType: ToolbarType.border,
    );
  }

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isToolbarVisible = false;
  FocusNode _focusNode = FocusNode();
  StreamSubscription _outsideSub;
  TextStyle _textStyle;

  @override
  void initState() {
    super.initState();

    // Install listener when focus change
    _focusNode.addListener(_onFocusChange);

    // Listen on stream when outside tap is detected
    _outsideSub = widget.outsideTapStream?.listen((event) {
      if (event) {
        this._onClose();
      }
    });

    _textStyle = widget.textStyle;
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
          if (_isToolbarVisible) _buildToolbar(widget.toolbarType),
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
                    onTap: _onTextFieldTapped,
                    onChanged: (String newValue) {
                      if (widget.onChanged != null) {
                        widget.onChanged(widget.textFormFieldKey, newValue);
                      }
                    },
                    validator: (String value) {
                      String error;
                      if (widget.minimumCharacterLength != null) {
                        if (value.length < widget.minimumCharacterLength) {
                          error =
                              'Minimum ${widget.minimumCharacterLength} ${widget.minimumCharacterLength <= 1 ? 'character' : 'characters'} allowed';
                        }
                      }
                      if (widget.maximumCharacterLength != null) {
                        if (value.length >= widget.maximumCharacterLength) {
                          error =
                              'Maximum ${widget.maximumCharacterLength} ${widget.maximumCharacterLength <= 1 ? 'character' : 'characters'} allowed';
                        }
                      }
                      return error;
                    },
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    minLines: 1,
                    onFieldSubmitted: _onFieldSubmitted,
                    cursorColor: _textStyle?.color,
                    inputFormatters: widget.inputFormatters,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: _textStyle.merge(
                        TextStyle(
                          color: _textStyle?.color?.withAlpha(80),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: _textStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildToolbar(ToolbarType toolbarType) {
    Widget toolbar;
    switch (toolbarType) {
      case ToolbarType.text:
        toolbar = EditHelperToolbar.text(
          key: widget.helperToolbarKey,
          onChangeTextColor: _onChangeTextColor,
          onChangeTextFont: _onChangeTextFont,
          onClose: _onClose,
        );
        break;
      case ToolbarType.border:
        toolbar = EditHelperToolbar.border(
          key: widget.helperToolbarKey,
          onChangeTextColor: _onChangeTextColor,
          onChangeTextFont: _onChangeTextFont,
          onChangeBorder: _onChangeBorder,
          onClose: _onClose,
        );
        break;
      default:
    }

    return toolbar;
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
    this._onClose();
  }

  _onChangeTextFont() {
    showDialog(
      context: context,
      child: FontEditorDialogPage(
        actualTextStyle: _textStyle,
        onFontModified: (
          TextStyle newTextStyle,
          FontKeys fontKeys,
        ) {
          // TODO: Send fontkeys strings to Backend!
          setState(() {
            _textStyle = _textStyle.merge(
              newTextStyle,
            );
            _isToolbarVisible = true;
          });
        },
      ),
    );
  }

  _onChangeTextColor() {
    showDialog(
      context: context,
      child: ColorPickerDialog(
        placeholderColor: _textStyle?.color,
        onColorSelected: (Color newColor) {
          setState(() {
            _textStyle = _textStyle.merge(TextStyle(
              color: newColor,
            ));
            _isToolbarVisible = true;
          });
        },
      ),
    );
  }

  _onChangeBorder() {}
  _onClose() {
    _focusNode.unfocus();

    setState(() {
      _isToolbarVisible = false;
    });
  }
}
