import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery_loader.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/widgets/media_cell_widget.dart';

class MediaGalleryLoaderMock extends Mock implements MediaGalleryLoader {}

void main() {

  group('Media gallery', () {

    final mediasData = MediaGalleryModel(
      medias: List.generate(6, (i) => GraphicEntity(
          id: '${20 + i}',
          url: 'https://picsum.photos/id/${20 + i}/200',
          uploadedDate: DateTime.now(),
        )
      )
    );

    final mediaGalleryLoader = MediaGalleryLoaderMock();

    Future _beforeEach(WidgetTester tester) async {
      var app = MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context)!.buildTheme(),
              home: MediaGalleryPage(
                loader: mediaGalleryLoader,
                mediaId: '21',
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump();
    }

    setUpAll(() => HttpOverrides.global = null);

    tearDown(() {
      reset(mediaGalleryLoader);
    });

    testWidgets('should valid ui', (WidgetTester tester) async {
      when(() => mediaGalleryLoader.loadMore()).thenAnswer((_) async => List<GraphicEntity>.empty());
      when(() => mediaGalleryLoader.load()).thenAnswer((_) async => mediasData);
      await _beforeEach(tester);

      expect(find.byKey(ValueKey('pal_MediaGalleryPage_Header')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_MediaGalleryPage_Header_NoteText')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_MediaGalleryPage_SelectButton')), findsOneWidget);
      expect(find.text('You can upload new image to your app gallery using web Pal admin.'),
          findsOneWidget);
    });

    testWidgets('should display media cells', (WidgetTester tester) async {
      when(() => mediaGalleryLoader.loadMore()).thenAnswer((_) async => List<GraphicEntity>.empty());
      when(() => mediaGalleryLoader.load()).thenAnswer((_) async => mediasData);
      await _beforeEach(tester);
      await tester.pump(Duration.zero);

      expect(find.byType(MediaCellWidget), findsNWidgets(6));
    });

    testWidgets('should select second cell', (WidgetTester tester) async {
      when(() => mediaGalleryLoader.loadMore()).thenAnswer((_) async => List<GraphicEntity>.empty());
      when(() => mediaGalleryLoader.load()).thenAnswer((_) async => mediasData);
      await _beforeEach(tester);
      await tester.pump(Duration.zero);

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}


