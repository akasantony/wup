class User {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  int id;

  String name;
  String email;
  String username;
  String gender;
  String phoneNo;
  String profilePicPath;
  String password;
  String country;
  int dateOfBirth;

  User({
    this.name,
    this.email,
    this.username,
    this.gender,
    this.phoneNo,
    this.password,
    this.dateOfBirth,
    this.profilePicPath,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'gender': gender,
      'phoneNo': phoneNo,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'profilePicPath': profilePicPath,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      username: map['username'],
      gender: map['gender'],
      phoneNo: map['phoneNo'],
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
      country: map['country'],
      profilePicPath: map['profilePicPath'],
    );
  }
}