class AppUser {
  String userId;
  String email;
  String userName;
  String userImage;
  bool admin;
  bool approved;
  bool rejected;

  AppUser({
    required this.userId,
    required this.email,
    required this.userName,
    required this.userImage,
    required this.admin,
    required this.approved,
    required this.rejected,
  });

  AppUser copyWith({
    String? userId,
    String? email,
    String? userName,
    String? userImage,
    bool? admin,
    bool? approved,
    bool? rejected,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      admin: admin ?? this.admin,
      approved: approved ?? this.approved,
      rejected: rejected ?? this.rejected,
    );
  }
}
