import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';

class MediaGalleryModel extends MVVMModel {
  List<GraphicEntity> medias;
  bool isLoading;
  bool isLoadingMore;
  bool isNoMore;
  GraphicEntity selectedMedia;

  MediaGalleryModel({
    this.medias,
    this.isLoading,
    this.isLoadingMore,
    this.isNoMore,
    this.selectedMedia,
  });
}
