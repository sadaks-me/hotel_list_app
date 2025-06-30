class FilterCategoryModel {
  final String id;
  final String name;

  FilterCategoryModel({required this.id, required this.name});

  factory FilterCategoryModel.fromJson(Map<String, dynamic> json) {
    return FilterCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class FilterModel {
  final String name;
  final String type;
  final List<FilterCategoryModel> categories;

  FilterModel({required this.name, required this.type, required this.categories});

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      name: json['name'] as String,
      type: json['type'] as String,
      categories: (json['categories'] as List)
          .map((e) => FilterCategoryModel.fromJson(e))
          .toList(),
    );
  }
}

