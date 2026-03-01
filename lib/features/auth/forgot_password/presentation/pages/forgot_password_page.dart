import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/accessibility/semantics_labels.dart';
import 'package:quickbite/features/auth/forgot_password/application/forgot_password_controller.dart';
import 'package:quickbite/shared/ui/atoms/qb_text_field.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/qb_form_error.dart';
import 'package:quickbite/shared/ui/molecules/qb_loading_button.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final controller = ref.read(forgotPasswordControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(AppRoutes.login),
                    icon: const Icon(Symbols.arrow_back_ios_new),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: QBTokens.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Symbols.lock_reset,
                          color: QBTokens.primary,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Don't worry! It happens. Please enter the email address associated with your account to receive a reset link.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    QBTextField(
                      controller: _emailController,
                      hintText: 'name@email.com',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: controller.setEmail,
                      semanticLabel: 'Forgot password email address field',
                      prefixIcon: const Icon(Symbols.mail),
                    ),
                    const SizedBox(height: 14),
                    if (state.errorMessage != null) ...[
                      QBFormError(message: state.errorMessage!),
                      const SizedBox(height: 12),
                    ],
                    QBLoadingButton(
                      label: 'Send Reset Link',
                      semanticLabel: SemanticsLabels.forgotPasswordSubmit,
                      isLoading: state.isSubmitting,
                      onPressed: () async {
                        final success = await controller.submit();
                        if (!context.mounted) {
                          return;
                        }
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Reset link sent successfully (mock).',
                              ),
                            ),
                          );
                          context.go(AppRoutes.otp);
                        }
                      },
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Remembered your password? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () => context.go(AppRoutes.login),
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: QBTokens.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Container(
                      height: 1,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text.rich(
                          TextSpan(
                            text: 'Having trouble? Contact our ',
                            children: const [
                              TextSpan(
                                text: 'Customer Support',
                                style: TextStyle(
                                  color: QBTokens.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: ' for assistance.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Center(
                      child: Container(
                        width: 128,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(999),
                        ),
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
