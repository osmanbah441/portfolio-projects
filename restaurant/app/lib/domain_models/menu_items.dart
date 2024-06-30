enum MenuItemCategory {
  mainCourses('Main Courses'),
  fastFood('Fast Food'),
  appetizers('Appetizers'),
  dessert('Desserts'),
  drinks('Drinks');

  final String name;
  const MenuItemCategory(this.name);
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.title,
    required double price,
    required this.description,
    this.imageUrl = 'assets/images/image.jpeg',
  }) : _price = price;

  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double _price;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price']),
      description: json['description'],
      imageUrl: json['image_url']);

  String get price => 'SLL ${_price.toStringAsFixed(2)}';
}
