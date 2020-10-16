import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/media_gallery_loader.dart';

import 'media_gallery.dart';
import 'media_gallery_viewmodel.dart';

class MediaGalleryPresenter
    extends Presenter<MediaGalleryModel, MediaGalleryView> {
  final GraphicEntity media;
  final MediaGalleryLoader loader;

  MediaGalleryPresenter(
    MediaGalleryView viewInterface, {
    this.media,
    @required this.loader,
  }) : super(MediaGalleryModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.isLoading = true;
    this.viewModel.isNoMore = false;
    this.viewModel.isLoadingMore = false;

    this.loader.load().then((MediaGalleryModel res) {
      this.viewModel.medias = res.medias;
      this.viewModel.isLoading = false;

      if (media != null) {
        this.selectMedia(media);
      } else {
        this.refreshView();
      }
    });
  }

  void loadMore() {
    if (!this.viewModel.isNoMore && !this.viewModel.isLoadingMore) {
      this.viewModel.isLoadingMore = true;
      this.refreshView();

      this.loader.loadMore().then((value) {
        if (value.isEmpty) {
          this.viewModel.isNoMore = true;
        } else {
          this.viewModel.medias.addAll(value);
        }
        this.viewModel.isLoadingMore = false;
        this.refreshView();
      });
    }
  }

  selectMedia(GraphicEntity media) {
    this.viewModel.selectedMedia = media;
    this.refreshView();
  }
}
