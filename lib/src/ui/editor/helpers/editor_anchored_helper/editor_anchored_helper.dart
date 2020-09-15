import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

import 'editor_anchored_helper_presenter.dart';
import 'editor_anchored_helper_viewmodel.dart';

abstract class EditorAnchoredFullscreenHelperView {

}


class EditorAnchoredFullscreenHelper extends StatelessWidget implements EditorAnchoredFullscreenHelperView {

  final ElementFinder elementFinder;

  EditorAnchoredFullscreenHelper({@required this.elementFinder});

  @override
  Widget build(BuildContext context) {
    return MVVMPage<EditorAnchoredFullscreenPresenter, AnchoredFullscreenHelperViewModel>(
      key: ValueKey("EditorAnchoredFullscreenHelperPage"),
      presenter:  EditorAnchoredFullscreenPresenter(
        this,
        elementFinder //FIXME use hosted nav context
      ),
      builder: (context, presenter, model) =>
        Material(
          color: Colors.black.withOpacity(0.3),
          child: Stack(
            children: presenter.viewModel.userPageElements
              .map((key, model) => new MapEntry(
                    key,
                    _WidgetElementModelTransformer().apply(key, model, presenter.onTapElement))
              )
              .values.toList()
              ..add(
                Positioned(
                  top: 32, right: 32,
                  child: FlatButton.icon(
                    key: ValueKey("refreshButton"),
                    onPressed: presenter.scanElements,
                    color: Colors.black,
                    icon: Icon(Icons.refresh, color: Colors.white,),
                    label: Text("refresh", style: TextStyle(color: Colors.white),)
                  ),
                )
              )
          ),
        ),
    );
  }
}


typedef OnTapElement = void Function(String key);

class _WidgetElementModelTransformer {
  
  Widget apply(String key, WidgetElementModel model, OnTapElement onTap) {
    return Positioned(
      left: model.offset.dx,
      top: model.offset.dy,
      child: InkWell(
        key: ValueKey("elementContainer"),
        onTap: () => onTap(key),
        child: Container(
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
        ),
      )
    );
  }
  
}
