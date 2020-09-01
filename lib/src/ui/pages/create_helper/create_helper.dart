import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/router.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:palplugin/src/ui/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/shared/widgets/overlayed.dart';
import 'package:palplugin/src/ui/widgets/bordered_text_field.dart';

class CreateHelperPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  CreateHelperPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId,
  );
}

abstract class CreateHelperView {
  void onFormChanged(
    CreateHelperModel model,
    CreateHelperPresenter presenter,
  );
  void launchHelperEditor();
}

class CreateHelperPage extends StatefulWidget {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  CreateHelperPage({
    Key key,
    this.hostedAppNavigatorKey,
    this.pageId,
  });

  @override
  _CreateHelperPageState createState() => _CreateHelperPageState();
}

class _CreateHelperPageState extends State<CreateHelperPage>
    implements CreateHelperView {
  final _mvvmPageBuilder =
      MVVMPageBuilder<CreateHelperPresenter, CreateHelperModel>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => CreateHelperPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
            key: ValueKey('CreateHelper'),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: PalTheme.of(context.buildContext).colors.dark,
              ),
              title: Text(
                'Create new helper',
                style: TextStyle(
        color: PalTheme.of(context.buildContext).colors.dark,
                ),
              ),
            ),
            body: this._buildPage(context.buildContext, presenter, model),
          );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final CreateHelperPresenter presenter,
    final CreateHelperModel model,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 65.0),
              child: SingleChildScrollView(
                key: ValueKey('palCreateHelperScrollList'),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'packages/palplugin/assets/images/create_helper.png',
                        key: ValueKey('palCreateHelperImage'),
                        height: 205.0,
                      ),
                      SizedBox(height: 32.0),
                      Form(
                        key: _formKey,
                        onChanged: () => onFormChanged(model, presenter),
                        child: BorderedTextField(
                          label: 'Name',
                          hintText: 'My new helper',
                          key: ValueKey('palCreateHelperTextFieldName'),
                          validator: (String value) =>
                              (value.isEmpty) ? 'Please enter a name' : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: RaisedButton(
                    disabledColor: PalTheme.of(context).colors.color4,
                    child: Text(
                      'Next',
                      key: ValueKey('palCreateHelperNextButton'),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: PalTheme.of(context).colors.color1,
                    onPressed:
                        model.isFormValid ? () => launchHelperEditor() : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onFormChanged(
    CreateHelperModel model,
    CreateHelperPresenter presenter,
  ) {
    model.isFormValid = _formKey.currentState.validate();
    presenter.refreshView();
  }

  @override
  void launchHelperEditor() {
    HapticFeedback.selectionClick();

    OverlayEntry helperOverlay = OverlayEntry(
      opaque: false,
      builder: HelperEditorPageBuilder(
        widget.pageId,
        widget.hostedAppNavigatorKey,
      ).build,
    );
    Overlayed.of(context).entries.putIfAbsent(
          OverlayKeys.EDITOR_OVERLAY_KEY,
          () => helperOverlay,
        );
    widget.hostedAppNavigatorKey.currentState.overlay.insert(helperOverlay);
    Navigator.of(context).pop();
  }
}
