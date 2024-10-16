import 'package:card_scanner/core/db/local_storage.dart';
import 'package:card_scanner/features/home/view/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final LoclDatabase loclDatabase;
  const SplashScreen({super.key, required this.loclDatabase});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  loclDatabase: widget.loclDatabase,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/scanner.png'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Card Scanner',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
