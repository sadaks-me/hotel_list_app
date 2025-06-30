import '../../domain/entities/venue.dart';
import 'venue_category_model.dart';

class VenueModel extends Venue {
  const VenueModel({
    required super.id,
    required super.name,
    required super.city,
    required super.type,
    required super.location,
    required super.images,
    required super.categories,
    super.thingsToDo,
    super.openingHours,
    super.accessibleForGuestPass,
    super.specialNotice,
    super.overviewText,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] ?? json['name'],
      name: json['name'],
      city: json['city'],
      type: json['type'],
      location: json['location'],
      images: (json['images'] as List)
          .map((e) => ImageWithBlurHash(
                url: e['url'] as String,
                blurHash: e['blur_hash'] as String?,
              ))
          .toList(),
      categories: (json['categories'] as List?)
          ?.map((e) => VenueCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      thingsToDo:
          (json['thingsToDo'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      openingHours: Map<String, dynamic>.from(json['openingHours'] ?? {}),
      accessibleForGuestPass: json['accessibleForGuestPass'] ?? false,
      specialNotice: json['specialNotice'],
      overviewText:
          (json['overviewText'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }
}
