import 'package:equatable/equatable.dart';

abstract class VenueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetVenuesWithFiltersEvent extends VenueEvent {}
class ClearFiltersEvent extends VenueEvent {}

class ApplyFilterEvent extends VenueEvent {
  final Map<String, List<String>> selectedCategoryIdsByFilterName;
  ApplyFilterEvent(this.selectedCategoryIdsByFilterName);

  @override
  List<Object?> get props => [selectedCategoryIdsByFilterName];
}

