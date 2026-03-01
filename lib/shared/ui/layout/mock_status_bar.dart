import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class MockStatusBar extends StatelessWidget {
  const MockStatusBar({
    super.key,
    this.darkIcons = true,
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 32),
  });

  final bool darkIcons;
  final EdgeInsets horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final color = darkIcons ? Colors.black87 : Colors.white;
    return Padding(
      padding: horizontalPadding.copyWith(top: 16, bottom: 8),
      child: Row(
        children: [
          Text(
            '9:41',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(Symbols.signal_cellular_4_bar, size: 18, color: color),
          const SizedBox(width: 6),
          Icon(Symbols.wifi, size: 18, color: color),
          const SizedBox(width: 6),
          Transform.rotate(
            angle: 1.5708,
            child: Icon(Symbols.battery_full, size: 18, color: color),
          ),
        ],
      ),
    );
  }
}
