class UserModel {
  final String userId;
  final String profileImage;
  final String username;
  final String userEmail;
  final String phoneNumber;
  final String country;

  UserModel({
    required this.userId,
    required this.profileImage,
    required this.username,
    required this.userEmail,
    required this.phoneNumber,
    required this.country,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      profileImage: json['profileImage'] ?? '',
      username: json['name'] ?? '',
      userEmail: json['userEmail'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['profileImage'] = profileImage;
    data['username'] = username;
    data['userEmail'] = userEmail;
    data['phoneNumber'] = phoneNumber;
    data['country'] = country;
    return data;
  }

  static fromMap(Map<String, dynamic> data) {}
}
