import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';

import 'authNotifier.dart';

class SavedNotifier with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userID;
  final _saved = <WordPair>{};

  Set<WordPair> get saved => _saved;

  bool contains(WordPair pair) => _saved.contains(pair);

  void update(AuthNotifier auth) {
    if (auth.isAuthenticated) {
      _userID = auth.user!.uid;

      //Create new document if needed and update from offline
      _db.collection('saved').doc(_userID).get().then((doc) async {
        if (!doc.exists)
          await _db.collection('saved').doc(_userID).set({
            "names": FieldValue.arrayUnion([""])
          });
      }).then((_) async {
        DocumentSnapshot document=await _db.collection('saved').doc(_userID).get();
        List<String> names = List<String>.from(document['names']);
        _saved.addAll(names.where((e) => e.isNotEmpty).map((e) => _stringToPair(e)));
        notifyListeners();
      }).whenComplete(() => _saved.forEach((pair) => _addDB(pair)));
    } else if (auth.status == Status.Unauthenticated) {
      _saved.clear();
      _userID = null;
      notifyListeners();
    }
  }

  void add(WordPair pair) {
    _saved.add(pair);
    if (_userID != null) {
      _addDB(pair);
    }
    notifyListeners();
  }

  void _addDB(WordPair pair) {
    _db.collection('saved').doc(_userID).update({
      'names': FieldValue.arrayUnion([pair.asPascalCase])
    });
  }

  void remove(WordPair pair) {
    _saved.remove(pair);
    if (_userID != null) {
      _db.collection('saved').doc(_userID).update({
        'names': FieldValue.arrayRemove([pair.asPascalCase])
      });
    }
    notifyListeners();
  }

  WordPair _stringToPair(String pair) {
    int capital = pair.lastIndexOf(RegExp(r'[A-Z]'));
    String first = pair.substring(0, capital).toLowerCase();
    String second = pair.substring(capital).toLowerCase();
    return WordPair(first, second);
  }
}
