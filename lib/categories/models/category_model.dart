class CategoryModel {
  final int id;
  final String name;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0, // 🔥 FIX NULL SAFETY
      name: json['name'] ?? '', // 🔥 FIX NULL SAFETY
      description: json['description'] ?? '', // 🔥 FIX NULL SAFETY
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
    };
  }

  // ================= TAMBAHAN DEBUG BIAR TIDAK "Instance of ..." =================
  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description)';
  }

  // ================= OPTIONAL: biar gampang compare di Bloc =================
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}