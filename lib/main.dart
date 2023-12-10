import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literalink/authentication/page/signin_page.dart';

void main() {
  runApp(LiteraLink());
}

class LiteraLink extends StatelessWidget {
  static const Color tealDeep = Colors.teal;
  static const Color limeGreen = Colors.lime;
  static const Color lightKhaki = Color(0xFFF0E68C);
  static const Color offWhite = Color(0xFFFFFFDD);

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) {
          CookieRequest request = CookieRequest();
          return request;
        },
        child: MaterialApp(
          title: 'Literalink',
          theme: ThemeData(
            textTheme: const TextTheme(
                bodyMedium: TextStyle(
                    color: LiteraLink.tealDeep, fontFamily: "Satoshi")),
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
                .copyWith(background: LiteraLink.offWhite),
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: SignInPage(),
        ));
  }
}
