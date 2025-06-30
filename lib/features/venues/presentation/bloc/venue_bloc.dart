import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/filter_model.dart';
import '../../domain/entities/venue.dart';
import '../../domain/repositories/venue_repository.dart';
import 'venue_event.dart';
import 'venue_state.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final VenueRepository repository;

  List<Venue> _allVenues = [];
  List<FilterModel> _filters = [];
  Map<String, List<String>> _selectedCategoryIdsByFilterName = {};

  VenueBloc(this.repository) : super(VenuesInitial()) {
    on<GetVenuesWithFiltersEvent>((event, emit) async {
      emit(VenuesLoading());
      try {
        final result = await repository.getVenuesAndFilters();
        _allVenues = result.venues;
        _filters = result.filters;
        _selectedCategoryIdsByFilterName = {};
        emit(
          VenuesLoaded(_allVenues, _filters, _selectedCategoryIdsByFilterName),
        );
      } catch (e) {
        emit(VenuesError('Failed to load venues : \\${e.toString()}'));
      }
    });

    on<ApplyFilterEvent>((event, emit) async {
      emit(VenuesLoading());
      try {
        _selectedCategoryIdsByFilterName = Map<String, List<String>>.from(
          event.selectedCategoryIdsByFilterName,
        );
        final filteredVenues = _filterVenues(
          _allVenues,
          _selectedCategoryIdsByFilterName,
        );
        emit(
          VenuesLoaded(
            filteredVenues,
            _filters,
            _selectedCategoryIdsByFilterName,
          ),
        );
      } catch (e) {
        emit(VenuesError('Failed to filter venues : \\${e.toString()}'));
      }
    });

    on<ClearFiltersEvent>((event, emit) async {
      emit(VenuesLoading());
      try {
        _selectedCategoryIdsByFilterName = {};
        final filteredVenues = _filterVenues(
          _allVenues,
          _selectedCategoryIdsByFilterName,
        );
        emit(
          VenuesLoaded(
            filteredVenues,
            _filters,
            _selectedCategoryIdsByFilterName,
          ),
        );
      } catch (e) {
        emit(VenuesError('Failed to clear filters : \\${e.toString()}'));
      }
    });
  }

  List<Venue> _filterVenues(
    List<Venue> venues,
    Map<String, List<String>> selectedCategoryIdsByFilterName,
  ) {
    if (selectedCategoryIdsByFilterName.isEmpty) return venues;
    return venues.where((venue) {
      bool matches = true;
      selectedCategoryIdsByFilterName.forEach((filterName, selectedIds) {
        if (selectedIds.isEmpty) return;
        // For all filters, check if any of the selected category ids are present in venue.categories
        matches &= venue.categories.any((cat) => selectedIds.contains(cat.id));
      });
      return matches;
    }).toList();
  }
}
