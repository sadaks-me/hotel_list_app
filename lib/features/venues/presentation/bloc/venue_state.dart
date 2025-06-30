import 'package:equatable/equatable.dart';
import '../../data/models/filter_model.dart';
import '../../domain/entities/venue.dart';
abstract class VenueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VenuesInitial extends VenueState {}
class VenuesLoading extends VenueState {}
class VenuesLoaded extends VenueState {
  final List<Venue> venues;
  final List<FilterModel> filters;
  final Map<String, List<String>> selectedCategoryIdsByFilterName;
  VenuesLoaded(this.venues, this.filters, this.selectedCategoryIdsByFilterName);
  @override
  List<Object?> get props => [venues, filters, selectedCategoryIdsByFilterName];
}
class VenuesError extends VenueState {
  final String message;
  VenuesError(this.message);
  @override
  List<Object?> get props => [message];
}
