import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_sign.dart';  // Импортируем страницу профиля

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Метод для регистрации пользователя
  Future<void> _register() async {
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      // Регистрируем пользователя через Supabase
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // Проверка на успешную регистрацию
      if (response.user != null) {
        final userId = response.user!.id;

        // Добавляем дополнительные данные о пользователе в таблицу "users"
        final userResponse = await Supabase.instance.client.from('users').insert([{
          'user_id': userId,
          'full_name': fullName,
          'phone': phone
        }]);

        if (userResponse.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Регистрация успешна!')),
          );
          // Переходим на страницу профиля
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePageSign(userId: userId)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при добавлении данных: ${userResponse.error?.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось создать пользователя')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  // Метод для входа пользователя
  Future<void> _login() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;
        // Переходим на страницу профиля
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePageSign(userId: userId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка входа: Проверьте данные')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация / Вход'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Форма регистрации
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'ФИО'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Телефон'),
            ),
            TextField(
              controller: _registerEmailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _registerPasswordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Зарегистрироваться'),
            ),
            SizedBox(height: 20),

            // Панель для входа
            Text('Уже есть аккаунт? Войдите:'),
            TextField(
              controller: _loginEmailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _loginPasswordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
