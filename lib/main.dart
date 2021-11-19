import 'package:flutter/material.dart';
import 'package:github_mobile_app/ui/pages/home.page.dart';
import 'package:github_mobile_app/ui/pages/users.page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => UsersPage(),
        "/users": (context) => UsersPage(),
      },
      initialRoute: "/",
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: EasyLoading.init(),
    );
  }
}
