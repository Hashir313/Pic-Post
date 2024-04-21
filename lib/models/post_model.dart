import 'package:flutter/material.dart';

class PostModel {
  final String userId;
  final String userName;
  final String profileImage;
  final String postId;
  final String createdAt;
  final String? postImage;
  final String? imageCaption;
  final String? postCaption;
  final Color? postColor;

  PostModel({
    required this.userId,
    required this.userName,
    required this.profileImage,
    required this.postId,
    required this.createdAt,
    this.postImage,
    this.imageCaption,
    this.postCaption,
    this.postColor,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'],
      postId: json['postId'],
      postImage: json['postImage'],
      imageCaption: json['imageCaption'],
      postColor: json['postColor'],
      userName: json['userName'],
      profileImage: json['userProfileImage'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['postId'] = postId;
    data['postImage'] = postImage;
    data['imageCaption'] = imageCaption;
    data['postColor'] = postColor;
    data['userName'] = userName;
    data['userProfileImage'] = profileImage;
    data['createdAt'] = createdAt;
    return data;
  }
}
