
import '../../domain/entities/venues_and_filters.dart';
import '../../domain/repositories/venue_repository.dart';
import '../datasources/remote/venue_remote_data_source.dart';

class VenueRepositoryImpl implements VenueRepository {
  final VenueDataSource remoteDataSource;
  VenueRepositoryImpl(this.remoteDataSource);

  @override
  Future<VenuesAndFilters> getVenuesAndFilters() async {
    return await remoteDataSource.getVenuesAndFilters();
  }
}
