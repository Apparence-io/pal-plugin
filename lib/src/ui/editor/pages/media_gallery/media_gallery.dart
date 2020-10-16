import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/media_gallery_loader.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/widgets/media_cell_widget.dart';

import 'media_gallery_presenter.dart';
import 'media_gallery_viewmodel.dart';

class MediaGalleryPageArguments {
  final GraphicEntity media;

  MediaGalleryPageArguments(
    this.media,
  );
}

abstract class MediaGalleryView {
  void popBackToEditor(final MediaGalleryModel model);
}

class MediaGalleryPage extends StatelessWidget implements MediaGalleryView {
  final GraphicEntity media;
  final MediaGalleryLoader loader;

  MediaGalleryPage({
    Key key,
    this.media,
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
        media: media,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
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
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final MediaGalleryPresenter presenter,
    final MediaGalleryModel model,
  ) {
    return GestureDetector(
      onTap: () => presenter.selectMedia(null),
      child: Column(
        children: [
          Container(
            key: ValueKey('pal_MediaGalleryPage_Header'),
            color: PalTheme.of(context).colors.color1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You can upload new image to your app gallery using web Pal admin.',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: (model.isLoading || model.isLoadingMore)
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                    ),
                    padding: const EdgeInsets.all(2.0),
                    itemBuilder: (context, index) {
                      GraphicEntity media = model.medias[index];

                      return MediaCellWidget(
                        id: media.id,
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
      ),
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
        onPressed: () => this.popBackToEditor(model),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void popBackToEditor(final MediaGalleryModel model) {
    Navigator.pop(this._scaffoldKey.currentContext, model.selectedMedia);
  }
}
