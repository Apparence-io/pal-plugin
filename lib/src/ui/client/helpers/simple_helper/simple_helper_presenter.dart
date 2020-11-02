import 'dart:async';

import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper_viewmodel.dart';

class SimpleHelperPresenter
    extends Presenter<SimpleHelperModel, SimpleHelperView> {
  SimpleHelperPresenter(
    SimpleHelperView viewInterface,
  ) : super(SimpleHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();
    this.viewModel.thumbAnimation = false;
    this.viewModel.boxTransitionAnimation = false;
    this.viewModel.shakeAnimation = false;

    startAnimation();
  }

  @override
  void afterViewInit() {
    super.afterViewInit();

    Future.delayed(Duration(milliseconds: 1000), () {
      this.viewModel.shakeAnimation = true;
      this.refreshAnimations();
    });

    this.viewModel.shakeAnimationTimer = Timer.periodic(
      Duration(milliseconds: 5200),
      (Timer t) {
        this.viewModel.shakeAnimation = true;
        this.refreshAnimations();
      },
    );
  }

  @override
  void onDestroy() {
    this.viewModel.shakeAnimationTimer?.cancel();

    super.onDestroy();
  }

  void startAnimation() async {
    await Future.delayed(Duration(milliseconds: 350), () {
      this.viewModel.boxTransitionAnimation = true;
      this.refreshAnimations();
    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      this.viewModel.thumbAnimation = true;
      this.refreshAnimations();
    });
  }

  onBoxAnimationEnd() {
    this.viewModel.boxTransitionAnimation = false;
  }

  onThumbAnimationEnd() {
    this.viewModel.thumbAnimation = false;
  }

  onShakeAnimationEnd() {
    this.viewModel.shakeAnimation = false;
  }
}
