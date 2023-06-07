class ProfileInformation {
  int? id;
  DateTime? createdAt;
  String? profileId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? profilePicture;
  String? email;
  String? username;
  String? profileCover;
  bool? isInitial;
  bool? isOnline;
  DateTime? lastOnline;
  List<String>? favoriteList;

  ProfileInformation({
    this.id,
    this.createdAt,
    this.profileId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.profilePicture,
    this.email,
    this.username,
    this.isInitial,
    this.profileCover,
    this.isOnline,
    this.lastOnline,
    this.favoriteList,
  });

  factory ProfileInformation.fromJson(Map<String, dynamic> json) {
    return ProfileInformation(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      profileId: json['profile_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobile: json['mobile'],
      profilePicture: json['profile_picture'],
      email: json['email'],
      username: json['user_name'],
      isInitial: json['initial_signup'],
      profileCover: json['profile_cover'],
      isOnline: json['is_online'],
      lastOnline: json['last_online'] != null ? DateTime.parse(json['last_online']) : null,
      favoriteList: json['favorite_list'] != null ? List<String>.from(json['favorite_list']) : null,
    );
  }
}
