import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/activities_section.dart';

void main() {
  group('ActivitiesSection Widget', () {
    testWidgets('renders nothing when thingsToDo is empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ActivitiesSection(thingsToDo: []),
      ));
      expect(find.byType(ActivitiesSection), findsOneWidget);
      // Should render nothing visible
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders and expands/collapses activities', (tester) async {
      final thingsToDo = [
        {
          'title': 'Activity 1',
          'subtitle': 'Subtitle 1',
          'content': [
            [
              {'text': 'Detail 1'},
              {'text': 'Detail 2'},
            ]
          ],
        },
        {
          'title': 'Activity 2',
          'subtitle': 'Subtitle 2',
          'content': [[
            {'text': 'Detail 3'},
          ]],
        },
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [ActivitiesSection(thingsToDo: thingsToDo)],
          ),
        ),
      ));
      // Both activities should be present
      expect(find.text('Activity 1'), findsOneWidget);
      expect(find.text('Activity 2'), findsOneWidget);
      // Tap to expand the first activity
      await tester.tap(find.text('Activity 1'));
      await tester.pumpAndSettle();
      // Should show content for Activity 1
      expect(find.text('Detail 1'), findsOneWidget);
      expect(find.text('Detail 2'), findsOneWidget);
      // Collapse the first activity
      await tester.tap(find.text('Activity 2'));
      await tester.pumpAndSettle();
      // Content should be gone
      expect(find.text('Detail 3'), findsOneWidget);
    });
  });
}
