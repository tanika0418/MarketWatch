import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/Constants.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  User? _user;

  User? get user => _user;

  AuthProvider(this.firebaseAuth);

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = await userCredential.user;
      bool _sessionClear = await _isSessionClear(user!.uid);
      if (!_sessionClear) {
        throw Exception(SYSTEM_ERROR + "You already logged on another device");
      }
      _user = user;
      _updateSession(true);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> tryAutoLogin() async {
    User? firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
    }
    if (firebaseUser != null) {
      bool _sessionClear = await _isSessionClear(firebaseUser.uid);
      if (_sessionClear) {
        _user = firebaseUser;
        _updateSession(true);
        notifyListeners();
      }
    }
  }

  Future<void> _updateSession(bool status) async {
    final _sessionsDBRef = FirebaseDatabase.instance.ref().child("sessions");
    await _sessionsDBRef.child(_user!.uid).set(status);
  }

  Future<bool> _isSessionClear(String uid) async {
    bool _status = false;
    final _sessionsDBRef = FirebaseDatabase.instance.ref().child("sessions");
    await _sessionsDBRef.child(uid).once().then((value) async {
      _status = !(value.snapshot.value as bool);
    });
    return _status;
  }

  Future<void> logout() async {
    await _updateSession(false);
    await firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }
}
