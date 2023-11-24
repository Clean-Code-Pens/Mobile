
class ProfileModel {
  int? id;
  String? address;
  String? profile_picture;
  String? job;
  String? no_hp;
  String? gender;

  ProfileModel({
    this.id,
    this.address,
    this.profile_picture,
    this.job,
    this.no_hp,
    this.gender,
  });
}

// class MeetingCreateModel

//   String? name;
//   String? email;
//   String? profileImageUrl;

//   ProfileModel({ this.name,  this.email,  this.profileImageUrl});

//   factory ProfileModel.fromJson(Map<String, dynamic> json) {
//     return ProfileModel(
//       name: json['name'],
//       email: json['email'],
//       profileImageUrl: json['profileImageUrl'],
//     );
//   }
// }

