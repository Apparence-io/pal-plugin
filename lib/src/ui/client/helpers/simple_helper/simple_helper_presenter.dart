import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper_viewmodel.dart';

class SimpleHelperPresenter extends Presenter<SimpleHelperModel, SimpleHelperView>{
  SimpleHelperPresenter(
    SimpleHelperView viewInterface,
  ) : super(SimpleHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();
    this.viewModel.thumbAnimation = false;
    startAnimation();
  
  }
  void startAnimation() async{
     await Future.delayed(Duration(milliseconds: 350), () {
      this.viewModel.thumbAnimation = true;
      this.refreshAnimations();
    });
  }

}