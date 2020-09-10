import 'package:flutter/material.dart';

class ElementFinder {

  final BuildContext context;

  ElementFinder(this.context);

  Element _result;

  searchChildElement(String key)
  => context.visitChildElements((element) => _searchChildElement(element, key));

  Element get result => _result;

  Offset getResultPosition() {
    var parentObject = context.findRenderObject();
    var translation = _result.renderObject.getTransformTo(parentObject).getTranslation();
    return Offset(translation.x, translation.y);
  }

  Offset getResultCenter() {
    var parentObject = context.findRenderObject();
    var translation = _result.renderObject.getTransformTo(parentObject).getTranslation();
    var translationX = translation.x + (_result.size.width / 2);
    var translationY = translation.y + (_result.size.height / 2);
    return Offset(translationX, translationY);
  }

  _searchChildElement(Element element, String key, {int n = 0}) {
    if(element.widget.key != null) {
      if(element.widget.key.toString().contains(key)) {
        this._result = element;
        return;
      }
    }
    element.visitChildElements((visitor) => _searchChildElement(visitor, key, n: n + 1));
  }
}