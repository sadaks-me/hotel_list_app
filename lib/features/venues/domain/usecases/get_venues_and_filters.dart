import 'package:hotel_list_app/features/venues/domain/entities/venues_and_filters.dart';

import '../repositories/venue_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetVenuesAndFilters implements UseCase<VenuesAndFilters, NoParams> {
  final VenueRepository repository;
  GetVenuesAndFilters(this.repository);

  @override
  Future<VenuesAndFilters> call(NoParams params) async {
    return await repository.getVenuesAndFilters();
  }
}
