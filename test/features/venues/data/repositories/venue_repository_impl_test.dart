import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/venues/data/datasources/remote/venue_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_model.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_model.dart';
import 'package:hotel_list_app/features/venues/data/repositories/venue_repository_impl.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venues_and_filters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'venue_repository_impl_test.mocks.dart';

@GenerateMocks([VenueDataSource])
void main() {
  late VenueRepositoryImpl repository;
  late MockVenueDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockVenueDataSource();
    repository = VenueRepositoryImpl(mockDataSource);
  });

  group('VenueRepositoryImpl', () {
    final venuesAndFilters = VenuesAndFilters(venues: [], filters: []);

    test('returns venues and filters from remote data source', () async {
      when(
        mockDataSource.getVenuesAndFilters(),
      ).thenAnswer((_) async => venuesAndFilters);
      final result = await repository.getVenuesAndFilters();
      expect(result, venuesAndFilters);
      verify(mockDataSource.getVenuesAndFilters()).called(1);
    });

    test('returns non-empty venues and filters from remote data source', () async {
      final venuesAndFilters = VenuesAndFilters(
        venues: [VenueModel(id: '1', name: 'Venue 1', categories: [], city: 'City', type: 'Hotel', location: 'Dubai', images: [])],
        filters: [FilterModel(name: 'Type', type: 'category', categories: [])],
      );
      when(mockDataSource.getVenuesAndFilters())
          .thenAnswer((_) async => venuesAndFilters);
      final result = await repository.getVenuesAndFilters();
      expect(result.venues.length, 1);
      expect(result.filters.length, 1);
      expect(result.venues.first.name, 'Venue 1');
      expect(result.filters.first.name, 'Type');
      verify(mockDataSource.getVenuesAndFilters()).called(1);
    });

    test('throws when remote data source throws', () async {
      when(mockDataSource.getVenuesAndFilters()).thenThrow(Exception('error'));
      expect(() => repository.getVenuesAndFilters(), throwsA(isA<Exception>()));
      verify(mockDataSource.getVenuesAndFilters()).called(1);
    });

    test('returns empty lists from remote data source', () async {
      final venuesAndFilters = VenuesAndFilters(venues: [], filters: []);
      when(mockDataSource.getVenuesAndFilters())
          .thenAnswer((_) async => venuesAndFilters);
      final result = await repository.getVenuesAndFilters();
      expect(result.venues, isEmpty);
      expect(result.filters, isEmpty);
      verify(mockDataSource.getVenuesAndFilters()).called(1);
    });

    test('throws different exception types from remote data source', () async {
      when(mockDataSource.getVenuesAndFilters())
          .thenThrow(FormatException('bad format'));
      expect(
        () => repository.getVenuesAndFilters(),
        throwsA(isA<FormatException>()),
      );
      verify(mockDataSource.getVenuesAndFilters()).called(1);
    });
  });
}
