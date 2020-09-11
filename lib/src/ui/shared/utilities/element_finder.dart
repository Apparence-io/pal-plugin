import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

/// This class helps you find element within your app
/// use [searchChildElement] with a String containing key value
/// result is available in [result] and returns an [Element]
class ElementFinder {

  final BuildContext context;

  ElementFinder(this.context);

  Element _result;

  // this method scan all child recursively to get all widget bounds we could select for an helper
  Map<String, ElementModel> scan() {
    Map<String, ElementModel> results = Map<String, ElementModel>();
    context.visitChildElements((element) => _scanChildElement(context.findRenderObject(), element, results));
    return results;
  }

  // this method scan all child recursively to find a widget having a key == searchedKey
  searchChildElement(String key) => context.visitChildElements((element) => _searchChildElement(element, key));

  Element get result => _result;

  Rect get resultRect => _result.findRenderObject().paintBounds;

  // returns the Offset as the top left of our widget
  Offset getResultPosition() {
    var parentObject = context.findRenderObject();
    var translation = _result.renderObject.getTransformTo(parentObject).getTranslation();
    return Offset(translation.x, translation.y);
  }

  // returns the Offset as the center of our result
  Offset getResultCenter() {
    var parentObject = context.findRenderObject();
    var translation = _result.renderObject.getTransformTo(parentObject).getTranslation();
    var translationX = translation.x + (_result.size.width / 2);
    var translationY = translation.y + (_result.size.height / 2);
    return Offset(translationX, translationY);
  }

  /// This functions search for the maximum rect available space
  /// We use it for example to find the most available space to write a text in our anchored helper
  Rect getLargestAvailableSpace() {
    var parentObject = context.findRenderObject();
    var translation = _result.renderObject.getTransformTo(parentObject).getTranslation();
    var objectX = translation.x;
    var objectEndX = objectX + _result.size.width;
    var objectY = translation.y;
    var objectEndY = objectY + _result.size.height;
    var layerRect = parentObject.paintBounds;

    Rect availableHSpace;
    Rect availableWSpace;
    if(objectY > layerRect.height - objectEndY) {
      availableHSpace = Rect.fromLTWH(0, 0, layerRect.width, objectY);
    } else {
      availableHSpace = Rect.fromLTWH(0, objectEndY, layerRect.width, layerRect.height - objectEndY);
    }
    if(objectX > layerRect.width - objectEndX) {
      availableWSpace = Rect.fromLTWH(0, 0, objectX, layerRect.height);
    } else {
      availableWSpace = Rect.fromLTWH(objectEndX, 0, layerRect.width - objectEndX, layerRect.height);
    }
    // check area to use the largest
    var availableHSpaceArea =  availableHSpace.size.width * availableHSpace.size.height;
    var availableWSpaceArea =  availableWSpace.size.width * availableWSpace.size.height;
    const MIN_WRITABLE_SPACE = 100;
    if(availableWSpaceArea > availableHSpaceArea && availableWSpace.width > MIN_WRITABLE_SPACE) {
      return availableWSpace;
    }
    return availableHSpace;
  }

  // -----------------------------------------------------------
  // private
  // -----------------------------------------------------------

  _searchChildElement(Element element, String key, {int n = 0}) {
    if(element.widget.key != null) {
      if(element.widget.key.toString().contains(key)) {
        this._result = element;
        return;
      }
    }
    element.visitChildElements((visitor) => _searchChildElement(visitor, key, n: n + 1));
  }

  _scanChildElement(RenderObject parentObject, Element element, Map<String, ElementModel> results, {int n = 0}) {
    if(element.widget.key != null && !results.containsKey(element.widget.key.toString())) {
      var bounds = element.findRenderObject().paintBounds;
      if(results.values.firstWhere((element) => element.bounds == bounds, orElse: () => null) == null) {
        results.putIfAbsent(
          element.widget.key.toString(),
          () => ElementModel(
            element.widget.key.toString(),
            bounds
          )
        );
      }
    }
    element.visitChildElements((visitor) =>  _scanChildElement(parentObject, visitor, results, n: n + 1));
  }
}

class ElementModel {
  String key;
  Rect bounds;

  ElementModel(this.key, this.bounds);
}