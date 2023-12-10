import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literalink/authentication/page/signin_page.dart';

void main() => runApp(const LiteraLink());

class LiteraLink extends StatelessWidget {
  static const Color lightGreen = Color(0xFF008B3D);
  static const Color darkGreen = Color(0xFF00613A);
  static const Color redOrange = Color(0xFFFE5B37);
  static const Color whiteGreen = Color(0xFFEEF5ED);
  static const Color pinkish = Color(0xFFEF7A5D);
  static const Color lightPink = Color(0xFFFFE4DE);

  const LiteraLink({super.key});

  @override
  Widget build(BuildContext context) {
    CookieRequest request = CookieRequest();
    return Provider(
      create: (_) {
        return request;
      },
      child: MaterialApp(
        title: 'Literalink',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: LiteraLink.tealDeep,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700
            )
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          scaffoldBackgroundColor: const Color(0xFF008845),
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const SignInPage()
      )
    );
  }
}
