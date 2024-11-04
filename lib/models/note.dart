class Note {
  final int id;
  final String title;
  final String description;
  final String photo_id;
  final double price; // Измените тип на double
  bool isFavorite;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.photo_id,
    required this.price,
    this.isFavorite = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['ID'],
      title: json['Name'],
      description: json['Description'],
      price: json['Price'].toDouble(),
      photo_id: json['ImageURL'], // Предполагаем, что API возвращает это поле
    );
  }
}

