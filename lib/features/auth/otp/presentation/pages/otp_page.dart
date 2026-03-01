import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/accessibility/semantics_labels.dart';
import 'package:quickbite/features/auth/otp/application/otp_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/qb_form_error.dart';
import 'package:quickbite/shared/ui/molecules/qb_loading_button.dart';

class OtpPage extends ConsumerWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpControllerProvider);
    final controller = ref.read(otpControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextIndex = state.code.length.clamp(0, 3);

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.go(AppRoutes.login),
                  icon: const Icon(Symbols.arrow_back_ios),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verify your number',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We've sent a 4-digit code to your phone \n+1 234 **** 789",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(4, (index) {
                        final digit = state.digits[index];
                        final isActive =
                            state.code.length == index ||
                            (index == 3 && state.code.length == 4);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _OtpDigitBox(
                            digit: digit,
                            isActive: isActive || index == nextIndex,
                            isDark: isDark,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: controller.resendCode,
                                child: const Text(
                                  'Resend code',
                                  style: TextStyle(
                                    color: QBTokens.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                '|  ${_formatTimer(state.secondsRemaining)}',
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF475569),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (state.errorMessage != null) ...[
                      QBFormError(message: state.errorMessage!),
                      const SizedBox(height: 12),
                    ],
                    QBLoadingButton(
                      label: 'Verify & Proceed',
                      semanticLabel: SemanticsLabels.otpSubmit,
                      isLoading: state.isSubmitting,
                      onPressed: () async {
                        final success = await controller.submit();
                        if (!context.mounted) {
                          return;
                        }
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verification successful (mock).'),
                            ),
                          );
                          context.go(AppRoutes.homeFood);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            _OtpKeypad(
              isDark: isDark,
              onDigit: controller.appendDigit,
              onBackspace: controller.backspace,
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.digit,
    required this.isActive,
    required this.isDark,
  });

  final String digit;
  final bool isActive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? QBTokens.primary
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          width: 2,
        ),
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
      ),
      alignment: Alignment.center,
      child: Text(
        digit.isEmpty ? '.' : digit,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: digit.isEmpty
              ? (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))
              : null,
        ),
      ),
    );
  }
}

class _OtpKeypad extends StatelessWidget {
  const _OtpKeypad({
    required this.isDark,
    required this.onDigit,
    required this.onBackspace,
  });

  final bool isDark;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x800F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.85,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 1; i <= 9; i++)
                _KeypadKey(
                  label: '$i',
                  isDark: isDark,
                  onTap: () => onDigit('$i'),
                ),
              _KeypadKey(
                icon: Symbols.fingerprint,
                isDark: isDark,
                onTap: () {},
              ),
              _KeypadKey(label: '0', isDark: isDark, onTap: () => onDigit('0')),
              _KeypadKey(
                icon: Symbols.backspace,
                iconColor: QBTokens.primary,
                isDark: isDark,
                onTap: onBackspace,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 128,
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeypadKey extends StatelessWidget {
  const _KeypadKey({
    this.label,
    this.icon,
    required this.isDark,
    required this.onTap,
    this.iconColor,
  });

  final String? label;
  final IconData? icon;
  final bool isDark;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: icon != null
              ? Icon(
                  icon,
                  color:
                      iconColor ??
                      (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF94A3B8)),
                )
              : Text(
                  label ?? '',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

String _formatTimer(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final remaining = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$remaining';
}
