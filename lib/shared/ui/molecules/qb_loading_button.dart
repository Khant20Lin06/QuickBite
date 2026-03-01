import 'package:flutter/material.dart';
import 'package:quickbite/shared/ui/atoms/qb_button.dart';

class QBLoadingButton extends StatelessWidget {
  const QBLoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.semanticLabel,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? semanticLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return QBButton(
      label: label,
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      isLoading: isLoading,
      height: height,
    );
  }
}
