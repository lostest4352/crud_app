import 'package:flutter/material.dart';
import 'package:testapp1/database/drift_service.dart';
import 'package:testapp1/pages/home_page.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

GetIt getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton<DriftService>(DriftService());
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
