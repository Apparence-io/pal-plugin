import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery_loader.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/widgets/media_cell_widget.dart';

import 'media_gallery_presenter.dart';
import 'media_gallery_viewmodel.dart';

class MediaGalleryPageArguments {
  final String mediaId;

  MediaGalleryPageArguments(
    this.mediaId,
  );
}

abstract class MediaGalleryView {
  void popBackToEditor(final GraphicEntity media);
}

class MediaGalleryPage extends StatelessWidget implements MediaGalleryView {
  final String mediaId;
  final MediaGalleryLoader loader;

  MediaGalleryPage({
    Key key,
    this.mediaId,
    this.loader,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<MediaGalleryPresenter, MediaGalleryModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final ScrollController _gridListController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => MediaGalleryPresenter(
        this,
        loader: this.loader ??
            MediaGalleryLoader(
              EditorInjector.of(context).projectGalleryRepository,
            ),
        mediaId: mediaId,
      ),
      builder: (context, presenter, model) {
        return WillPopScope(
          onWillPop: (){
            this.popBackToEditor(model.selectedMedia);
            return Future.value(false);
          },
                  child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                'My image gallery',
                style: TextStyle(
                  color: PalTheme.of(context.buildContext).colors.dark,
                ),
              ),
              iconTheme: IconThemeData(
                color: PalTheme.of(context.buildContext).colors.dark,
              ),
              backgroundColor: PalTheme.of(context.buildContext).colors.light,
            ),
            body: this._buildPage(context.buildContext, presenter, model),
          ),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final MediaGalleryPresenter presenter,
    final MediaGalleryModel model,
  ) {
    return Column(
      children: [
        Container(
          key: ValueKey('pal_MediaGalleryPage_Header'),
          color: PalTheme.of(context).colors.color1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'You can upload new image to your app gallery using web Pal admin.',
              key: ValueKey('pal_MediaGalleryPage_Header_NoteText'),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: (model.isLoading)
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  key: ValueKey('pal_MediaGalleryPage_Body_Grid'),
                  controller: this._gridListController
                    ..addListener(() {
                      if (this._gridListController.position.extentAfter <=
                          100) {
                        presenter.loadMore();
                      }
                    }),
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                  ),
                  padding: const EdgeInsets.all(2.0),
                  itemBuilder: (context, index) {
                    GraphicEntity media = model.medias[index];
                    return MediaCellWidget(
    // FIXME: Int or String ??
                      id: media.id.toString(),
                      url: media.url,
                      isSelected: model.selectedMedia?.id == media.id,
                      onTap: () => presenter.selectMedia(media),
                    );
                  },
                  itemCount: model.medias.length,
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 12.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Container(
            width: double.infinity,
            child: _buildSelectButton(context, presenter, model),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton(
    final BuildContext context,
    final MediaGalleryPresenter presenter,
    final MediaGalleryModel model,
  ) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        key: ValueKey('pal_MediaGalleryPage_SelectButton'),
        disabledColor: PalTheme.of(context).colors.color4,
        child: Text(
          'Select',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: PalTheme.of(context).colors.color1,
        onPressed: () => this.popBackToEditor(model.selectedMedia),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void popBackToEditor(final GraphicEntity media) {
    Navigator.pop(this._scaffoldKey.currentContext, media);
  }
}
