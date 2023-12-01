import 'package:flutter/material.dart';

class SectionWithGap extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final double gap;

  const SectionWithGap({
    super.key,
    required this.children,
    this.gap = 20,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      crossAxisAlignment: crossAxisAlignment,
      children: children.expand((widget) => [widget, SizedBox(height: gap,)]).toList()..removeLast(),
    );
  }
}