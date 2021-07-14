class UserModel {
  late String name;
  late String email;
  late String imageUrl;
  late String dob;

  UserModel(
      {required this.name,
      required this.email,
      required this.imageUrl,
      required this.dob});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    data['dob'] = this.dob;
    return data;
  }
}
