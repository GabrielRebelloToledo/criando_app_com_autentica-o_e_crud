import 'package:auth_crud/models/auth.dart';
import 'package:auth_crud/views/auth_page.dart';
import 'package:auth_crud/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? const Home() : AuthPage();
  }
}
