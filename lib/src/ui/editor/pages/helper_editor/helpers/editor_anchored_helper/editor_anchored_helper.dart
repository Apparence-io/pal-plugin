import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/anchored_helper_widget.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';

import '../../helper_editor.dart';
import '../../helper_editor_viewmodel.dart';
import 'editor_anchored_helper_presenter.dart';
import 'editor_anchored_helper_viewmodel.dart';

abstract class EditorAnchoredFullscreenHelperView {

}


class EditorAnchoredFullscreenHelper extends StatelessWidget implements EditorAnchoredFullscreenHelperView {

  EditorAnchoredFullscreenHelper._({
    Key key,
  }) : super(key: key);

  factory EditorAnchoredFullscreenHelper.create({
    Key key,
    HelperEditorPageArguments parameters,
    EditorHelperService helperService,
    @required HelperViewModel helperViewModel
  }) => EditorAnchoredFullscreenHelper._(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorAnchoredFullscreenPresenter, AnchoredFullscreenHelperViewModel>()
        .build(
          context: context,
          key: ValueKey("EditorAnchoredFullscreenHelperPage"),
          presenterBuilder: (context) => EditorAnchoredFullscreenPresenter(
            this,
            EditorInjector.of(context).finderService
          ),
          singleAnimControllerBuilder: (tickerProvider) => AnimationController(
                vsync: tickerProvider,
                duration: Duration(seconds: 1)
              )
              ..repeat(reverse: true),
          animListener: (context, presenter, model) {},
          builder: (context, presenter, model) =>
            Material(
              color: Colors.black.withOpacity(0.3),
              child: Stack(
                children: [
                  _createAnchoredWidget(model, context.animationController),
                  _buildEditableTexts(presenter, model),
                  ..._createSelectableElements(presenter, model),
                  _buildRefreshButton(presenter),
                  _buildConfirmSelectionButton(context.buildContext, presenter, model)
                ],
              ),
            )
    );
  }

  _createSelectableElements(EditorAnchoredFullscreenPresenter presenter, AnchoredFullscreenHelperViewModel model) {
    return model.userPageSelectableElements
      .map((key, model) => new MapEntry(
            key,
            _WidgetElementModelTransformer().apply(key, model, presenter.onTapElement))
      )
      .values
      .toList();
  }
  
  _createAnchoredWidget(AnchoredFullscreenHelperViewModel model, AnimationController animationController) {
    final element =  model.selectedAnchor;
    return Positioned.fill(
      child: Visibility(
        visible: model.selectedAnchor != null,
        child: AnimatedAnchoredFullscreenCircle(
          listenable: animationController,
          currentPos: element?.value?.offset,
          anchorSize: element?.value?.rect?.size,
          padding: 4
        ),
      )
    );
  }

  _buildConfirmSelectionButton(
    BuildContext context,
    EditorAnchoredFullscreenPresenter presenter,
    AnchoredFullscreenHelperViewModel model) {
    if(model.selectedAnchor == null || model.anchorValidated)
      return Container();
    return Positioned(
      left: model.selectedAnchor.value.offset.dx,
      top: model.selectedAnchor.value.offset.dy,
      child: EditorButton.validate(
          PalTheme.of(context),
          presenter.validateSelection,
          key: ValueKey("validateSelectionBtn")
      )
    );
  }

  _buildRefreshButton(EditorAnchoredFullscreenPresenter presenter) {
    return Positioned(
          top: 32, right: 32,
          child: FlatButton.icon(
            key: ValueKey("refreshButton"),
            onPressed: presenter.resetSelection,
            color: Colors.black,
            icon: Icon(Icons.refresh, color: Colors.white,),
            label: Text("refresh", style: TextStyle(color: Colors.white),)
          ),
        );
  }

  _buildEditableTexts(EditorAnchoredFullscreenPresenter presenter, AnchoredFullscreenHelperViewModel model) {
    if(model.writeArea == null || model.selectedAnchor == null || !model.anchorValidated)
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildNegativFeedback(),
              _buildPositivFeedback(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNegativFeedback() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        key: ValueKey("negativeFeedback"),
        child: Text(
          "This is not helping",
          style: TextStyle(
            fontSize: 14,
            // color: widget.textColor, fontSize: 10
          ),
          textAlign: TextAlign.center,
        ),
        // onTap: this.widget.onTrigger,
      ),
    );
  }

  Widget _buildPositivFeedback() {
    return InkWell(
      key: ValueKey("positiveFeedback"),
      child: Text(
        "Ok, thanks!",
        style: TextStyle(
          // color: widget.textColor,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      // onTap: this.widget.onTrigger,
    );
  }
  
}


typedef OnTapElement = void Function(String key);

class _WidgetElementModelTransformer {
  
  Widget apply(String key, WidgetElementModel model, OnTapElement onTap) {
    // debugPrint("$key: w:${model.rect.width} h:${model.rect.height} => ${model.offset.dx} ${model.offset.dy}");
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
