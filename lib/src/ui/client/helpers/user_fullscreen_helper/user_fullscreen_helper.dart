import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';

import 'user_fullscreen_helper_presenter.dart';
import 'user_fullscreen_helper_viewmodel.dart';

abstract class UserFullScreenHelperView {}

class UserFullScreenHelperPage extends StatelessWidget
    implements UserFullScreenHelperView {
  final Color backgroundColor;
  final CustomLabel titleLabel;
  final CustomLabel positivLabel;
  final CustomLabel negativLabel;
  final Function onTrigger;

  UserFullScreenHelperPage({
    Key key,
    @required this.backgroundColor,
    @required this.titleLabel,
    @required this.onTrigger,
    this.positivLabel,
    this.negativLabel,
  })  : assert(backgroundColor != null),
        assert(titleLabel != null),
        assert(onTrigger != null);

  final _mvvmPageBuilder = MVVMPageBuilder<UserFullScreenHelperPresenter,
      UserFullScreenHelperModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => UserFullScreenHelperPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: backgroundColor,
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final UserFullScreenHelperPresenter presenter,
    final UserFullScreenHelperModel model,
  ) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      opacity: model.helperOpacity,
      child: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  key: ValueKey('pal_UserFullScreenHelperPage_Icon'),
                  flex: 4,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://static3.rapunchline.fr/wp-content/uploads/2020/04/pnl.jpg',
                  ),
                ),
                Flexible(
                  key: ValueKey('pal_UserFullScreenHelperPage_Title'),
                  flex: 3,
                  child: Text(
                    titleLabel?.text ?? 'Title',
                    style: TextStyle(
                      color: titleLabel?.fontColor ?? PalTheme.of(context).colors.light,
                      backgroundColor: titleLabel?.backgroundColor,
                      fontSize: titleLabel?.fontSize ?? 60.0,
                    ),
                  ),
                ),
                Flexible(
                  key: ValueKey('pal_UserFullScreenHelperPage_PositivButton'),
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                    positivLabel?.text ?? 'Ok, thanks !',
                    style: TextStyle(
                      color: positivLabel?.fontColor ?? PalTheme.of(context).colors.light,
                      backgroundColor: positivLabel?.backgroundColor,
                      fontSize: positivLabel?.fontSize ?? 60.0,
                    ),
                  ),
                  ),
                ),
                Flexible(
                  key: ValueKey('pal_UserFullScreenHelperPage_NegativButton'),
                  flex: 3,
                  child: Text('dkjf'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
