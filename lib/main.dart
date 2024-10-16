import 'package:card_scanner/core/db/local_storage.dart';
import 'package:card_scanner/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoclDatabase loclDatabase = LoclDatabase();
  await loclDatabase.initDatabase();
  runApp(MyApp(
    loclDatabase: loclDatabase,
  ));
}

class MyApp extends StatelessWidget {
  final LoclDatabase loclDatabase;
  const MyApp({super.key, required this.loclDatabase});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Scanner',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        loclDatabase: loclDatabase,
      ),
    );
  }
}
