import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/media_gallery_loader.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/media_gallery_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/widgets/media_cell_widget.dart';

class _MediaGalleryLoaderMock extends Mock implements MediaGalleryLoader {}

void main() {
  group('Media gallery', () {
    testWidgets('should valid ui', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(
          find.byKey(ValueKey('pal_MediaGalleryPage_Header')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_MediaGalleryPage_Header_NoteText')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_MediaGalleryPage_SelectButton')),
          findsOneWidget);
      expect(
          find.text(
              'You can upload new image to your app gallery using web Pal admin.'),
          findsOneWidget);
    });

    testWidgets('should display media cells', (WidgetTester tester) async {
      await _beforeEach(tester);
      await tester.pump(Duration.zero);

      expect(find.byType(MediaCellWidget), findsNWidgets(6));
    });

    testWidgets('should select second cell', (WidgetTester tester) async {
      await _beforeEach(tester);
      await tester.pump(Duration.zero);

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}

Future _beforeEach(
  WidgetTester tester,
) async {
  final mediaGalleryLoader = _MediaGalleryLoaderMock();
  when(mediaGalleryLoader.load()).thenAnswer(
    (realInvocation) => Future.value(
      MediaGalleryModel(
        medias: [
          GraphicEntity(
            id: '20',
            url: 'https://picsum.photos/id/20/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '21',
            url: 'https://picsum.photos/id/21/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '22',
            url: 'https://picsum.photos/id/22/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '23',
            url: 'https://picsum.photos/id/23/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '24',
            url: 'https://picsum.photos/id/24/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '25',
            url: 'https://picsum.photos/id/25/200',
            uploadedDate: DateTime.now(),
          ),
        ],
      ),
    ),
  );
  when(mediaGalleryLoader.loadMore()).thenAnswer((realInvocation) => null);

  var app = MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context).buildTheme(),
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
