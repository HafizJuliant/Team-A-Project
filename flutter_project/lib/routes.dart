import 'package:flutter/material.dart';
import 'package:flutter_project/pages/pages.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const WelcomePage(),
    '/login': (context) => LoginPage(),
    '/home': (context) => HomePage(),
    '/editprofile': (context) => EditProfilePage(),
    '/transfer': (context) => TransferSaldoPage(),
    '/mutasi': (context) => MutationPage(),
  };
}
