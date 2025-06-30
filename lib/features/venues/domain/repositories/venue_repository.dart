import '../entities/venues_and_filters.dart';

abstract class VenueRepository {
  Future<VenuesAndFilters> getVenuesAndFilters();
}
