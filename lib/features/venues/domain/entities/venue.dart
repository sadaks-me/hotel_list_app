import 'package:equatable/equatable.dart';
import 'venue_category.dart';

class ImageWithBlurHash extends Equatable {
  final String url;
  final String? blurHash;

  const ImageWithBlurHash({required this.url, this.blurHash});

  @override
  List<Object?> get props => [url, blurHash];
}

class Venue extends Equatable {
  final String id;
  final String name;
  final String city;
  final String type;
  final String location;
  final List<ImageWithBlurHash> images;
  final List<VenueCategory> categories;
  final List<Map<String, dynamic>> thingsToDo;
  final Map<String, dynamic> openingHours;
  final bool accessibleForGuestPass;
  final String? specialNotice;
  final List<Map<String, dynamic>> overviewText;

  const Venue({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.location,
    required this.images,
    required this.categories,
    this.thingsToDo = const [],
    this.openingHours = const {},
    this.accessibleForGuestPass = false,
    this.specialNotice,
    this.overviewText = const [],
  });

  @override
  List<Object?> get props => [id, name, city, type, location, images, categories, thingsToDo, openingHours, accessibleForGuestPass, specialNotice, overviewText];
}
