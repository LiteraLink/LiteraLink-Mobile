// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:literalink/main.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/authentication/page/signup_page.dart';
import 'package:literalink/authentication/components/auth_field.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sign In',
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeaderImages(),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                _buildSignInForm(),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImages() {
    return Stack(
      children: [
        Image.asset("assets/images/Ellipse_48.png"),
        Positioned(
          right: 0,
          child: Image.asset("assets/images/Ellipse_47.png"),
        ),
      ],
    );
  }

  Widget _buildSignInForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Image.asset("assets/images/App_Logo.png"),
            _buildSignInText(),
            const SizedBox(height: 30.0),
            authField(_usernameController, "Username", _formKey),
            authField(_passwordController, "Password", _formKey),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInText() {
    return const Column(
      children: [
        Text(
          "Sign In",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: LiteraLink.tealDeep,
          ),
        ),
        Text(
          "Sign In with your username or email",
          style: TextStyle(
            fontSize: 17,
            color: LiteraLink.tealDeep,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Column(
      children: [
        signInBtn(request),
        const SizedBox(height: 15),
        _buildSignUpLink(context),
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          ),
          child: const Text(
            'Sign Up Now',
            style: TextStyle(color: Color(0xFF35C2C1)),
          ),
        ),
      ],
    );
  }

  Widget signInBtn(request) {
    return InkWell(
      onTap: () async {
        String password = _passwordController.text;
        if (_formKey.currentState!.validate()) {
          final response = await request
              .login("http://127.0.0.1:8000/auth/signin-flutter/", {
            'username': _usernameController.text,
            'password': password,
          });

            if (request.loggedIn) {
              String message = response['message'];
              loggedInUser = User(
                  username: response["username"],
                  password: password,
                  fullName: response["full_name"],
                  email: response["email"],
                  role: response["role"]);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(
                        "$message Selamat datang, ${loggedInUser.username}.")));
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Login Gagal'),
                  content: Text(response['message']),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
            _formKey.currentState!.reset();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: LiteraLink.tealDeep),
          height: 50,
          width: 200,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: LiteraLink.limeGreen),
                  height: 50,
                  width: 150,
                  child: const Align(
                      child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: LiteraLink.tealDeep,
                        fontWeight: FontWeight.bold),
                  ))),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: LiteraLink.limeGreen,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
