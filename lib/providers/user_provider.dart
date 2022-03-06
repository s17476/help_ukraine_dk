import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/models/app_user.dart';

// this class provides user data and DB operations methods
class UserProvider with ChangeNotifier {
  AppUser? _user;
  var _isLoading = false;
  var _hasData = false;
  final _firebaseAuth = FirebaseAuth.instance;

  //returns a copy of current user object
  AppUser? get user => _user;

  //returns data loading status
  bool get isLoading => _isLoading;

  bool get hasData => _hasData;

  void clear() {
    _user = null;
  }

  // initializes user data
  Future<AppUser?> initializeUser(
    BuildContext context,
    String userId,
  ) async {
    _isLoading = true;
    _user = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      AppUser? tmpUser;
      final userSnapshot = documentSnapshot.data() as Map<String, dynamic>;
      tmpUser = AppUser(
        userId: documentSnapshot.id,
        email: userSnapshot['email'],
        userName: userSnapshot['userName'],
        userImage: userSnapshot['imgUrl'],
        admin: userSnapshot['admin'],
        approved: userSnapshot['approved'],
      );

      _isLoading = false;
      _hasData = true;
      return tmpUser;
    });
    notifyListeners();
    return _user;
  }

  // gets user by id
  Future<AppUser?> getUserById(
    BuildContext context,
    String userId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      AppUser? tmpUser;
      if (documentSnapshot.exists) {
        final userSnapshot = documentSnapshot.data() as Map<String, dynamic>;

        tmpUser = AppUser(
          userId: documentSnapshot.id,
          email: userSnapshot['email'],
          userName: userSnapshot['userName'],
          userImage: userSnapshot['imgUrl'],
          admin: userSnapshot['admin'],
          approved: userSnapshot['approved'],
        );
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: const Text('Unable get user data. Try again later...'),
            backgroundColor: Theme.of(context).errorColor,
          ));
      }
      return tmpUser;
    });
  }

  // updates user data in DB
  Future<void> updateUser(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.userId)
        .set({
      'userName': _user!.userName,
      'email': _user!.email,
      'imgUrl': _user!.userImage,
      'admin': _user!.admin,
      'approved': _user!.approved,
    });
    notifyListeners();
  }

  //signup and signin method
  void submitAuthForm(
    String email,
    String userName,
    String password,
    File? userImage,
    bool admin,
    bool isLogin,
    BuildContext context,
  ) async {
    UserCredential userCredential;
    String errorMessage;
    try {
      _isLoading = true;
      notifyListeners();
      if (isLogin) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await initializeUser(context, userCredential.user!.uid);

        _isLoading = false;
        notifyListeners();
      } else {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // adds user image to cloud storage
        final imgRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(userCredential.user!.uid + '.jpg');
        await imgRef.putFile(userImage!);

        final imgUrl = await imgRef.getDownloadURL();

        // adds user data to DB
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userName': userName,
          'email': email,
          'imgUrl': imgUrl,
          'admin': admin,
          'approved': false,
        });

        _user = AppUser(
          userId: userCredential.user!.uid,
          email: email,
          userName: userName,
          // password: password,
          userImage: imgUrl,
          admin: admin,
          approved: false,
        );

        _isLoading = false;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = e.message.toString();
      }
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  // signout method
  void signout() {
    FirebaseAuth.instance.signOut();
    _user = null;
    _isLoading = false;
    _hasData = false;
    notifyListeners();
  }

  // listens to user authentification status
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
