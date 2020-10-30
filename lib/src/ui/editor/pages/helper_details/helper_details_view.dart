import 'dart:io';
import 'package:mvvm_builder/mvvm_builder.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/widgets/snackbar_mixin.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';
import 'package:pal/src/router.dart';

import 'helper_details_model.dart';
import 'helper_details_presenter.dart';

abstract class HelperDetailsInterface {
  Future showDeleteDialog(
    HelperDetailsPresenter presenter,
  );
  Future onDialogCancel(
    BuildContext context,
  );
  Future onDialogApprove(
    BuildContext context,
    HelperDetailsPresenter presenter,
  );
  void showMessage(String message, bool success);
  void popBackToList();
  void launchHelperEditor();
}

class HelperDetailsComponentArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final HelperEntity helper;
  final String pageId;

  HelperDetailsComponentArguments(
    this.hostedAppNavigatorKey,
    this.helper,
    this.pageId,
  );
}

class HelperDetailsComponent extends StatelessWidget
    with SnackbarMixin
    implements HelperDetailsInterface {
  final EditorHelperService testHelperService;
  final HelperDetailsComponentArguments arguments;
  final _mvvmPageBuilder =
      MVVMPageBuilder<HelperDetailsPresenter, HelperDetailsModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  HelperDetailsComponent({
    Key key,
    @required this.arguments,
    this.testHelperService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('pal_HelperDetailsComponent_Builder'),
      context: context,
      presenterBuilder: (context) => HelperDetailsPresenter(
        HelperDetailsModel(),
        this,
        this.testHelperService ?? EditorInjector.of(context).helperService,
        this.arguments,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(context.buildContext, presenter, model),
          body: _buildBody(context.buildContext, model),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, HelperDetailsPresenter presenter,
      HelperDetailsModel model) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: PalTheme.of(context).colors.dark,
      ),
      title: Text(
        model?.helperName ?? 'Detail',
        style: TextStyle(
          color: PalTheme.of(context).colors.dark,
        ),
      ),
      actions: [
        CupertinoButton(
          key: ValueKey('editHelper'),
          onPressed: () => this.launchHelperEditor(),
          child: Icon(
            Icons.edit,
            color: PalTheme.of(context).colors.dark,
          ),
        ),
        CupertinoButton(
          key: ValueKey('deleteHelper'),
          onPressed: (!model.isDeleting)
              ? () => this.showDeleteDialog(presenter)
              : null,
          child: (!model.isDeleting)
              ? Icon(
                  Icons.delete,
                  color: PalTheme.of(context).colors.dark,
                )
              : SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: Opacity(
                    opacity: 0.7,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
        )
      ],
    );
  }

  _buildBody(BuildContext context, HelperDetailsModel model) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLine(
                'Available on version',
                '${model.helperMinVer ?? 'first'} - ${model.helperMaxVer ?? 'latest'}',
                context,
                ValueKey('versions'),
              ),
              _buildLine(
                'Trigger mode',
                getHelperTriggerTypeDescription(model.helperTriggerType),
                context,
                ValueKey('triggerMode'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildLine(
    String label,
    String text,
    BuildContext context,
    Key key,
  ) {
    TextStyle textStyle = TextStyle(
      color: PalTheme.of(context).colors.dark,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PalTheme.of(context).colors.dark.withAlpha(40),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              text,
              style: textStyle,
              key: key,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future showDeleteDialog(HelperDetailsPresenter presenter) {
    String title = 'Warning';
    String content = 'Are you sure to delete this helper ?';
    String cancelAction = 'Cancel';
    String yesAction = 'Yes 👍';

    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: _scaffoldKey.currentContext,
        builder: (context) {
          return CupertinoAlertDialog(
            key: ValueKey('pal_HelperDetailsComponent_DeleteDialog_iOS'),
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                key: ValueKey(
                    'pal_HelperDetailsComponent_DeleteDialog_iOS_Cancel'),
                child: Text(cancelAction),
                onPressed: () => this.onDialogCancel(context),
              ),
              CupertinoDialogAction(
                key: ValueKey(
                    'pal_HelperDetailsComponent_DeleteDialog_iOS_Approve'),
                child: Text(
                  yesAction,
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => this.onDialogApprove(context, presenter),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            key: ValueKey('pal_HelperDetailsComponent_DeleteDialog_Android'),
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                key: ValueKey(
                    'pal_HelperDetailsComponent_DeleteDialog_Android_Cancel'),
                child: Text(cancelAction),
                onPressed: () => this.onDialogCancel(context),
              ),
              FlatButton(
                key: ValueKey(
                    'pal_HelperDetailsComponent_DeleteDialog_Android_Approve'),
                child: Text(
                  yesAction,
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => this.onDialogApprove(context, presenter),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Future onDialogApprove(
    BuildContext context,
    HelperDetailsPresenter presenter,
  ) async {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop(true);
    await presenter.deleteHelper();
  }

  @override
  Future onDialogCancel(
    BuildContext context,
  ) async {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop(false);
  }

  @override
  showMessage(String message, bool success) {
    return showSnackbarMessage(_scaffoldKey, message, success);
  }

  @override
  void popBackToList() {
    Navigator.pop(_scaffoldKey.currentContext, HelperDetailsPopState.deleted);
  }

  @override
  void launchHelperEditor() {
    // Open editor overlay
    HelperEditorPageArguments args = HelperEditorPageArguments(
      arguments?.hostedAppNavigatorKey,
      arguments?.pageId,
      helperName: arguments?.helper?.name,
      helperMinVersion: arguments?.helper?.versionMin,
      triggerType: arguments?.helper?.triggerType,
      helperTheme: null, // TODO: Add theme feature
      helperType: arguments?.helper?.type,
    );
    var elementFinder = ElementFinder(arguments?.hostedAppNavigatorKey?.currentContext);
    showOverlayed(
      arguments?.hostedAppNavigatorKey,
      HelperEditorPageBuilder(args, elementFinder: elementFinder).build,
    );
    // Go back
    Navigator.of(_scaffoldKey.currentContext).pop(HelperDetailsPopState.editorOpened);
  }
}
