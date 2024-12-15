import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://dfpzbdmpwwtpccnuqhxd.supabase.co', // Замените на ваш URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmcHpiZG1wd3d0cGNjbnVxaHhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNjI3NTIsImV4cCI6MjA0OTgzODc1Mn0.jiK7ojqfq2DE_z2qdhslVP7fkFUUCSQftydqQC4X-BM', // Замените на ваш анонимный ключ
  );
}
