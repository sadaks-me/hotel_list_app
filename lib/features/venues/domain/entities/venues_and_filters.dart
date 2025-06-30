import 'package:hotel_list_app/features/venues/domain/entities/venue.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_model.dart';

class VenuesAndFilters {
  final List<Venue> venues;
  final List<FilterModel> filters;

  VenuesAndFilters({required this.venues, required this.filters});
}

