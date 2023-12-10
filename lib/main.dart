import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literalink/authentication/page/signin_page.dart';

void main() => runApp(const LiteraLink());

class LiteraLink extends StatelessWidget {
  static const Color tealDeep = Colors.teal;
  static const Color limeGreen = Colors.lime;
  static const Color lightKhaki = Color(0xFFF0E68C);
  static const Color offWhite = Color(0xFF018845);

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
