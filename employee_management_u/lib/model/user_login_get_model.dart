class UserLoginGet {
  String? token;
  String? firstName;
  String? lastName;
  String? email;
  String? id;

  UserLoginGet(
      {this.token, this.firstName, this.lastName, this.email, this.id});

  UserLoginGet.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['Email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['Email'] = email;
    data['id'] = id;
    return data;
  }
}
