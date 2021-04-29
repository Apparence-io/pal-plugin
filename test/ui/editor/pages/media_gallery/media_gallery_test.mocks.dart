// Mocks generated by Mockito 5.0.7 from annotations
// in pal/test/ui/editor/pages/media_gallery/media_gallery_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pal/src/database/entity/graphic_entity.dart' as _i5;
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery_loader.dart'
    as _i3;
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery_viewmodel.dart'
    as _i2;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeMediaGalleryModel extends _i1.Fake implements _i2.MediaGalleryModel {
}

/// A class which mocks [MediaGalleryLoader].
///
/// See the documentation for Mockito's code generation for more information.
class MockMediaGalleryLoader extends _i1.Mock
    implements _i3.MediaGalleryLoader {
  MockMediaGalleryLoader() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.MediaGalleryModel> load() =>
      (super.noSuchMethod(Invocation.method(#load, []),
              returnValue:
                  Future<_i2.MediaGalleryModel>.value(_FakeMediaGalleryModel()))
          as _i4.Future<_i2.MediaGalleryModel>);
  @override
  _i4.Future<List<_i5.GraphicEntity>> loadMore() =>
      (super.noSuchMethod(Invocation.method(#loadMore, []),
              returnValue:
                  Future<List<_i5.GraphicEntity>>.value(<_i5.GraphicEntity>[]))
          as _i4.Future<List<_i5.GraphicEntity>>);
}
