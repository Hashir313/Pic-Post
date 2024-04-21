import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String message;
  final String senderName;
  final Timestamp timestamp;

  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.message,
    required this.senderName,
    required this.timestamp,
  });

  //!convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'message': message,
      'senderName': senderName,
      'timestamp': timestamp,
    };
  }

  //! convert from map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      message: map['message'] as String,
      senderName: map['senderName'] as String,
      timestamp:
          map['timestamp'] as Timestamp, // Ensure proper casting to Timestamp
    );
  }
}
