import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

void main() {
  group('Element finder', () {
    Widget page = Scaffold(
      body: Column(
        children: [
          Text("Test Text", key: ValueKey("text1")),
          Text("Test Text 2", key: ValueKey("text2")),
          Text("Test Text 3", key: ValueKey("text3")),
          Container(key: ValueKey("container"), height: 50, width: 150)
        ],
      ),
    );

    testWidgets('search a widget by key and find location + size', (WidgetTester tester) async {
      BuildContext _context;
      var app = new MediaQuery(data: MediaQueryData(),
        child: MaterialApp(home: Builder(
          builder: (context) {
            _context = context;
            return page;
          },
        ))
      );
      await tester.pumpWidget(app);
      ElementFinder finder =  ElementFinder(_context);
      finder.searchChildElement("container");
      expect(finder.result, isNotNull);
      expect(finder.result.size, equals(Size(150, 50)));
    });

  });
}