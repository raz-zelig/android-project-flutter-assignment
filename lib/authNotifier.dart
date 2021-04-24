import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthNotifier with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Uninitialized;
  String _avatarUrl = "";

  Status get status => _status;

  User? get user => _user;

  String get email => user!.email.toString();

  bool get isAuthenticated => status == Status.Authenticated;

  String get avatarUrl => _avatarUrl;

  set avatarPicture(io.File picture) {
    if (_status != Status.Authenticated) return;
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child(user!.uid)
        .putFile(picture)
        .then((_) => _getAvatarURL())
        .whenComplete(() => notifyListeners());
  }

  AuthNotifier.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    _avatarUrl = "";
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      await _getAvatarURL();
    }
    notifyListeners();
  }

  Future<void> _getAvatarURL() async {
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    try {
      _avatarUrl = await storage.ref().child(user!.uid).getDownloadURL();
    } catch (e) {
      _avatarUrl = "";
    }
  }
}
