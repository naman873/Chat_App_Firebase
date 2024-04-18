import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_screen.dart';

class AuthController extends ChangeNotifier {
  bool loader = false;

  Future<void> signUpUser(
    String? email,
    String? pass,
    String? name,
    BuildContext context,
  ) async {
    loader = true;
    notifyListeners();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      debugPrint("enter");
      final credential = await auth.createUserWithEmailAndPassword(
        email: email ?? "",
        password: pass ?? "",
      );
      loader = false;
      notifyListeners();
      user = credential.user;
      await user?.updateDisplayName(name);
      await user?.reload();
      user = auth.currentUser;
      debugPrint(user?.uid);
      debugPrint(user?.email);

      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": user.displayName,
          "img": "",
          "uid": user.uid,
          "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
        });
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      loader = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loginUser(
      String? email, String? pass, BuildContext context) async {
    User? user;
    loader = true;
    notifyListeners();
    try {
      debugPrint("enter $email $pass");

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email ?? "",
        password: pass ?? "",
      )
          .then((credential) async {
        loader = false;
        notifyListeners();
        user = credential.user;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", user?.uid ?? "").then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            ),
          );
        });

        return credential;
      });
    } on FirebaseAuthException catch (e) {
      loader = false;
      notifyListeners();
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        debugPrint('No user found for that email.');
      }
    }
  }

  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("uid");
    await FirebaseAuth.instance.signOut();
  }
}
