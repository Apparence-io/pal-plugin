import 'package:mvvm_builder/mvvm_builder.dart';

import 'route1_model.dart';
import 'route1_page.dart';

class Route1Presenter extends Presenter<Route1Model, Route1View>{
  Route1Presenter(Route1View viewInterface,) : super(Route1Model(), viewInterface);

}