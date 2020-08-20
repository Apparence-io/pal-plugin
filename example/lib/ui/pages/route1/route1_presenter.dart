import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal_example/ui/pages/route1/route1_model.dart';
import 'package:pal_example/ui/pages/route1/route1_page.dart';

class Route1Presenter extends Presenter<Route1Model, Route1View>{
  Route1Presenter(Route1View viewInterface,) : super(Route1Model(), viewInterface);

}