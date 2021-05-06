import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pal/src/pal_utils.dart';

// this is used to load pal in asynchronous mode,
// can be used to call some asynchronous stuff like migrations, init etc.
class PalDatabaseInitializer extends StatefulWidget {
  final Widget Function(BuildContext, AsyncSnapshot<dynamic>) builder;

  const PalDatabaseInitializer({Key? key, required this.builder}) : super(key: key);

  @override
  _PalDatabaseInitializerState createState() => _PalDatabaseInitializerState();
}

class _PalDatabaseInitializerState extends State<PalDatabaseInitializer> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: this.widget.builder,
      future: !PalUtils.isRunningInTestEnv()
          ? asynchronousLoading()
          : Future.value(true),
    );
  }

  Future<bool> asynchronousLoading() async {
    if (!_isLoaded) {
      await Hive.initFlutter();

      // migrations...
      // async stuff goes here
      _isLoaded = true;
    }

    return _isLoaded;
  }
}
