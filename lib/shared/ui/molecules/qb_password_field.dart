import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/core/accessibility/semantics_labels.dart';
import 'package:quickbite/shared/ui/atoms/qb_text_field.dart';

class QBPasswordField extends StatelessWidget {
  const QBPasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.onChanged,
    this.hintText = 'Enter your password',
  });

  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return QBTextField(
      controller: controller,
      hintText: hintText,
      obscureText: obscureText,
      onChanged: onChanged,
      semanticLabel: SemanticsLabels.loginPasswordField,
      prefixIcon: const Icon(Symbols.lock, size: 20),
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          obscureText ? Symbols.visibility : Symbols.visibility_off,
          size: 20,
        ),
      ),
    );
  }
}
