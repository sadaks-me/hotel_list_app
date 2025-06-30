import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hotel_list_app/core/error/error_messages.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_model.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_model.dart';
import 'package:hotel_list_app/features/venues/presentation/pages/venue_details_page.dart';
import 'package:hotel_list_app/features/venues/presentation/pages/venue_list_page.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venue_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venue_state.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/venue_card.dart';
import 'package:hotel_list_app/shared/widgets/error_view.dart';
import 'package:hotel_list_app/shared/widgets/shimmer_loading.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shimmer/shimmer.dart';

import 'venue_list_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VenueBloc>()])
void main() {
  group('VenueListPage Widget', () {
    late VenueBloc mockBloc;

    setUp(() {
      mockBloc = MockVenueBloc();
      Get.reset(); // Reset Get before each test
    });

    Widget makeTestableWidget(Widget child) {
      return MaterialApp(
        theme: ThemeData(
          // Add theme data for proper Shimmer rendering
          colorScheme: const ColorScheme.light(),
        ),
        home: BlocProvider<VenueBloc>.value(
          value: mockBloc,
          child: child,
        ),
      );
    }

    testWidgets('shows shimmer loading when state is VenuesLoading', (tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(VenuesLoading());
      when(mockBloc.stream).thenAnswer((_) => Stream<VenueState>.empty());

      // Act
      await tester.pumpWidget(makeTestableWidget(const VenueListPage()));

      // Assert - Check for loading state components
      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(ShimmerLoadingGrid), findsOneWidget);

      // Verify no other states are showing
      expect(find.byType(ErrorView), findsNothing);
      expect(find.byType(VenueCard), findsNothing);
    });

    testWidgets('shows error view with message when state is VenuesError', (tester) async {
      final errorMessage = ErrorMessages.getErrorMessage('Test error');
      when(mockBloc.state).thenReturn(VenuesError('Test error'));
      when(mockBloc.stream).thenAnswer((_) => Stream<VenueState>.empty());
      await tester.pumpWidget(makeTestableWidget(const VenueListPage()));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('shows no venues found message when VenuesLoaded with empty venues', (tester) async {
      when(mockBloc.state).thenReturn(VenuesLoaded([], [], {}));
      when(mockBloc.stream).thenAnswer((_) => Stream<VenueState>.empty());
      await tester.pumpWidget(makeTestableWidget(const VenueListPage()));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('No venues found matching your criteria'), findsOneWidget);
      expect(find.text('Clear Filters'), findsOneWidget);
    });

    testWidgets('tapping a venue card navigates to VenueDetailsPage', (tester) async {
      // Prepare a venue and state
      final venue = VenueModel(
        id: '1',
        name: 'Test Venue',
        categories: const [],
        city: 'Test City',
        type: 'Test Type',
        location: 'Test Location',
        images: const [],
      );
      final state = VenuesLoaded([venue], [], {});
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream<VenueState>.empty());
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: Get.key,
          home: BlocProvider<VenueBloc>.value(
            value: mockBloc,
            child: const VenueListPage(),
          ),
        ),
      );
      await tester.pump();
      // Tap the venue card
      await tester.tap(find.text('Test Venue'));
      await tester.pumpAndSettle();
      // Should navigate to VenueDetailsPage
      expect(find.byType(VenueDetailsPage), findsOneWidget);
    });

    testWidgets('tapping a filter opens the filter modal', (tester) async {
      final filter = FilterModel(
        name: 'Type',
        type: 'category',
        categories: [FilterCategoryModel(id: '1', name: 'Gym')],
      );
      final state = VenuesLoaded([], [filter], {});
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream<VenueState>.empty());
      await tester.pumpWidget(makeTestableWidget(const VenueListPage()));
      await tester.pump();
      // Tap the filter chip/button (assume filter.name is used as label)
      await tester.tap(find.text('Type'));
      await tester.pumpAndSettle();
      // The modal should show the filter options
      expect(find.text('Select Type'), findsOneWidget);
      expect(find.text('Gym'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('selecting a filter and tapping Apply updates the filter', (tester) async {
      final filter = FilterModel(
        name: 'Type',
        type: 'category',
        categories: [FilterCategoryModel(id: '1', name: 'Gym'), FilterCategoryModel(id: '2', name: 'Hotel')],
      );
      final state = VenuesLoaded([], [filter], {});
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream<VenueState>.empty());
      await tester.pumpWidget(makeTestableWidget(const VenueListPage()));
      await tester.pump();
      // Tap the filter chip/button
      await tester.tap(find.text('Type'));
      await tester.pumpAndSettle();
      // Tap the checkbox for 'Gym'
      await tester.tap(find.text('Gym'));
      await tester.pump();
      // Tap the Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      // Modal should be closed
      expect(find.text('Select Type'), findsNothing);
    });
  });
}
