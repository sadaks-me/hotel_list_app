import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/utils/constants.dart';
import 'package:hotel_list_app/features/venues/data/datasources/local/venue_local_data_source.dart';

import '../../../../../core/api/venue_api_service.dart';
import '../../../../../core/api/venue_endpoints.dart';
import '../../../domain/entities/venues_and_filters.dart';
import '../../models/filter_model.dart';
import '../../models/venue_model.dart';

abstract class VenueDataSource {
  Future<VenuesAndFilters> getVenuesAndFilters({String? jsonPath});
}

class VenueRemoteDataSourceImpl implements VenueDataSource {
  final VenueApiService apiService;
  final VenueLocalDataSourceImpl localDataSource;

  VenueRemoteDataSourceImpl({
    required this.apiService,
    required this.localDataSource,
  });

  @override
  Future<VenuesAndFilters> getVenuesAndFilters({String? jsonPath}) async {
    try {
      List<dynamic> hotelsList = [];
      List<dynamic> gymsList = [];
      List<dynamic> hotelsFilters = [];
      List<dynamic> gymsFilters = [];

      try {
        final venues = await apiService.fetchVenues(
          endpoint: VenueEndpoints.hotels,
        );
        hotelsList = venues['items'] ?? [];
        hotelsFilters = venues['filters'] ?? [];
      } catch (_) {
        return localDataSource.getVenuesAndFilters(jsonPath: AppConstants.hotelsJson);
      }

      try {
        final venues = await apiService.fetchVenues(
          endpoint: VenueEndpoints.gyms,
        );
        gymsList = venues['items'] ?? [];
        gymsFilters = venues['filters'] ?? [];
      } catch (e) {
        return localDataSource.getVenuesAndFilters(jsonPath: AppConstants.gymsJson);
      }

      final venues = [
        ...hotelsList.map((e) => VenueModel.fromJson(e)),
        ...gymsList.map((e) => VenueModel.fromJson(e)),
      ];
      final allFilters = [
        ...hotelsFilters.map((e) => FilterModel.fromJson(e)),
        ...gymsFilters.map((e) => FilterModel.fromJson(e)),
      ];
      final Map<String, FilterModel> merged = {};
      for (final filter in allFilters) {
        final key = '${filter.name}_${filter.type}';
        if (merged.containsKey(key)) {
          final existing = merged[key]!;
          final existingIds = existing.categories.map((c) => c.id).toSet();
          final newCategories = [
            ...existing.categories,
            ...filter.categories.where((c) => !existingIds.contains(c.id)),
          ];
          merged[key] = FilterModel(
            name: filter.name,
            type: filter.type,
            categories: newCategories,
          );
        } else {
          merged[key] = filter;
        }
      }
      return VenuesAndFilters(venues: venues, filters: merged.values.toList());
    } catch (_) {
      throw ServerException();
    }
  }
}
