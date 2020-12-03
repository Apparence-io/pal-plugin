
import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';

import '../../../../router.dart';
import 'helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'helpers/editor_simple_helper/editor_simple_helper.dart';
import 'helpers/editor_update_helper/editor_update_helper.dart';

/// this class will show the correct helper editor for each types
class EditorRouter {

  final GlobalKey<NavigatorState> hostedAppNavigatorKey;

  EditorRouter(this.hostedAppNavigatorKey);

  /// Open editor page as an overlay
  Future createHelper(
    final String currentPageRoute,
    final CreateHelperModel model) async
  {
    var elementFinder = ElementFinder(hostedAppNavigatorKey.currentContext);
    HelperEditorPageArguments args = HelperEditorPageArguments(
      hostedAppNavigatorKey,
      currentPageRoute,
      isOnEditMode: false,
      helperMinVersion: model.minVersionController?.value?.text,
    );
    WidgetBuilder builder;
    switch(model.selectedHelperType) {
      case HelperType.SIMPLE_HELPER:
        builder = (context) => EditorSimpleHelperPage.create(
          parameters: args,
          helperViewModel: model.asHelperViewModel(),
        );
        break;
      case HelperType.UPDATE_HELPER:
        builder = (context) => EditorUpdateHelperPage.create(
          parameters: args,
          helperViewModel: model.asHelperViewModel(),
        );
        break;
      case HelperType.HELPER_FULL_SCREEN:
        builder = (context) => EditorFullScreenHelperPage.create(
          parameters: args,
          helperViewModel: model.asHelperViewModel(),
        );
        break;
      default:
        throw 'HELPER TYPE NOT HANDLED';
    }
    showOverlayed(hostedAppNavigatorKey, builder);
  }

  Future editHelper(final HelperEntity helperEntity) async {
    var elementFinder = ElementFinder(hostedAppNavigatorKey.currentContext);
    HelperEditorPageArguments args = HelperEditorPageArguments(
      hostedAppNavigatorKey,
      null,
      isOnEditMode: true,
    );
    WidgetBuilder builder;
    switch(helperEntity.type) {
      case HelperType.SIMPLE_HELPER:
        builder = (context) => EditorSimpleHelperPage.edit(
          parameters: args,
          helperEntity: helperEntity,
        );
        break;
      case HelperType.UPDATE_HELPER:
        builder = (context) => EditorUpdateHelperPage.edit(
          parameters: args,
          helperEntity: helperEntity,
        );
        break;
      case HelperType.HELPER_FULL_SCREEN:
        builder = (context) => EditorFullScreenHelperPage.edit(
          parameters: args,
          helperEntity: helperEntity,
        );
        break;
      default:
        throw 'HELPER TYPE NOT HANDLED';
    }
    showOverlayed(hostedAppNavigatorKey, builder);
  }
}