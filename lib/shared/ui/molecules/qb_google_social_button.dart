import 'package:flutter/material.dart';
import 'package:quickbite/shared/ui/atoms/qb_google_icon.dart';

class QBGoogleSocialButton extends StatelessWidget {
  const QBGoogleSocialButton({
    super.key,
    required this.semanticLabel,
    this.onTap,
    this.height = 56,
  });

  final String semanticLabel;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            color: Colors.transparent,
          ),
          alignment: Alignment.center,
          child: const QBGoogleIcon(size: 24),
        ),
      ),
    );
  }
}
