import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pic_post/models/message_model.dart';

class ChatServices extends ChangeNotifier {
  //! get instance of the firestore and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //? Send Messages
  Future<void> sendMessage(String recieverId, String message) async {
    //! get current user info
    final String currentUserId = _auth.currentUser!.uid;
    String currentUserName = ''; // Initialize with an empty string

    User? user = _auth.currentUser;
    if (user != null) {
      // Get the document associated with the user's ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.uid)
          .get();

      // Check if the document exists and contains a 'name' field
      if (userDoc.exists &&
          userDoc.data() is Map<String, dynamic> &&
          (userDoc.data() as Map<String, dynamic>).containsKey('name')) {
        currentUserName =
            (userDoc.data() as Map<String, dynamic>)['name'] as String;
      }
    }

    final Timestamp timestamp = Timestamp.now();

    //? create a new message
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      recieverId: recieverId, // Corrected variable name to receiverId
      message: message,
      senderName: currentUserName,
      timestamp: timestamp,
    );

    //? construct chat room id from current user id and reciever id (sorted to ensure uniqueness)
    List<String> members = [currentUserId, recieverId];
    members.sort();
    String chatRoomId =
        members.join('_'); //*combines the id into a single string

    //? add new message to database
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //* Get Messages
  Stream<QuerySnapshot> getmessages(String userId, String otherUserId) {
    //?construct chat room id from user id and reciever id (sorted to ensure it matches the id used when sending the message)
    List<String> members = [userId, otherUserId];
    members.sort();
    String chatRoomId = members.join('_');

    //? get messages from the database
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

//* Get Last Message With timestamp
  Future<MessageModel?> getLastMessage(
    String userId,
    String otherUserId,
  ) async {
    //?construct chat room id from user id and reciever id (sorted to ensure it matches the id used when sending the message)
    List<String> members = [userId, otherUserId];
    members.sort();
    String chatRoomId = members.join('_');

    //? get messages from the database
    QuerySnapshot querySnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> messageData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return MessageModel.fromMap(messageData);
    } else {
      return null;
    }
  }
}
