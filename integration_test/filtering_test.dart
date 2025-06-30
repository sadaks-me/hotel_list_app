import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_list_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Clean up any existing cache
    try {
      final cacheDir = await getTemporaryDirectory();
      final dioCache = Directory('${cacheDir.path}/dio_cache');
      if (await dioCache.exists()) {
        await dioCache.delete(recursive: true);
      }
    } catch (e) {
      print('Cache cleanup failed: $e');
    }
  });

  tearDown(() async {
    // Clean up after tests
    try {
      final cacheDir = await getTemporaryDirectory();
      final dioCache = Directory('${cacheDir.path}/dio_cache');
      if (await dioCache.exists()) {
        await dioCache.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Cache cleanup failed: $e');
    }
  });

  testWidgets('Venue filtering updates the venue list', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Find and tap the filter chip (e.g., 'Venue type')
    final typeFilterChip = find.widgetWithText(FilterChip, 'Venue type');
    expect(typeFilterChip, findsOneWidget);
    await tester.tap(typeFilterChip);
    await tester.pumpAndSettle();

    // In the modal, select the 'Hotel' option
    final hotelCheckbox = find.widgetWithText(CheckboxListTile, 'Hotel');
    expect(hotelCheckbox, findsOneWidget);
    await tester.tap(hotelCheckbox);
    await tester.pumpAndSettle();

    // Tap the 'Apply' button
    final applyButton = find.widgetWithText(FilledButton, 'Apply');
    expect(applyButton, findsOneWidget);
    await tester.tap(applyButton);
    await tester.pumpAndSettle();

    // Verify that the 'Venue type' FilterChip is selected
    final venueTypeChip = tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Venue type'));
    expect(venueTypeChip.selected, isTrue);

    final beachClubFinder = find.text('Al Raha Beach Resort & Spa');
    expect(beachClubFinder, findsWidgets);
  });
}
