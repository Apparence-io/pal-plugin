import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// this is used to load pal in asynchronous mode,
// can be used to call some asynchronous stuff like migrations, init etc.
class PalLoader extends StatefulWidget {
  final Widget Function(BuildContext, bool) builder;

  const PalLoader({Key? key, required this.builder}) : super(key: key);

  @override
  _PalLoaderState createState() => _PalLoaderState();
}

class _PalLoaderState extends State<PalLoader> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // if async loading done, then ignore loading (already done)
        if (!_isLoaded) {
          this.asynchronousLoading();
        }
        // trigger parent future builder loading
        return this.widget.builder(context, _isLoaded);
      },
    );
  }

  Future<void> asynchronousLoading() async {
    await Hive.initFlutter();
    // migrations...
    // async stuff goes here

    setState(() {
      // loading done, refresh state to inform parent
      // FutureBuilder job done
      this._isLoaded = true;
    });
  }
}
