import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pic_post/models/post_model.dart';
import 'package:pic_post/models/user_model.dart';
import 'package:pic_post/screens/auth/login_screen.dart';
import 'package:pic_post/screens/bottom_bar/bottom_bar.dart';
import 'package:pic_post/utils/flutter_toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//! This function is used to sign up the user
Future<UserCredential?> signupUser(
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  try {
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      return userCredential;
    } else {
      ToastMessage().flutterToast('Please fill all the fields');
      return null;
    }
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
  }
  return null;
}

//! This function is used to upload the profile image of user to firebase storage
Future<String> uploadUserProfileImage(File image) async {
  try {
    //* Upload the image to firebase storage
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('userProfile')
        .child(fileName);
    await ref.putFile(image);
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
    return '';
  }
}

//! This function is used to upload the user post image to firebase image store
Future<String> uploadUserPostImage(File image) async {
  try {
    //* Upload the image to firebase storage
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('userPosts')
        .child(fileName);
    await ref.putFile(image);
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
    return '';
  }
}

//! This function is used to upload the user data to firestore
Future<void> uploadUserData(
  UserModel userModel,
  BuildContext context,
) async {
  try {
    String uid = userModel.userId;
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .set({
          'userId': uid,
          'profileImage': userModel.profileImage,
          'name': userModel.username,
          'email': userModel.userEmail,
          'phone_number': userModel.phoneNumber,
          'country': userModel.country,
        })
        .then((value) => {
              ToastMessage().flutterToast('Logged in successfully'),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => const BottomNavBar()),
                ),
              ),
            })
        .onError((error, stackTrace) => {
              ToastMessage().flutterToast(error.toString()),
            });
    ToastMessage().flutterToast(
      'Signed up successfully',
    );
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
  }
}

//!This function is used to upload the post data to the firestore
Future<void> uploadPostData(
  PostModel postModel,
) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String pstId = postModel.postId;
    await FirebaseFirestore.instance.collection('userPosts').doc(pstId).set({
      'postId': pstId,
      'userId': uid,
      'postImage': postModel.postImage,
      'caption': postModel.imageCaption,
      'postCaption': postModel.postCaption,
      'postColor': postModel.postColor.toString(),
      'userName': postModel.userName,
      'userProfileImage': postModel.profileImage,
      'createdAt': postModel.createdAt,
    });
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
  }
}

//! This function is used to sign in the user
Future<void> signinUser(
  TextEditingController emailController,
  TextEditingController passwordController,
  BuildContext context,
) async {
  try {
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => {
                ToastMessage().flutterToast('Logged in successfully'),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const BottomNavBar()),
                  ),
                ),
              })
          .onError((error, stackTrace) => {
                ToastMessage().flutterToast(error.toString()),
              });
    } else {
      ToastMessage().flutterToast('Please fill all the fields');
    }
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
  }
}

//! This function is used to reset the password of the user
Future<void> resetPassword(
  TextEditingController emailController,
  BuildContext context,
) async {
  try {
    if (emailController.text.isNotEmpty) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: emailController.text,
          )
          .then((value) => {
                ToastMessage().flutterToast(
                  'Password reset link has been sent to your email',
                ),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LoginScreen()),
                  ),
                ),
              })
          .onError(
            (error, stackTrace) => {
              ToastMessage().flutterToast(error.toString()),
            },
          );
    } else {
      ToastMessage().flutterToast('Please enter your email');
    }
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
  }
}

//? this function is used to fetch the user data from firebase firestore
Future<DocumentSnapshot> getUserInfo() async {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  return await FirebaseFirestore.instance
      .collection("userData")
      .doc(firebaseUser!.uid)
      .get();
}

//? This function is used to fetch the all users post from firebase firestore
Future<QuerySnapshot> getAllUserPosts() async {
  return await FirebaseFirestore.instance.collection('userPosts').get();
}

//! This function is used to signout the user
Future<void> signOutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut().then((value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => const LoginScreen()),
            ),
          ),
        });
  } catch (e) {
    ToastMessage().flutterToast(e.toString());
  }
}
