import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';

import '../../../domain/entities/venues_and_filters.dart';
import '../../models/filter_model.dart';
import '../../models/venue_model.dart';
import '../remote/venue_remote_data_source.dart';

class VenueLocalDataSourceImpl implements VenueDataSource {
  @override
  Future<VenuesAndFilters> getVenuesAndFilters({String? jsonPath}) async {
    if (jsonPath == null) throw CacheException();
    try {
      final venueJsonString = await rootBundle.loadString(jsonPath);
      final venueList = json.decode(venueJsonString)['items'] as List;
      final venues = venueList.map((e) => VenueModel.fromJson(e)).toList();
      final venueFilters = json.decode(venueJsonString)['filters'] as List;
      final allFilters = venueFilters
          .map((e) => FilterModel.fromJson(e))
          .toList();
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
      throw CacheException();
    }
  }
}
