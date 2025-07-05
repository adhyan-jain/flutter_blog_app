class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profilePicUrl;
  final List<String> followers;
  final List<String> following;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilePicUrl,
    required this.followers,
    required this.following,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'followers': followers,
      'following': following,
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? profilePicUrl,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
