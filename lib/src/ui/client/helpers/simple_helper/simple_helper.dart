import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper_presenter.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper_viewmodel.dart';

import '../../helper_client_models.dart';

abstract class SimpleHelperView {
  void disposeAnimation();
}

class SimpleHelperPage extends StatelessWidget implements SimpleHelperView {
  final CustomLabel descriptionLabel;
  final Color backgroundColor;

  // FIXME: Add in MVVM Builder a way to dispose all animations in presenter.
  MvvmContext _mvvmContext;

  SimpleHelperPage(
      {Key key,
      @required this.descriptionLabel,
      @required this.backgroundColor})
      : assert(backgroundColor != null),
        assert(descriptionLabel != null);

  final _mvvmPageBuilder =
      MVVMPageBuilder<SimpleHelperPresenter, SimpleHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => SimpleHelperPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        _mvvmContext = context;

        return Container(
          width: MediaQuery.of(context.buildContext).size.width,
          decoration: BoxDecoration(
              color: this.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 8),
                    blurRadius: 8,
                    spreadRadius: 2)
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildLeft(context),
                 _buildContent(),
                _buildRight(context),
              ],
            ),
          ),
        );
      },
      singleAnimControllerBuilder: (tick){
         return AnimationController(vsync: tick, duration: Duration(milliseconds: 500));
      },
      animListener: (context, presenter, model) {
        if(model.thumbAnimation){
          context.animationController
              .repeat(reverse: true);
              }
      },
    );
  }

  Flexible _buildLeft(MvvmContext mvvmContext) {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 16),
          AnimatedBuilder(
            animation: mvvmContext.animationController,
            builder: (context, child) => Transform.scale(
              scale: sin(mvvmContext.animationController.value) * pi / 2,
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.keyboard_arrow_left,
                  color: Colors.white, size: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 8, 0),
            child: Icon(
              Icons.thumb_down,
              color: Colors.white,
              size: 14,
            ),
          )
        ],
      ),
    );
  }

  Flexible _buildRight(MvvmContext mvvmContext) {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(height: 16),
          AnimatedBuilder(
            animation: mvvmContext.animationController,
            builder: (context, child) => Transform.scale(
              scale: sin(mvvmContext.animationController.value) * pi / 2,
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 8, 0),
            child: Icon(
              Icons.thumb_up,
              color: Colors.white,
              size: 14,
            ),
          )
        ],
      ),
    );
  }

  Flexible _buildContent() {
    return Flexible(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                this.descriptionLabel.text,
                style: TextStyle(
                    color: this.descriptionLabel.fontColor,
                    fontSize: this.descriptionLabel.fontSize),
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void disposeAnimation() {
    _mvvmContext.animationController.stop();
    _mvvmContext.animationController.dispose();
  }
}
