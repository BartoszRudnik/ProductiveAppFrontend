import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialScreen extends StatefulWidget {
  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final controller = CarouselController();
  int _activeImageIndex = 0;

  void animateToImage(int index) => this.controller.jumpToPage(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CarouselSlider.builder(
                carouselController: this.controller,
                itemCount: 5,
                itemBuilder: (ctx, index, realIndex) {
                  Color color;

                  if (index == 0) {
                    color = Colors.red;
                  } else if (index == 1) {
                    color = Colors.green;
                  } else if (index == 2) {
                    color = Colors.blue;
                  } else if (index == 3) {
                    color = Colors.yellow;
                  } else {
                    color = Colors.pink;
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    color: color,
                  );
                },
                options: CarouselOptions(
                  initialPage: 0,
                  height: MediaQuery.of(context).size.height * 0.75,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      this._activeImageIndex = index;
                    });
                  },
                ),
              ),
              AnimatedSmoothIndicator(
                activeIndex: this._activeImageIndex,
                count: 5,
                onDotClicked: (index) {
                  this.animateToImage(index);
                },
                effect: JumpingDotEffect(
                  dotColor: Theme.of(context).primaryColorLight,
                  activeDotColor: Theme.of(context).primaryColor,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Provider.of<AuthProvider>(context, listen: false).changeFirstLoginStatus();
                },
                child: Text('Skip tutorial'),
                style: ColorThemes.loginButtonStyle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
