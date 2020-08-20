import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_presenter.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

abstract class HelpersListModalView {}

class HelpersListModal extends StatelessWidget implements HelpersListModalView {
  HelpersListModal({Key key});

  @override
  Widget build(BuildContext context) {
    return MVVMPage<HelpersListModalPresenter, HelpersListModalModel>(
      key: ValueKey('palHelpersListModal'),
      presenter: HelpersListModalPresenter(this),
      builder: (context, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 40.0,
            automaticallyImplyLeading: false,
            title: Text('Pal editor'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  key: ValueKey('palHelpersListModalClose'),
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context.buildContext),
                ),
              ),
            ],
          ),
          body: this._buildPage(
            context.buildContext,
            presenter,
            model,
          ),
        );
      },
    );
  }

  Widget _buildPage(
      final BuildContext context,
      final HelpersListModalPresenter presenter,
      final HelpersListModalModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RaisedButton(
        child: Text('TEST'),
        onPressed: () => Navigator.pushNamed(context, '/editor/new'),
      ),
    );
  }
}
