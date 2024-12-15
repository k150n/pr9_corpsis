class Note {
  final int id;
  final String title;
  final String description;
  final String photo_id;
  final double price; // Используем double для цены
  bool isFavorite;

  // Конструктор с параметрами
  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.photo_id,
    required this.price,
    this.isFavorite = false,
  });

  // Фабричный метод для создания объекта из JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['product_id'] ?? 0, // Если 'product_id' == null, присваиваем 0
      title: json['name'] ?? 'Unknown', // Если 'name' == null, присваиваем 'Unknown'
      description: json['description'] ?? '', // Если 'description' == null, присваиваем пустую строку
      price: (json['price'] != null) ? json['price'].toDouble() : 0.0, // Если 'price' == null, присваиваем 0.0
      photo_id: json['image_url'] ?? '', // Если 'imageURL' == null, присваиваем пустую строку
    );
  }
}
