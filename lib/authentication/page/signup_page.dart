// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:literalink/main.dart';
import 'package:literalink/authentication/page/signin_page.dart';
import 'package:literalink/authentication/components/auth_field.dart';

void main() {
  runApp(const SignUpApp());
}

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _isLoading = false;

  final List<String> roleItems = ['Member', 'Admin'];
  String? selectedRole;

  final _formKey = GlobalKey<FormState>();
  final _roleFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5ED),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset("assets/images/signup_header.png"),
              Column(
                children: [
                  const SizedBox(height: 70),
                  _buildSignUpForm(),
                  _buildSignUpFooter(context),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 14.0),
            authField(_fullNameController, "Full Name", _formKey),
            authField(_usernameController, "Username", _formKey),
            authField(_emailController, "Email", _formKey),
            roleDropdownBtn(),
            const SizedBox(height: 14.0),
            authField(_password1Controller, "Password1", _formKey),
            authField(_password2Controller, "Password2", _formKey,
                otherController: _password1Controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const SizedBox(width: 5),
        Image.asset("assets/images/logo_baru.png"),
        const SizedBox(width: 18),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 250,
              child: Align(
                child: Text(
                  "Enter your details to create your account and get started",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpFooter(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Column(
      children: [
        signUpBtn(request),
        const SizedBox(height: 15),
        _buildSignInLink(context),
      ],
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          ),
          child: const Text(
            'Sign In Now',
            style: TextStyle(color: Color(0xFF35C2C1)),
          ),
        ),
      ],
    );
  }

  Widget signUpBtn(request) {
    return InkWell(
        onTap: () async {
          if (_isLoading) return;

          setState(() {
            _isLoading = true;
          });

          bool mainFormIsValid = _formKey.currentState?.validate() ?? false;
          bool roleFormIsValid = _roleFormKey.currentState?.validate() ?? false;

          if (mainFormIsValid && roleFormIsValid) {
            final response = await request.login(
                "https://literalink-e03-tk.pbp.cs.ui.ac.id/auth/signup-flutter/",
                {
                  'full_name': _fullNameController.text,
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'role': selectedRole,
                  'password1': _password1Controller.text,
                  'password2': _password2Controller.text,
                  'submit': 'Daftar'
                });

            if (request.loggedIn) {
              setState(() {
                _isLoading = false;
              });
              Future.delayed(
                  const Duration(seconds: 1),
                  () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      ));
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    backgroundColor: LiteraLink.redOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    behavior: SnackBarBehavior.floating,
                    // ignore: prefer_const_constructors
                    content: Text("Berhasil membuat akun.")));
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
            _roleFormKey.currentState!.reset();
          } else {
            setState(() {
              _isLoading = false; // Stop loading jika form tidak valid
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFEB6645)),
          height: 50,
          width: 200,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFFEB6645)),
                      height: 50,
                      width: 150,
                      child: const Align(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    const Row(
                      children: [
                        SizedBox(width: 12),
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

  Widget roleDropdownBtn() {
    return Form(
      key: _roleFormKey,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: const InputDecoration(
          fillColor: Color(0xFFF7F8F9),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDADADA))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LiteraLink.darkGreen)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
        ),
        hint: const Text(
          'Select your Role',
          style: TextStyle(
              fontSize: 16, fontFamily: 'Satoshi', color: Color(0xFF8391A1)),
        ),
        items: roleItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        color: Color(0xFF8391A1)),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select role.';
          }
          return null;
        },
        onChanged: (value) {
          selectedRole = value.toString() == 'Member' ? 'M' : 'A';
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: LiteraLink.redOrange,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F9),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
