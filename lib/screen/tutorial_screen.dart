import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:productive_app/config/images.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class TutorialScreen extends StatelessWidget {
  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
      );

  DotsDecorator getDotDecorator(BuildContext ctx) => DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        color: Theme.of(ctx).primaryColorLight,
        activeColor: Theme.of(ctx).primaryColor,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        showSkipButton: true,
        dotsDecorator: this.getDotDecorator(context),
        done: Text(
          'Finish',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onDone: () async {
          await Provider.of<AuthProvider>(context, listen: false).changeFirstLoginStatus();
        },
        skip: Text(
          'Skip',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onSkip: () async {
          await Provider.of<AuthProvider>(context, listen: false).changeFirstLoginStatus();
        },
        next: Icon(Icons.arrow_forward_outlined),
        pages: [
          PageViewModel(
            title: 'Page 1 Title',
            body: 'Page 1 body',
            image: Center(
              child: Image.asset(
                Images.tutorialPlaceholder,
              ),
            ),
            decoration: this.getPageDecoration(),
          ),
          PageViewModel(
            title: 'Page 2 Title',
            body: 'Page 2 body',
            image: Center(
              child: Image.asset(
                Images.tutorialPlaceholder,
              ),
            ),
            decoration: this.getPageDecoration(),
          ),
          PageViewModel(
            title: 'Page 3 Title',
            body: 'Page 3 body',
            image: Center(
              child: Image.asset(
                Images.tutorialPlaceholder,
              ),
            ),
            decoration: this.getPageDecoration(),
          ),
          PageViewModel(
            title: 'Page 4 Title',
            body: 'Page 4 body',
            image: Center(
              child: Image.asset(
                Images.tutorialPlaceholder,
              ),
            ),
            decoration: this.getPageDecoration(),
          ),
        ],
      ),
    );
  }
}
