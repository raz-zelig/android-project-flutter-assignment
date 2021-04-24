import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hello_me/savedNotifier.dart';
import 'package:provider/provider.dart';

class Saved extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: Consumer<SavedNotifier>(builder: (context, savedNotifier, _) {
        final Set<WordPair> saved = savedNotifier.saved;
        return ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                saved.elementAt(index).asPascalCase,
                style: _biggerFont,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  savedNotifier.remove(saved.elementAt(index));
                },
              ),
            );
          },
          separatorBuilder: (context, _) => Divider(),
          itemCount: saved.length,
        );
      }),
    );
  }
}
