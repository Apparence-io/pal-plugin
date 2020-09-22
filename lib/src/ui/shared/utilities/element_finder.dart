import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

/// This class helps you find element within your app
/// use [searchChildElement] with a String containing key value
/// result is available in [result] and returns an [Element]
class ElementFinder {

  // Prefer use the navigatorContext to get full context tree
  final BuildContext context;

  ElementFinder(this.context);

  // this method scan all child recursively to get all widget bounds we could select for an helper
  Map<String, ElementModel> scan({Key omitChildsOf, bool debugMode = false}) {
    Map<String, ElementModel> results = Map<String, ElementModel>();
    context.visitChildElements((element) => _scanChildElement(
        context.findRenderObject(),
        element,
        results,
        omitChildsOf: omitChildsOf,
        debugMode: debugMode
      ));
    return results;
  }

  // List all pages from this context
  List<PageElement> scanPages() {
    var pages = List<PageElement>();
    context.visitChildElements((element) => _scanPageChildElement(element, pages));
    return pages;
  }

  // this method scan all child recursively to find a widget having a key == searchedKey
  ElementModel searchChildElement(String key) {
    ElementModel result = ElementModel.empty();
    context.visitChildElements((element) => _searchChildElement(element, key, result));
    if(result.element != null) {
      return _createElementModel(context.findRenderObject(), result.element);
    }
    return result;
  }

  /// This functions search for the maximum rect available space
  /// We use it for example to find the most available space to write a text in our anchored helper
  Rect getLargestAvailableSpace(ElementModel elementModel) {
    var parentObject = context.findRenderObject();
    var element = elementModel.element;
    var translation = element.renderObject.getTransformTo(parentObject).getTranslation();
    var objectX = translation.x;
    var objectEndX = objectX + element.size.width;
    var objectY = translation.y;
    var objectEndY = objectY + element.size.height;
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
  _searchChildElement(Element element, String key, ElementModel result, {int n = 0}) {
    if(result.element == null && element.widget.key != null && element.widget.key.toString().contains(key)) {
      result.element = element;
    }
    if(result.element != null) {
      return;
    }
    element.visitChildElements((visitor) => _searchChildElement(visitor, key, result, n: n + 1));
  }

  // omits elements with key starting with anything other than [<
  // flutter makes key with "[<_myKey_>]" for our keys
  // scan all elements in the current page tree and add their bounds to the results map
  _scanChildElement(RenderObject parentObject, Element element, Map<String, ElementModel> results, {int n = 0, Key omitChildsOf, bool debugMode = true}) {
    if(debugMode) {
      var nbChilds = element.debugDescribeChildren().length;
      var pre = StringBuffer();
      for(int i = 0; i<n ; i++) {
        pre.write(" ");
      }
      print("$pre ${element?.widget.runtimeType}  $n => $nbChilds ");
    }
    if(element.widget.key != null && omitChildsOf !=null && element.widget.key.toString() == omitChildsOf.toString()) {
      return;
    }
    if(element.widget.key != null && element.widget.key.toString().startsWith("[<") && !results.containsKey(element.widget.key.toString())) {
      if(debugMode) {
        print("  added ${element?.widget?.key.toString()} : $n");
      }
      var model = _createElementModel(parentObject, element);
      if(results.values.firstWhere((element) => element.bounds == model.bounds && element.offset == model.offset, orElse: () => null) == null) {
        results.putIfAbsent(element.widget.key.toString(), () => model);
      }
    }
    element.visitChildElements((visitor) =>  _scanChildElement(parentObject, visitor, results, n: n + 1, omitChildsOf: omitChildsOf, debugMode: debugMode));
  }

  // search first entries that contains our pages
  _scanPageChildElement(Element element, List<PageElement> pages) {
    if(element.runtimeType.toString() == "_Theatre") {
      element.visitChildElements((visitor) => pages.add(PageElement(element)));
    } else {
      element.visitChildElements((visitor) => _scanPageChildElement(element, pages));
    }
  }

  ElementModel _createElementModel(RenderObject parentObject, Element element) {
    var renderObject = element.findRenderObject();
    var bounds = element.findRenderObject().paintBounds;
    var translation = renderObject.getTransformTo(parentObject).getTranslation();
    var offset = Offset(translation.x, translation.y);
    return ElementModel(
      element.widget.key.toString(),
      bounds,
      offset,
      element.widget.runtimeType,
      element: element
    );
  }
}

class PageElement {

  Element element;

  PageElement(this.element);
}

class ElementModel {

  String key;

  Rect bounds;

  Offset offset;

  Element element;

  Type runtimeType;

  ElementModel(this.key, this.bounds, this.offset, this.runtimeType, {this.element});

  factory ElementModel.empty() => ElementModel(null, null, null, null);
}
