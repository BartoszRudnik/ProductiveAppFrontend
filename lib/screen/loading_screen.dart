import 'package:flutter/material.dart';
import '../widget/animated_image.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedImage(),
            SizedBox(height: 50),
            Center(
              child: Text('Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
