import 'package:equatable/equatable.dart';

class VenueCategory extends Equatable {
  final String id;
  final String category;
  final String? title;
  final List<Map<String, dynamic>>? detail;
  final bool? showOnVenuePage;

  const VenueCategory({
    required this.id,
    required this.category,
    this.title,
    this.detail,
    this.showOnVenuePage,
  });

  @override
  List<Object?> get props => [id, category, title, detail, showOnVenuePage];
}
