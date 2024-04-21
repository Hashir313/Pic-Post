import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //! For accessing the Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static User get user => auth.currentUser!;

  //! For checking if the user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('userData')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }
}
