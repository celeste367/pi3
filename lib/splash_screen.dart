import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 5));
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/48459dc8-c0a3-4c14-99fd-6fee1777f4ed/QFesrhW7Jc.json',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 5),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: Icon(Icons.home),
              label: Text('Ir para Início'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.lightBlue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
