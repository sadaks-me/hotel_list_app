import '../../domain/entities/venue_category.dart';

class VenueCategoryModel extends VenueCategory {
  const VenueCategoryModel({
    required String id,
    required String category,
    String? title,
    List<Map<String, dynamic>>? detail,
    bool? showOnVenuePage,
  }) : super(
          id: id,
          category: category,
          title: title,
          detail: detail,
          showOnVenuePage: showOnVenuePage,
        );

  factory VenueCategoryModel.fromJson(Map<String, dynamic> json) {
    return VenueCategoryModel(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String?,
      detail: (json['detail'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList(),
      showOnVenuePage: json['showOnVenuePage'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        if (title != null) 'title': title,
        if (detail != null) 'detail': detail,
        if (showOnVenuePage != null) 'showOnVenuePage': showOnVenuePage,
      };
}
