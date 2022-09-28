class User {
  int? userId;
  String? name;
  String? email;
  // String password;
  String? phone;
  String? type;
  String? token;
  String? refreshToken;

  User(
      { this.userId,
       this.name,
       this.email,
      // this.password,
       this.phone,
       this.type,
       this.token,
       this.refreshToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      userId: responseData['userId'],
      name: responseData['name'],
      email: responseData['email'],
      // password: responseData['password'],
      phone: responseData['phone'],
      type: responseData['type'],
      token: responseData['token'],
      refreshToken: responseData['refreshToken'],
    );
  }
}
