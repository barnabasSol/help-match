import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageContainer extends StatelessWidget {
  final int index;
  final List<String> lottieNames;
  final List<String> titles;
  final List<String> descriptions;

  const PageContainer({
    super.key,
    required this.index,
    required this.titles,
    required this.descriptions,
    required this.lottieNames,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Lottie.asset(
            height: 300,
            'assets/animations/${lottieNames[index]}.json',
            repeat: true,
            fit: BoxFit.cover,
          ),
          Text(
            textAlign: TextAlign.center,
            titles[index],
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            child: Text(
              descriptions[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}
