class Auth {
  int id;
  String name;
  String email;
  String password;
  String avatar;
  String token;

  toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'email': email.toString(),
      'password': password.toString(),
      'avatar': avatar.toString(),
    };
  }
}

class Registration{
  String name;
  String email;
  String password;
  toJson(){
    return {
      'name':name.toString(),
      'email':email.toString(),
      'password':password.toString(),
    };
  }
}