import 'package:mvvm_builder/mvvm_builder.dart';

import 'route2_model.dart';
import 'route2_page.dart';

class Route2Presenter extends Presenter<Route2Model, Route2View>{
  Route2Presenter(Route2View viewInterface,) : super(Route2Model(), viewInterface);

}