import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp1/database/users_db.dart';
import 'package:testapp1/pages/home_page.dart';

void main() {
  // setUp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: const HomePage(),
      //   theme: ThemeData.dark(),
      // ),
      child: MultiProvider(
        providers: [
          Provider(
            create: (context) {
              return UserDatabase();
            },
          ),
          StreamProvider<List<UserItem>>(
            create: (context) {
              return context.read<UserDatabase>().listenToData();
            },
            initialData: const [],
          ),
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
            theme: ThemeData.dark(),
          );
        },
      ),
    );
  }
}
