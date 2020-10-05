import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/theme.dart';

import 'helper_details_model.dart';
import 'helper_details_presenter.dart';

abstract class HelperDetailsInterface {}

class HelperDetailsComponent extends StatelessWidget implements HelperDetailsInterface {
  final HelperEntity helper;
  final HelperClientService testHelperService;

  final _mvvmPageBuilder = MVVMPageBuilder<HelperDetailsPresenter, HelperDetailsModel>();

  HelperDetailsComponent({Key key, @required this.helper, this.testHelperService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      context: context,
      presenterBuilder: (context) => HelperDetailsPresenter(HelperDetailsModel(), this, this.testHelperService ?? UserInjector.of(context).helperService),
      builder: (context, presenter, model) => SafeArea(
        child: Scaffold(
          key: ValueKey("helperDetails"),
          appBar: _buildAppBar(context.buildContext,presenter),
          body: _buildBody(context.buildContext),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context,HelperDetailsPresenter presenter ) => AppBar(
        title: Text(
          this.helper.name,
          style: TextStyle(color: PalTheme.of(context).colors.color1),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: PalTheme.of(context).colors.color1),
        actions: [FlatButton(key: ValueKey('deleteHelper'),onPressed: presenter.deleteHelper, child: Icon(Icons.delete)),Divider(endIndent: 14,)],
      );

  _buildBody(BuildContext context) => Column(
        children: [
          _buildLine('Available on version', '${this.helper.versionMin} - ${this.helper.versionMax}',context,ValueKey('versions')),
          _buildLine('Trigger mode', getHelperTriggerTypeDescription(this.helper.triggerType),context,ValueKey('triggerMode'))
        ],
      );

  _buildLine(String label, String text,BuildContext context, Key key) {
    TextStyle textStyle = TextStyle(
      color: PalTheme.of(context).colors.color1
    );
    return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: PalTheme.of(context).colors.color1))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:16.0,horizontal:20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,style: textStyle.copyWith(fontWeight: FontWeight.bold),),
              Text(text, style: textStyle,key: key,),
            ],
          ),
        ),
      );
  }
}
