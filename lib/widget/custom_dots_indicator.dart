import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/values/colors.dart';

class CustomDotsIndicator extends StatelessWidget {
  final int currentIndex, index;

  const CustomDotsIndicator(
      {super.key, required this.currentIndex, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4,
      width: currentIndex == index ? 60 : 25,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color:
            currentIndex == index ? AppColor.primaryColor : AppColor.osloGray,
      ),
    );
  }
}
