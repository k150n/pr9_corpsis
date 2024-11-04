import 'package:flutter/material.dart';
import 'package:pr9_corpsis/models/api_service.dart';
import 'package:pr9_corpsis/components/item_note.dart';
import 'package:pr9_corpsis/components/note_card.dart';
import 'package:pr9_corpsis/models/note.dart';
import 'package:pr9_corpsis/models/cart_item.dart';
import 'note_page.dart';
import 'create_note_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import 'basket.dart';
import 'edit_note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Note> notes = [];
  List<Note> favorites = [];
  List<CartItem> cart = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      List<Note> products = await apiService.getProducts();
      setState(() {
        notes = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки товаров: $e')),
      );
    }
  }

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _editNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          note: note,
          onUpdate: (updatedNote) {
            setState(() {
              int index = notes.indexWhere((n) => n.id == updatedNote.id);
              if (index != -1) {
                notes[index] = updatedNote;
              }
            });
          },
        ),
      ),
    );
  }

  void _addToCart(Note note) {
    setState(() {
      cart.add(CartItem(note: note));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${note.title} добавлен в корзину')),
    );
  }

  void _openNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotePage(
          note: note,
          onUpdate: (updatedNote) {
            setState(() {
              int index = notes.indexWhere((n) => n.id == updatedNote.id);
              if (index != -1) {
                notes[index] = updatedNote; // Обновляем заметку
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteNote(int id) {
    setState(() {
      notes.removeWhere((note) => note.id == id);
    });
  }


  void _toggleFavorite(Note note) {
    setState(() {
      if (favorites.contains(note)) {
        favorites.remove(note);
        note.isFavorite = false;
      } else {
        favorites.add(note);
        note.isFavorite = true;
      }
    });
  }

  void _removeFromFavorites(Note note) {
    setState(() {
      favorites.remove(note);
      note.isFavorite = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _getCurrentPage() {
      switch (_selectedIndex) {
        case 0:
          return _buildNoteList();
        case 1:
          return FavoritePage(
            favorites: favorites,
            onOpenNote: _openNote,
            onRemoveFromFavorites: _removeFromFavorites,
            onAddToCart: _addToCart,
          );
        case 2:
          return ProfilePage();
        default:
          return _buildNoteList();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hollyhood'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateNotePage(onCreate: _addNote),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранные',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildNoteList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: (note) => _openNote(note), // Исправлено: передаем note в _openNote
          onToggleFavorite: (note) {
            _toggleFavorite(note);
          },
          onAddToCart: (note) => _addToCart(note),
        );
      },
    );
  }

}
