import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

enum ToolbarType { text, border }

typedef OnFieldChanged(String id, String value);

typedef OnFocusChange = void Function(bool hasFocus);

typedef OnTextStyleChanged(String id, TextStyle style, FontKeys fontkeys);

// TODO move to TextStyle extension
TextStyle _googleCustomFont(String fontFamily) {
  return (fontFamily != null && fontFamily.length > 0)
    ? GoogleFonts.getFont(fontFamily)
    : null;
}

class EditableTextField extends StatefulWidget {
  // Keys
  // static final GlobalKey<_EditableTextFieldState> globalKey = GlobalKey();
  final String id;
  final Key textFormFieldKey;
  final Key backgroundContainerKey;
  final Key helperToolbarKey;

  // Textfield stuff
  final AutovalidateMode autovalidate;
  final BoxDecoration backgroundBoxDecoration;
  final EdgeInsetsGeometry backgroundPadding;
  final EdgeInsetsGeometry textFormFieldPadding;
  final OnFieldChanged onChanged;
  final OnTextStyleChanged onTextStyleChanged;
  final TextInputType keyboardType;
  final TextStyle textStyle;
  final int maxLines;
  final int maximumCharacterLength;
  final int minimumCharacterLength;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final Stream<bool> outsideTapStream;
  final ToolbarType toolbarType;
  final String initialValue;
  final String fontFamilyKey;
  final FocusNode focusNode;
  final OnFocusChange onFocusChange;

  EditableTextField({
    Key key,
    this.id,
    this.textFormFieldKey,
    this.backgroundContainerKey,
    this.helperToolbarKey,
    this.outsideTapStream,
    this.maximumCharacterLength,
    this.minimumCharacterLength,
    this.onChanged,
    this.onTextStyleChanged,
    this.autovalidate = AutovalidateMode.onUserInteraction,
    this.backgroundPadding,
    this.textFormFieldPadding,
    this.backgroundBoxDecoration,
    this.maxLines = 1,
    this.fontFamilyKey,
    this.inputFormatters,
    this.hintText = 'Edit me!',
    this.keyboardType,
    this.initialValue,
    this.focusNode,
    this.onFocusChange,
    this.toolbarType = ToolbarType.text,
    @required this.textStyle,
  }) : super();

  factory EditableTextField.text({
    Key key,
    final String id,
    final Key textFormFieldKey,
    final Key backgroundContainerKey,
    final Key helperToolbarKey,
    final AutovalidateMode autovalidate = AutovalidateMode.onUserInteraction,
    final BoxDecoration backgroundBoxDecoration,
    final EdgeInsetsGeometry backgroundPadding,
    final EdgeInsetsGeometry textFormFieldPadding,
    final String Function(String) validator,
    final OnFieldChanged onChanged,
    final OnTextStyleChanged onTextStyleChanged,
    final TextInputType keyboardType,
    final TextStyle textStyle,
    final int maxLines = 1,
    final int maximumCharacterLength,
    final int minimumCharacterLength,
    final String hintText = 'Edit me!',
    final List<TextInputFormatter> inputFormatters,
    final Stream<bool> outsideTapStream,
    final String initialValue,
    final String fontFamilyKey,
    final FocusNode focusNode,
    final OnFocusChange onFocusChange
  }) {
    return EditableTextField(
      key: key,
      id: id,
      textFormFieldKey: textFormFieldKey,
      backgroundContainerKey: backgroundContainerKey,
      helperToolbarKey: helperToolbarKey,
      outsideTapStream: outsideTapStream,
      maximumCharacterLength: maximumCharacterLength,
      minimumCharacterLength: minimumCharacterLength,
      onTextStyleChanged: onTextStyleChanged,
      onChanged: onChanged,
      fontFamilyKey: fontFamilyKey,
      autovalidate: autovalidate,
      backgroundPadding: backgroundPadding,
      textFormFieldPadding: textFormFieldPadding,
      backgroundBoxDecoration: backgroundBoxDecoration,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      hintText: hintText,
      keyboardType: keyboardType,
      textStyle: textStyle,
      toolbarType: ToolbarType.text,
      focusNode: focusNode,
      initialValue: initialValue,
      onFocusChange: onFocusChange,
    );
  }

  factory EditableTextField.fromNotifier(
    Stream<bool> outsideTapStream,
    TextFormFieldNotifier textNotifier,
    OnFieldChanged onFieldValueChange,
    OnTextStyleChanged onTextStyleChanged,
    { Key helperToolbarKey,
      Key textFormFieldKey,
      TextStyle baseStyle,
      int minimumCharacterLength = 1,
      int maximumCharacterLength = 255,
      int maxLines = 5,
      OnFocusChange onFocusChange,
      BoxDecoration backgroundDecoration})
  => EditableTextField.text(
    backgroundBoxDecoration: backgroundDecoration,
    outsideTapStream: outsideTapStream,
    helperToolbarKey: helperToolbarKey,
    textFormFieldKey: textFormFieldKey,
    onChanged: onFieldValueChange,
    onTextStyleChanged: onTextStyleChanged,
    maximumCharacterLength: maximumCharacterLength,
    minimumCharacterLength: minimumCharacterLength,
    maxLines: maxLines,
    fontFamilyKey: textNotifier?.fontFamily?.value,
    initialValue: textNotifier?.text?.value,
    focusNode: textNotifier.focusNode,
    onFocusChange: onFocusChange,
    textStyle: TextStyle(
      color: textNotifier?.fontColor?.value,
      decoration: TextDecoration.none,
      fontSize: textNotifier?.fontSize?.value?.toDouble(),
      fontWeight: FontWeightMapper.toFontWeight(textNotifier?.fontWeight?.value),
    ).merge(baseStyle ?? _googleCustomFont(textNotifier?.fontFamily?.value)),
  );

  factory  EditableTextField.editableButton(
    Stream<bool> outsideTapStream,
    TextFormFieldNotifier textNotifier,
    OnFieldChanged onFieldValueChange,
    OnTextStyleChanged onTextStyleChanged,
    { int minimumCharacterLength = 1,
      int maximumCharacterLength = 255,
      FocusNode focusNode,
      OnFocusChange onFocusChange,
      int maxLines = 1})
  =>  EditableTextField.fromNotifier(
    outsideTapStream,
    textNotifier,
    onFieldValueChange,
    onTextStyleChanged,
    minimumCharacterLength: minimumCharacterLength,
    maximumCharacterLength: maximumCharacterLength,
    maxLines: maxLines,
    backgroundDecoration: BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 2
      ),
      // color: Colors.redAccent.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10.0),
    )
  );

  factory EditableTextField.border({
    Key key,
    final String id,
    final Key textFormFieldKey,
    final Key backgroundContainerKey,
    final Key helperToolbarKey,
    final AutovalidateMode autovalidate = AutovalidateMode.onUserInteraction,
    final BoxDecoration backgroundBoxDecoration,
    final EdgeInsetsGeometry backgroundPadding,
    final EdgeInsetsGeometry textFormFieldPadding,
    final String Function(String) validator,
    final Function(String, String) onChanged,
    final Function(String, TextStyle, FontKeys) onTextStyleChanged,
    final TextInputType keyboardType,
    final TextStyle textStyle,
    final int maxLines = 1,
    final int maximumCharacterLength,
    final int minimumCharacterLength,
    final String hintText = 'Edit me!',
    final List<TextInputFormatter> inputFormatters,
    final Stream<bool> outsideTapStream,
    final String initialValue,
    final String fontFamilyKey,
  }) {
    return EditableTextField(
      key: key,
      id: id,
      textFormFieldKey: textFormFieldKey,
      backgroundContainerKey: backgroundContainerKey,
      helperToolbarKey: helperToolbarKey,
      outsideTapStream: outsideTapStream,
      maximumCharacterLength: maximumCharacterLength,
      minimumCharacterLength: minimumCharacterLength,
      onChanged: onChanged,
      onTextStyleChanged: onTextStyleChanged,
      autovalidate: autovalidate,
      backgroundPadding: backgroundPadding,
      textFormFieldPadding: textFormFieldPadding,
      backgroundBoxDecoration: backgroundBoxDecoration,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      hintText: hintText,
      keyboardType: keyboardType,
      textStyle: textStyle,
      toolbarType: ToolbarType.border,
      initialValue: initialValue,
      fontFamilyKey: fontFamilyKey,
    );
  }

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isToolbarVisible = false;
  FocusNode _focusNode;
  StreamSubscription _outsideSub;
  TextStyle _textStyle;
  String _fontFamilyKey;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    // Install listener when focus change
    _focusNode.addListener(_onFocusChange);
    _fontFamilyKey = widget.fontFamilyKey ?? 'Montserrat';
    // Listen on stream when outside tap is detected
    _outsideSub = widget.outsideTapStream?.listen((event) {
      if (event) {
        _onClose();
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
              color: Colors.white.withAlpha(80),
              child: Container(
                decoration: widget.backgroundBoxDecoration,
                key: widget.backgroundContainerKey,
                child: Padding(
                  padding: widget.textFormFieldPadding ?? EdgeInsets.zero,
                  child: TextFormField(
                    key: widget.textFormFieldKey,
                    autovalidateMode: widget.autovalidate,
                    focusNode: _focusNode,
                    onTap: _onTextFieldTapped,
                    onChanged: (String newValue) {
                      if (widget.onChanged != null) {
                        widget.onChanged(
                            widget.id ?? widget.textFormFieldKey.toString(),
                            newValue);
                      }
                    },
                    validator: (String value) {
                      String error;
                      if (widget.minimumCharacterLength != null) {
                        if (value != null &&
                            value.length < widget.minimumCharacterLength) {
                          error =
                              'Minimum ${widget.minimumCharacterLength} ${widget.minimumCharacterLength <= 1 ? 'character' : 'characters'} allowed';
                        }
                      }
                      if (widget.maximumCharacterLength != null) {
                        if (value != null &&
                            value.length >= widget.maximumCharacterLength) {
                          error =
                              'Maximum ${widget.maximumCharacterLength} ${widget.maximumCharacterLength <= 1 ? 'character' : 'characters'} allowed';
                        }
                      }
                      return error;
                    },
                    initialValue: widget.initialValue,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines ?? 1,
                    minLines: 1,
                    onFieldSubmitted: _onFieldSubmitted,
                    cursorColor: _textStyle?.color,
                    inputFormatters: widget.inputFormatters,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: _textStyle?.merge(
                        TextStyle(
                          color: _textStyle?.color?.withAlpha(80),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => _focusNode.unfocus(),
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
    if(widget.onFocusChange != null) {
      widget.onFocusChange(_focusNode.hasFocus);
    }
    if (!_focusNode.hasFocus) {
      setState(() {
        _isToolbarVisible = false;
      });
    }
  }

  _onFieldSubmitted(String newValue) => _onClose();

  _onChangeTextFont() {
    var widgetBuilder = (context) => FontEditorDialogPage(
      onCancelPicker: () => Navigator.of(context).pop(),
      onValidatePicker: () => Navigator.of(context).pop(),
      actualTextStyle: _textStyle,
      fontFamilyKey: _fontFamilyKey,
      onFontModified: (TextStyle newTextStyle, FontKeys fontKeys) {
        setState(() {
          _textStyle = _textStyle.merge(
            newTextStyle,
          );
          _isToolbarVisible = true;
        });

        if (fontKeys?.fontFamilyNameKey != null &&
          fontKeys.fontFamilyNameKey.length > 0) {
          _fontFamilyKey = fontKeys.fontFamilyNameKey;
        }
        if (widget.onTextStyleChanged != null) {
          widget.onTextStyleChanged(
            widget.id ?? widget.textFormFieldKey.toString(),
            _textStyle,
            fontKeys,
          );
        }
      },
    );
    showDialog(context: context, builder: widgetBuilder);
  }

  _onChangeTextColor() {
    var widgetBuilder = (context) => ColorPickerDialog(
      placeholderColor: _textStyle?.color,
      onCancel: () => Navigator.of(context).pop(),
      onColorSelected: (Color newColor) {
        setState(() {
          _textStyle = _textStyle.merge(TextStyle(
            color: newColor,
          ));
          _isToolbarVisible = true;
        });
        if (widget.onTextStyleChanged != null) {
          widget.onTextStyleChanged(
            widget.id ?? widget.textFormFieldKey.toString(),
            _textStyle,
            null,
          );
        }
        Navigator.of(context).pop();
      },
    );
    showDialog(context: context, builder: widgetBuilder);
  }

  _onChangeBorder() {}

  _onClose() {
    _focusNode.unfocus();
    setState(() {
      _isToolbarVisible = false;
    });
  }
}
