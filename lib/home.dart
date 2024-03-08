import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Favorito'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('Favoritos').listenable(),
        builder: (context, box, child) {
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              final isFavorite = box.get(index) != null;
              
              return ListTile(
                title: Text(word),
                trailing: IconButton(
                  onPressed: () {
                    _toggleFavorite(context, box, index, word, isFavorite);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context, Box box, int index, String word, bool isFavorite) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (isFavorite) {
      await box.delete(index);
      final snackBar = SnackBar(
        content: const Text('Remove Added successfully'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await box.put(index, word);
      final snackBar = SnackBar(
        content: const Text('Added successfully'),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
