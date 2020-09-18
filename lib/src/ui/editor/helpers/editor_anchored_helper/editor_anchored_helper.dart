import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/editor/finder/finder_service.dart';
import 'package:palplugin/src/ui/client/helpers/anchored_helper_widget.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

import 'editor_anchored_helper_presenter.dart';
import 'editor_anchored_helper_viewmodel.dart';

abstract class EditorAnchoredFullscreenHelperView {

}


class EditorAnchoredFullscreenHelper extends StatelessWidget implements EditorAnchoredFullscreenHelperView {

  EditorAnchoredFullscreenHelper();

  @override
  Widget build(BuildContext context) {
    return MVVMPage<EditorAnchoredFullscreenPresenter, AnchoredFullscreenHelperViewModel>(
      key: ValueKey("EditorAnchoredFullscreenHelperPage"),
      presenter:  EditorAnchoredFullscreenPresenter(
        this,
        EditorInjector.of(context).finderService
      ),
      builder: (context, presenter, model) =>
        Material(
          color: Colors.black.withOpacity(0.3),
          child: Stack(
            children: [
              _createAnchoredWidget(model),
              _buildEditableTexts(presenter, model),
              ..._createSelectableElements(presenter, model),
              _buildRefreshButton(presenter)
            ],
          ),
        ),
    );
  }

  _createSelectableElements(EditorAnchoredFullscreenPresenter presenter, AnchoredFullscreenHelperViewModel model) {
    return presenter.viewModel.userPageElements
      .map((key, model) => new MapEntry(
            key,
            _WidgetElementModelTransformer().apply(key, model, presenter.onTapElement))
      )
      .values.toList();
  }
  
  _createAnchoredWidget(AnchoredFullscreenHelperViewModel model) {
    final element =  model.selectedAnchor;
    return Positioned.fill(
      child: Visibility(
        visible: model.selectedAnchor != null,
        child: SizedBox(
          child: CustomPaint(
            painter: AnchoredFullscreenPainter(
              currentPos: element?.value?.offset,
              anchorSize: element?.value?.rect?.size,
              padding: 0
            )
          )
        ),
      )
    );
  }

  _buildRefreshButton(EditorAnchoredFullscreenPresenter presenter) {
    return Positioned(
          top: 32, right: 32,
          child: FlatButton.icon(
            key: ValueKey("refreshButton"),
            onPressed: presenter.scanElements,
            color: Colors.black,
            icon: Icon(Icons.refresh, color: Colors.white,),
            label: Text("refresh", style: TextStyle(color: Colors.white),)
          ),
        );
  }

  _buildEditableTexts(EditorAnchoredFullscreenPresenter presenter, AnchoredFullscreenHelperViewModel model) {
    if(model.writeArea == null || model.selectedAnchor == null)
      return Container();
    return Positioned.fromRect(
      rect: model.writeArea ?? Rect.largest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              model.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18
              ),
            ),
          ),
          _buildPositivFeedback(),
          _buildNegativFeedback(),
        ],
      ),
    );
  }

  Widget _buildNegativFeedback() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        key: ValueKey("negativeFeedback"),
        child: Text(
          "This is not helping",
          style: TextStyle(
            // color: widget.textColor, fontSize: 10
          ),
          textAlign: TextAlign.center,
        ),
        // onTap: this.widget.onTrigger,
      ),
    );
  }

  Widget _buildPositivFeedback() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: InkWell(
        key: ValueKey("positiveFeedback"),
        child: Text(
          "Ok, thanks !",
          style: TextStyle(
            // color: widget.textColor,
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.center,
        ),
        // onTap: this.widget.onTrigger,
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
              color: Colors.white.withOpacity(model.selected ? 1 : .5),
              width: model.selected ? 4 : 2,
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
