class ProfileModel {
  String? name;
  String? email;
  String? profileImageUrl;

  ProfileModel({ this.name,  this.email,  this.profileImageUrl});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}