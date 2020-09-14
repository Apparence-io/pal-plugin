import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';


class EditorAnchoredFullscreenHelper extends StatefulWidget {

  final HelperEditorPresenter presenter;

  const EditorAnchoredFullscreenHelper({Key key, @required this.presenter}) : super(key: key);

  @override
  _EditorAnchoredFullscreenHelperState createState() => _EditorAnchoredFullscreenHelperState();
}

class _EditorAnchoredFullscreenHelperState extends State<EditorAnchoredFullscreenHelper> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scanElements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Stack(
        children: widget.presenter.viewModel.userPageElements
          .map((key, model) => new MapEntry(key, _WidgetElementModelAdapter().apply(key, model)))
          .values.toList()
          ..add(
            Positioned(
              top: 32, right: 32,
              child: FlatButton.icon(
                key: ValueKey("refreshButton"),
                onPressed: _scanElements,
                color: Colors.black,
                icon: Icon(Icons.refresh, color: Colors.white,),
                label: Text("refresh", style: TextStyle(color: Colors.white),)
              ),
            )
          )
      ),
    );
  }

  void _scanElements() {
    widget.presenter.scanElements();
    setState(() {});
  }
}

class _WidgetElementModelAdapter {

  Widget apply(String key, WidgetElementModel model) {
    return Positioned(
      left: model.offset.dx,
      top: model.offset.dy,
      child: Container(
        key: ValueKey("elementContainer"),
        width: model.rect.width,
        height: model.rect.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(.5),
            width: 2,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Text("$key",
            //   style: TextStyle(color: Colors.white)
            // ),
          ),
        ),
      )
    );
  }
}
