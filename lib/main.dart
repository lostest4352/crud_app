import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp1/database/users_db.dart';
import 'package:testapp1/pages/home_page.dart';

void main() {
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

GetIt getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton<UserDatabase>(UserDatabase());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData.dark(),
      ),
      // child: MultiProvider(
      //   providers: [],
      //   builder: (context, child) {
      //     return MaterialApp(
      //       debugShowCheckedModeBanner: false,
      //       home: const HomePage(),
      //       theme: ThemeData.dark(),
      //     );
      //   },
      // ),
    );
  }
}
