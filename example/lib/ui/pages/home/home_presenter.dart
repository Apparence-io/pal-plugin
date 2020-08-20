import 'package:mvvm_builder/mvvm_builder.dart';

import 'home_model.dart';
import 'home_page.dart';

class HomePresenter extends Presenter<HomeModel, HomeView> {
  HomePresenter(
    HomeView viewInterface,
  ) : super(HomeModel(), viewInterface);

  void incrementCounter() {
    this.viewModel.counter++;
    this.refreshView();
  }
}
