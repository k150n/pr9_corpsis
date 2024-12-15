import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Подключаем пакет Supabase
import 'package:pr9_corpsis/pages/home_page.dart';
import 'package:pr9_corpsis/pages/favorite_page.dart';
import 'package:pr9_corpsis/pages/profile_page.dart';

void main() async {
  // Инициализация Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  await Supabase.initialize(
    url: 'https://dfpzbdmpwwtpccnuqhxd.supabase.co', // Замените на ваш Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmcHpiZG1wd3d0cGNjbnVxaHhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNjI3NTIsImV4cCI6MjA0OTgzODc1Mn0.jiK7ojqfq2DE_z2qdhslVP7fkFUUCSQftydqQC4X-BM', // Замените на ваш Anon Key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Убираем метку debug
      title: 'My App',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // Настройка темы
      home: HomePage(), // Здесь используется HomePage
    );
  }
}
