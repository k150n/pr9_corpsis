import 'package:flutter/material.dart';
import 'package:pr9_corpsis/models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  final Function(Note) onUpdate;

  const EditNotePage({
    Key? key,
    required this.note,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _photoController; // Контроллер для URL изображения

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController = TextEditingController(text: widget.note.description);
    _priceController = TextEditingController(text: widget.note.price.toString());
    _photoController = TextEditingController(text: widget.note.photo_id); // Инициализация контроллера
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _photoController.dispose(); // Освобождение ресурсов контроллера URL
    super.dispose();
  }

  void _saveNote() {
    final updatedNote = Note(
      id: widget.note.id,
      title: _titleController.text,
      description: _descriptionController.text,
      photo_id: _photoController.text, // Используем URL из контроллера
      price: double.tryParse(_priceController.text) ?? 0.0,
      isFavorite: widget.note.isFavorite,
    );

    widget.onUpdate(updatedNote); // Вызовем функцию обновления с обновленной заметкой
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать товар'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _photoController, // Поле для URL изображения
              decoration: InputDecoration(labelText: 'URL изображения'),
            ),
            SizedBox(height: 16.0),
            // Отображаем изображение по URL
            if (_photoController.text.isNotEmpty)
              Image.network(
                _photoController.text,
                height: 150,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
