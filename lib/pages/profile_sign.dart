import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePageSign extends StatefulWidget {
  final String userId;

  ProfilePageSign({required this.userId});

  @override
  _ProfilePageSignState createState() => _ProfilePageSignState();
}

class _ProfilePageSignState extends State<ProfilePageSign> {
  String? fullName = '';  // Применяем nullable тип
  String? phone = '';     // Применяем nullable тип

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Метод для загрузки данных о пользователе
  Future<void> _loadUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('users') // Таблица с данными пользователя
          .select()
          .eq('user_id', widget.userId) // Фильтруем по userId
          .single() // Делаем выборку одного объекта
          .execute(); // Важный метод для выполнения запроса

      // Проверяем успешность запроса
      if (response.status == 200 && response.data != null) {
        setState(() {
          fullName = response.data['full_name'] ?? '';  // Присваиваем значение или пустую строку
          phone = response.data['phone'] ?? '';        // Присваиваем значение или пустую строку
        });
      } else {
        // В случае ошибки выводим сообщение
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при загрузке данных: ${response.status}')),
        );
      }
    } catch (e) {
      // Обработка любых других ошибок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ФИО: ${fullName ?? "Не указано"}', style: TextStyle(fontSize: 18)),
            Text('Телефон: ${phone ?? "Не указано"}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
