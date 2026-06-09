class ProductModel {
  final int id;

  final int idCategory;

  final String? categoryName;

  final String name;

  final String description;

  final bool available;

  final int stock;

  ProductModel({
    required this.id,
    required this.idCategory,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.available,
    required this.stock,
  });

  // ================= FROM MAP =================
  factory ProductModel.fromMap(
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: json['id'] ?? 0,

      idCategory:
          json['id_category'] ?? 0,

      categoryName:
          json['category_name'] ??
              "Tidak Ada Category",

      name:
          json['name'] ?? "",

      description:
          json['description'] ?? "",

      available:
          json['available'] ?? false,

      stock:
          json['stock'] ?? 0,
    );
  }

  // ================= TO MAP =================
  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "id_category":
          idCategory,

      "category_name":
          categoryName,

      "name":
          name,

      "description":
          description,

      "available":
          available,

      "stock":
          stock,
    };
  }

  // ================= COPY WITH =================
  ProductModel copyWith({
    int? id,
    int? idCategory,
    String? categoryName,
    String? name,
    String? description,
    bool? available,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,

      idCategory:
          idCategory ??
              this.idCategory,

      categoryName:
          categoryName ??
              this.categoryName,

      name:
          name ?? this.name,

      description:
          description ??
              this.description,

      available:
          available ??
              this.available,

      stock:
          stock ?? this.stock,
    );
  }

  @override
  String toString() {
    return
        'ProductModel(name: $name, id: $id)';
  }
}