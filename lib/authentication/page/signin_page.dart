// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:literalink/homepage/components/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/authentication/page/signup_page.dart';
import 'package:literalink/authentication/components/auth_field.dart';

void main() {
  runApp(const SiginInApp());
}

class SiginInApp extends StatelessWidget {
  const SiginInApp({super.key});

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
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5ED),
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
          _buildFooterImages()
        ],
      ),
    );
  }

  Widget _buildHeaderImages() {
    return Stack(
      children: [
        Image.asset("assets/images/header_signin.png"),
      ],
    );
  }
  Widget _buildFooterImages() {
    return Stack(
      children: [
        Image.asset("assets/images/signin_aset.png"),
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
            Image.asset("assets/images/logo_baru.png"),
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
            color: Colors.black,
          ),
        ),
        Text(
          "Sign In with your username or email",
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
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
        const Text("Don't have an account? ", style: TextStyle(color: Colors.black),),
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
            final response = await request.login(
              "https://literalink-e03-tk.pbp.cs.ui.ac.id/auth/signin-flutter/",
              {
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
                MaterialPageRoute(
                    builder: (context) => PersistentBottomNavPage()),
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
              color: const Color(0xFFEB6645)),
          height: 50,
          width: 200,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xFFEB6645)),
                  height: 50,
                  width: 150,
                  child: const Align(
                      child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ))),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
