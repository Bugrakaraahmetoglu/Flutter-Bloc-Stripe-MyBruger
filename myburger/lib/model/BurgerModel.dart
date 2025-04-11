class BurgerModel {
  final int? id;
  final String? name;
  final String? shop;
  final String? category;
  final String? imageUrl;
  final String? deliveryTime;
  final double? rating;
  final double? price;
  final String? description;
  final int quantity;

  BurgerModel({
    this.id,
    this.name,
    this.shop,
    this.category,
    this.imageUrl,
    this.deliveryTime,
    this.rating,
    this.price,
    this.description,
    this.quantity = 1,  // Default to 1
  });

  // Add copyWith method for state management
  BurgerModel copyWith({
    int? id,
    String? name,
    String? shop,
    String? category,
    String? imageUrl,
    String? deliveryTime,
    double? rating,
    double? price,
    String? description,
    int? quantity,
  }) {
    return BurgerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shop: shop ?? this.shop,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  factory BurgerModel.fromJson(Map<String, dynamic> json) {
    return BurgerModel(
      id: json["id"] as int?,
      name: json["name"] as String?,
      shop: json["shop"] as String?,
      category: json["category"] as String?,
      imageUrl: json["imageUrl"] as String?,
      deliveryTime: json["deliveryTime"] as String?,
      rating: (json["rating"] as num?)?.toDouble(),
      price: (json["price"] as num?)?.toDouble(),
      description: json["description"] as String?,
      quantity: json["quantity"] as int? ?? 1,  // Default to 1 if null
    );
  }

  static List<BurgerModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((item) => BurgerModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "shop": shop,
      "category": category,
      "imageUrl": imageUrl,
      "deliveryTime": deliveryTime,
      "rating": rating,
      "price": price,
      "description": description,
      "quantity": quantity,
    };
  }

  // Optional: Override toString for debugging
  @override
  String toString() {
    return 'BurgerModel(id: $id, name: $name, quantity: $quantity)';
  }
}