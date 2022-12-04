import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  Future<void> authinticate(email, password, bool isLogin, [username]) async {
    await Firebase.initializeApp();

    final auth = FirebaseAuth.instance;
    try {
      if (!isLogin) {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      }
    } catch (e) {
      throw e;
    }
  }
}
