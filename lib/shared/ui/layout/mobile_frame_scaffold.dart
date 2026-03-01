import 'package:flutter/material.dart';
import 'package:quickbite/app/tokens.dart';

class MobileFrameScaffold extends StatelessWidget {
  const MobileFrameScaffold({super.key, required this.child, this.frameColor});

  final Widget child;
  final Color? frameColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: QBTokens.maxPhoneWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: frameColor ?? Theme.of(context).scaffoldBackgroundColor,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
