import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/image_carousel.dart';
import '../../domain/entities/venue.dart';
import '../widgets/activities_section.dart';

class VenueDetailsPage extends StatelessWidget {
  final Venue venue;

  const VenueDetailsPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            stretch: true,
            pinned: true,
            backgroundColor: Color(0xFFE6E6EB),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: ImageCarousel(images: venue.images),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    venue.name.trim(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${venue.location}, ${venue.city}',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          venue.type.capitalizeFirst ?? '',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.blueGrey),
                        ),
                      ),
                      if (venue.specialNotice?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: venue.specialNotice,
                            preferBelow: true,
                            padding: EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                              left: 12,
                              right: 12,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            showDuration: Duration(seconds: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.orange.shade100,
                                width: 1.5,
                              ),
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              color: Colors.orange.shade900,
                              height: 1.5,
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Opening hours:', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(
                    venue.openingHours.isNotEmpty
                        ? venue.openingHours.entries
                              .map((e) => "${e.key}: ${e.value}")
                              .join("\n")
                        : 'Not available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  Text(
                    (venue.overviewText.isNotEmpty &&
                            venue.overviewText.first['text'] != null)
                        ? venue.overviewText.map((e) => e['text']).join("\n\n")
                        : 'No description available.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  Divider(height: 1),
                  ActivitiesSection(thingsToDo: venue.thingsToDo),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
