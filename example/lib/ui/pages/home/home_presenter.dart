import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal_example/ui/pages/home/home_model.dart';
import 'package:pal_example/ui/pages/home/home_page.dart';

class HomePresenter extends Presenter<HomeModel, HomeView> {
  HomePresenter(
    HomeView viewInterface,
  ) : super(HomeModel(), viewInterface);
}
