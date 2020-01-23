// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromMap(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toMap());

class UserProfile {
  Profile profile;

  UserProfile({
    this.profile,
  });

  factory UserProfile.fromMap(Map<String, dynamic> json) => new UserProfile(
        profile:
            json["profile"] == null ? null : Profile.fromMap(json["profile"]),
      );

  Map<String, dynamic> toMap() => {
        "profile": profile == null ? null : profile.toMap(),
      };
}

class Profile {
  String id;
  String birthDay;
  int phone;
  String password;
  String email;
  int v;
  String gender;
  String status;
  DateTime resetPasswordExpires;
  Name name;

  Profile({
    this.id,
    this.birthDay,
    this.phone,
    this.password,
    this.email,
    this.v,
    this.gender,
    this.status,
    this.resetPasswordExpires,
    this.name,
  });

  factory Profile.fromMap(Map<String, dynamic> json) => new Profile(
        id: json["_id"] == null ? null : json["_id"],
        birthDay: json["birth_day"] == null ? null : json["birth_day"],
        phone: json["phone"] == null ? null : json["phone"],
        password: json["password"] == null ? null : json["password"],
        email: json["email"] == null ? null : json["email"],
        v: json["__v"] == null ? null : json["__v"],
        gender: json["gender"] == null ? null : json["gender"],
        status: json["status"] == null ? null : json["status"],
        resetPasswordExpires: json["reset_password_expires"] == null
            ? null
            : DateTime.parse(json["reset_password_expires"]),
        name: json["name"] == null ? null : Name.fromMap(json["name"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "birth_day": birthDay == null ? null : birthDay,
        "phone": phone == null ? null : phone,
        "password": password == null ? null : password,
        "email": email == null ? null : email,
        "__v": v == null ? null : v,
        "gender": gender == null ? null : gender,
        "status": status == null ? null : status,
        "reset_password_expires": resetPasswordExpires == null
            ? null
            : resetPasswordExpires.toIso8601String(),
        "name": name == null ? null : name.toMap(),
      };
}

class Name {
  String last;
  String first;

  Name({
    this.last,
    this.first,
  });

  factory Name.fromMap(Map<String, dynamic> json) => new Name(
        last: json["last"] == null ? null : json["last"],
        first: json["first"] == null ? null : json["first"],
      );

  Map<String, dynamic> toMap() => {
        "last": last == null ? null : last,
        "first": first == null ? null : first,
      };
}
