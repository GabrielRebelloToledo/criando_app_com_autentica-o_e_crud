import 'package:auth_crud/models/auth.dart';
import 'package:auth_crud/provider/pessoas.dart';

import 'package:auth_crud/views/auth_or_home_page.dart';
import 'package:auth_crud/views/cadastro.dart';

import 'package:auth_crud/views/home.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'models/auth.dart';
import 'routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /*  const MyApp({Key? key}) : super(key: key); */

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        //Logica para autenticação mudança de ChangeNotifierProvider para ChangeNotifierProxyProvider
        //Colocando em estrutura gravitacional
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (context) => ProductList(),
          //Logica para autenticação
          update: (ctx, auth, previous) {
            return ProductList(
                auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],);
          },
        ),
      ],
      child: MaterialApp(
          title: 'Autenticação com CRUD',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            Routes.home: (_) => Home(),
            Routes.authOrHome: (_) => AuthOrHomePage(),
            Routes.cadastro: (_) => ProductFormPage()
          }),
    );
  }
}
