import 'package:flutter/material.dart';

class OnBoardingButton extends StatefulWidget {
  const OnBoardingButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<OnBoardingButton> createState() => _OnBoardingButtonState();
}

class _OnBoardingButtonState extends State<OnBoardingButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.primary,
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 13,
                      offset: const Offset(0, 0),
                    )
                  ]
                : [],
          ),
          height: 40,
          width: 200,
          alignment: Alignment.center,
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
