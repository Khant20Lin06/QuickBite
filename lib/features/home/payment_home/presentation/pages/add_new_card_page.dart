import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class AddNewCardPage extends StatelessWidget {
  const AddNewCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(AppRoutes.homePayments),
                    icon: const Icon(Symbols.arrow_back_ios),
                  ),
                  const Expanded(
                    child: Text(
                      'Add New Card',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardPreview(isDark: isDark),
                    const SizedBox(height: 22),
                    const _FieldLabel('Cardholder Name'),
                    const SizedBox(height: 8),
                    const _StyledTextField(hintText: 'John Doe'),
                    const SizedBox(height: 16),
                    const _FieldLabel('Card Number'),
                    const SizedBox(height: 8),
                    const _StyledTextField(
                      hintText: '0000 0000 0000 0000',
                      suffixIcon: Symbols.credit_card,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(
                          child: _FieldGroup(
                            label: 'Expiry Date',
                            hintText: 'MM/YY',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FieldGroup(
                            label: 'CVV',
                            hintText: '•••',
                            obscureText: true,
                            labelIcon: Symbols.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TrustBadge(
                          icon: Symbols.verified_user,
                          text: 'SECURE',
                        ),
                        SizedBox(width: 14),
                        _TrustBadge(icon: Symbols.shield, text: 'PCI DSS'),
                        SizedBox(width: 14),
                        _TrustBadge(icon: Symbols.lock, text: 'ENCRYPTED'),
                      ],
                    ),
                    const SizedBox(height: 26),
                    FilledButton(
                      key: const Key('add-card-save-button'),
                      onPressed: () => context.go(AppRoutes.homePayments),
                      style: FilledButton.styleFrom(
                        backgroundColor: QBTokens.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Card',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'By adding this card, you agree to our Terms of Service. Your payment info is stored securely.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  const _CardPreview({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [QBTokens.primary, Color(0xFFFF4D97), Color(0xFFD11A64)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              SizedBox(
                width: 48,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xCCFACC15),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              Spacer(),
              Icon(Symbols.contactless, color: Colors.white, size: 34),
            ],
          ),
          Spacer(),
          Text(
            '•••• •••• •••• ••••',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'FULL NAME',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'MM/YY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.labelIcon,
  });

  final String label;
  final String hintText;
  final bool obscureText;
  final IconData? labelIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _FieldLabel(label),
            if (labelIcon != null) ...[
              const SizedBox(width: 4),
              Icon(labelIcon, size: 14, color: const Color(0xFF94A3B8)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _StyledTextField(hintText: hintText, obscureText: obscureText),
      ],
    );
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.hintText,
    this.suffixIcon,
    this.obscureText = false,
  });

  final String hintText;
  final IconData? suffixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: isDark ? const Color(0x1AF1277B) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0x33F1277B) : const Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0x33F1277B) : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: QBTokens.primary, width: 1.4),
        ),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: const Color(0xFF94A3B8))
            : null,
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
