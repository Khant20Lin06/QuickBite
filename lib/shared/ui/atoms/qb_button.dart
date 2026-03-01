import 'package:flutter/material.dart';
import 'package:quickbite/app/tokens.dart';

enum QBButtonVariant { primary, secondary, text }

class QBButton extends StatelessWidget {
  const QBButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = QBButtonVariant.primary,
    this.height = 56,
    this.semanticLabel,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final QBButtonVariant variant;
  final double height;
  final String? semanticLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: AnimatedSwitcher(
          duration: QBTokens.buttonAnimDuration,
          child: isLoading
              ? const Center(
                  key: Key('qb_loading_indicator'),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Text(label, key: const Key('qb_button_label')),
        ),
      ),
    );

    switch (variant) {
      case QBButtonVariant.primary:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: child,
        );
      case QBButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: child,
        );
      case QBButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
    }
  }
}
