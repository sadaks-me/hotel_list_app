import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_list_app/core/error/error_messages.dart';
import 'package:hotel_list_app/features/venues/presentation/pages/venue_details_page.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/venue_card.dart';
import 'package:hotel_list_app/shared/widgets/error_view.dart';
import 'package:hotel_list_app/shared/widgets/shimmer_loading.dart';

import '../bloc/venue_bloc.dart';
import '../bloc/venue_event.dart';
import '../bloc/venue_state.dart';

class VenueListPage extends StatelessWidget {
  const VenueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, VenueState state) {
    if (state is VenuesLoading) {
      return const ShimmerLoadingGrid();
    } else if (state is VenuesLoaded) {
      return Column(
        children: [
          if (state.filters.isNotEmpty) _buildFilterList(state),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.venues.isNotEmpty
                  ? _buildVenuesGrid(state)
                  : ErrorView(
                      message: 'No venues found matching your criteria',
                      actionLabel: 'Clear Filters',
                      onRetry: () =>
                          context.read<VenueBloc>().add(ClearFiltersEvent()),
                    ),
            ),
          ),
        ],
      );
    } else if (state is VenuesError) {
      return ErrorView(
        message: ErrorMessages.getErrorMessage(state.message),
        onRetry: () =>
            context.read<VenueBloc>().add(GetVenuesWithFiltersEvent()),
      );
    }
    return const SizedBox.shrink();
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFE6E6EB),
      scrolledUnderElevation: 0,
      title: SvgPicture.asset(
        'assets/images/svg/logo.svg',
        height: 20,
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
      ),
    );
  }

  Widget _buildVenuesGrid(VenuesLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: 250,
      ),
      itemCount: state.venues.length,
      itemBuilder: (context, index) {
        final venue = state.venues[index];
        return VenueCard(
          venue: venue,
          onTap: () => Get.to(() => VenueDetailsPage(venue: venue)),
        );
      },
    );
  }

  Widget _buildFilterList(VenuesLoaded state) {
    Future<void> showFilterSheet(
      BuildContext context,
      filter,
      Map<String, List<String>> selectedCategoryIdsByFilterName,
    ) async {
      final selected = Set<String>.from(
        selectedCategoryIdsByFilterName[filter.name] ?? [],
      );
      final result = await showModalBottomSheet<List<String>>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 350),
        ),
        builder: (ctx) => _buildFilterSheet(ctx, filter, selected),
      );
      if (result != null && context.mounted) {
        final updated = Map<String, List<String>>.from(
          selectedCategoryIdsByFilterName,
        );
        updated[filter.name] = result;
        context.read<VenueBloc>().add(ApplyFilterEvent(updated));
      }
    }

    return Container(
      color: Color(0xFFE6E6EB),
      height: 54,
      padding: EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: state.filters.length,
        itemBuilder: (context, index) {
          hasFilters(String filterName) =>
              (state.selectedCategoryIdsByFilterName[filterName] ?? []);
          final sortedFilters = state.filters
            ..sort(
              (a, b) => hasFilters(
                b.name,
              ).length.compareTo(hasFilters(a.name).length),
            );
          final filter = sortedFilters[index];
          final selected = hasFilters(filter.name).isNotEmpty;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(
                filter.name,
                style: TextStyle(color: selected ? Colors.white : Colors.black),
              ),
              showCheckmark: false,
              selectedColor: Color(0xFF7788A2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              avatar:
                  (selected &&
                      (state.selectedCategoryIdsByFilterName[filter.name] ?? [])
                          .isNotEmpty)
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                      constraints: BoxConstraints(minWidth: 20, maxHeight: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blueGrey),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${(state.selectedCategoryIdsByFilterName[filter.name] ?? []).length}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : null,
              selected: selected,
              onSelected: (_) => showFilterSheet(
                context,
                filter,
                state.selectedCategoryIdsByFilterName,
              ),
            ),
          );
        },
      ),
    );
  }

  AnimatedPadding _buildFilterSheet(
    BuildContext ctx,
    filter,
    Set<String> selected,
  ) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select ${filter.name}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...filter.categories.map<Widget>((cat) {
                    return CheckboxListTile(
                      dense: true,
                      value: selected.contains(cat.id),
                      title: Text(
                        cat.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selected.add(cat.id);
                          } else {
                            selected.remove(cat.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, selected.toList()),
                    child: const Text('Apply'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
