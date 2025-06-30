import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_model.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_category_model.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_model.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venues_and_filters.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/venue_repository.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venue_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venue_event.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venue_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'venue_bloc_test.mocks.dart';

@GenerateMocks([VenueRepository])
void main() {
  late VenueBloc venueBloc;
  late MockVenueRepository mockRepository;

  setUp(() {
    mockRepository = MockVenueRepository();
    venueBloc = VenueBloc(mockRepository);
  });

  tearDown(() {
    venueBloc.close();
  });

  group('VenueBloc', () {
    final venues = <Venue>[];
    final filters = <FilterModel>[];
    final venuesAndFilters = VenuesAndFilters(venues: venues, filters: filters);

    blocTest<VenueBloc, VenueState>(
      'emits [VenuesLoading, VenuesLoaded] when GetVenuesWithFiltersEvent succeeds',
      build: () {
        when(
          mockRepository.getVenuesAndFilters(),
        ).thenAnswer((_) async => venuesAndFilters);
        return venueBloc;
      },
      act: (bloc) => bloc.add(GetVenuesWithFiltersEvent()),
      expect: () => [VenuesLoading(), VenuesLoaded(venues, filters, {})],
    );

    blocTest<VenueBloc, VenueState>(
      'emits [VenuesLoading, VenuesError] when GetVenuesWithFiltersEvent fails',
      build: () {
        when(
          mockRepository.getVenuesAndFilters(),
        ).thenThrow(Exception('error'));
        return venueBloc;
      },
      act: (bloc) => bloc.add(GetVenuesWithFiltersEvent()),
      expect: () => [VenuesLoading(), isA<VenuesError>()],
    );

    blocTest<VenueBloc, VenueState>(
      'emits [VenuesLoading, VenuesLoaded] when ApplyFilterEvent is added with selected filters',
      build: () {
        when(
          mockRepository.getVenuesAndFilters(),
        ).thenAnswer((_) async => venuesAndFilters);
        return venueBloc;
      },
      seed: () {
        // Simulate state after venues and filters are loaded
        return VenuesLoaded(venues, filters, {});
      },
      act: (bloc) {
        bloc.add(
          ApplyFilterEvent({
            'Type': ['1'],
          }),
        );
      },
      expect: () => [VenuesLoading(), isA<VenuesLoaded>()],
    );

    blocTest<VenueBloc, VenueState>(
      'emits filtered venues when ApplyFilterEvent is added with actual venues and categories',
      build: () {
        final venue1 = VenueModel(
          id: '1',
          name: 'Venue 1',
          categories: [VenueCategoryModel(id: '1', category: 'Gym')],
          city: 'City',
          type: 'Hotel',
          location: 'Dubai',
          images: [],
        );
        final venue2 = VenueModel(
          id: '2',
          name: 'Venue 2',
          categories: [VenueCategoryModel(id: '2', category: 'Hotel')],
          city: 'City',
          type: 'Hotel',
          location: 'Dubai',
          images: [],
        );
        final filter = FilterModel(
          name: 'Type',
          type: 'category',
          categories: [
            FilterCategoryModel(id: '1', name: 'Gym'),
            FilterCategoryModel(id: '2', name: 'Hotel'),
          ],
        );
        when(mockRepository.getVenuesAndFilters()).thenAnswer(
          (_) async => VenuesAndFilters(venues: [venue1, venue2], filters: [filter]),
        );
        return venueBloc;
      },
      act: (bloc) async {
        bloc.add(GetVenuesWithFiltersEvent());
        await Future.delayed(Duration.zero);
        bloc.add(ApplyFilterEvent({'Type': ['1']}));
      },
      expect: () => [
        VenuesLoading(),
        isA<VenuesLoaded>(),
        VenuesLoading(),
        predicate<VenuesLoaded>((state) =>
          state.venues.length == 1 &&
          state.venues.first.id == '1' &&
          state.selectedCategoryIdsByFilterName['Type']!.contains('1')
        ),
      ],
    );
  });
}
