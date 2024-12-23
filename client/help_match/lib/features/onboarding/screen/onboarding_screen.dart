import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/theme/cubit/theme_cubit.dart';
import 'package:help_match/features/onboarding/info/info.dart';
import 'package:help_match/features/onboarding/pages/page_container.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int index = 0;
  bool isLastPage = false;
  final pageCount = 3;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double alignmentY = screenWidth < 600 ? 0.9 : 0.65;
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  color: Theme.of(context).colorScheme.primary,
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().themeChange();
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            pageSnapping: true,
            itemCount: pageCount,
            itemBuilder: (_, i) {
              index = i;
              return PageContainer(
                index: i,
                titles: titles,
                descriptions: descriptions,
                lottieNames: lottieNames,
              );
            },
            onPageChanged: (index) {
              setState(() => isLastPage = index == pageCount - 1);
            },
          ),
          Container(
            alignment: Alignment(0, alignmentY),
            child: isLastPage
                ? GradientButton(
                    text: "Get Started",
                    onPressed: () {},
                  )
                : SmoothPageIndicator(
                    controller: _pageController,
                    count: pageCount,
                    effect: JumpingDotEffect(
                      spacing: 43,
                      verticalOffset: 24,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
