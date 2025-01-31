import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final bool isClicked;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.isClicked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isClicked ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Filter',
          style: TextStyle(
            color: isClicked ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
