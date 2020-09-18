import 'dart:async';

import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

class FinderService {

  PalNavigatorObserver observer;

  FinderService({@required this.observer});

  Future<ElementModel> searchChildElement(String key) async {
    // var completer = new Completer();
    var currentRoute = await observer.route.first;
    return ElementFinder(currentRoute.subtreeContext).searchChildElement(key);
  }

}