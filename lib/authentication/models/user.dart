User loggedInUser = User(username: "Null", password: "Null", fullName: "Null", email: "Null", role: "Null");

class User {
  String username;
  String password;
  String fullName;
  String email;
  String role;

  User(
    {
      required this.username, 
      required this.password, 
      required this.fullName,
      required this.email,
      required this.role,
    }
  );
}
