import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

class FinderService {

  PalNavigatorObserver observer;

  FinderService({@required this.observer});

  Future<ElementModel> searchChildElement(String key) async {
    var completer = new Completer<ElementModel>();
    var currentRoute = await observer.route.first;
    if(WidgetsBinding.instance.hasScheduledFrame) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ElementModel res = ElementFinder(currentRoute.subtreeContext).searchChildElement(key);
        completer.complete(res);
      });
    } else {
      ElementModel res = ElementFinder(currentRoute.subtreeContext).searchChildElement(key);
      completer.complete(res);
    }
    return completer.future;
  }

  Future<Map<String, ElementModel>> scan({Key omitChildsOf, bool debugMode = false}) async {
    var completer = new Completer<Map<String, ElementModel>>();
    var currentRoute = await observer.route.first;
    if(WidgetsBinding.instance.hasScheduledFrame) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        completer.complete(ElementFinder(currentRoute.subtreeContext).scan());
      });
    } else {
      completer.complete(ElementFinder(currentRoute.subtreeContext).scan());
    }
    return completer.future;
  }

  Future<Rect> getLargestAvailableSpace(ElementModel element) async {
    var currentRoute = await observer.route.first;
    return ElementFinder(currentRoute.subtreeContext).getLargestAvailableSpace(element);
  }

}