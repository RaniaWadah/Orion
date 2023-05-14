class UserData{
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;

  UserData({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
  });

  UserData.fromJson(Map<dynamic, dynamic> json){
    firstName = json['First Name'];
    lastName = json['Last Name'];
    email = json['Email'];
    username = json['Username'];
    password = json['Password'];
  }
}