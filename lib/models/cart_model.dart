class CartItem {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      imageUrl: imageUrl,
      title: title,
      description: description,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
