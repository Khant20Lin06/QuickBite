import 'package:flutter/material.dart';
import 'package:quickbite/app/tokens.dart';

class QBPageIndicatorDot extends StatelessWidget {
  const QBPageIndicatorDot({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 32 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: active
            ? QBTokens.primary
            : QBTokens.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
