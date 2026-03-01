import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/accessibility/semantics_labels.dart';
import 'package:quickbite/core/constants/design_assets.dart';
import 'package:quickbite/features/auth/register/application/register_controller.dart';
import 'package:quickbite/shared/ui/atoms/qb_text_field.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/qb_form_error.dart';
import 'package:quickbite/shared/ui/molecules/qb_google_social_button.dart';
import 'package:quickbite/shared/ui/molecules/qb_loading_button.dart';
import 'package:quickbite/shared/ui/molecules/qb_password_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key, this.useRemoteImages = true});

  final bool useRemoteImages;

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final controller = ref.read(registerControllerProvider.notifier);
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
                    icon: const Icon(Symbols.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Create Account',
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Join FoodPanda',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your details to start ordering delicious food and groceries.',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _FormLabel('Full Name'),
                    const SizedBox(height: 8),
                    QBTextField(
                      controller: _fullNameController,
                      hintText: 'John Doe',
                      onChanged: controller.setFullName,
                    ),
                    const SizedBox(height: 14),
                    const _FormLabel('Email Address'),
                    const SizedBox(height: 8),
                    QBTextField(
                      controller: _emailController,
                      hintText: 'example@mail.com',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: controller.setEmail,
                    ),
                    const SizedBox(height: 14),
                    const _FormLabel('Phone Number'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          height: 56,
                          width: 62,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF8FAFC),
                          ),
                          child: Text(
                            '+1',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: QBTextField(
                            controller: _phoneController,
                            hintText: '555-0123',
                            keyboardType: TextInputType.phone,
                            onChanged: controller.setPhone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _FormLabel('Password'),
                    const SizedBox(height: 8),
                    QBPasswordField(
                      controller: _passwordController,
                      hintText: '********',
                      obscureText: state.obscurePassword,
                      onChanged: controller.setPassword,
                      onToggleVisibility: controller.togglePasswordVisibility,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: state.acceptTerms,
                          onChanged: (value) =>
                              controller.setAcceptTerms(value ?? false),
                          activeColor: QBTokens.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                children: const [
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      color: QBTokens.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy.',
                                    style: TextStyle(
                                      color: QBTokens.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.2,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.errorMessage != null) ...[
                      QBFormError(message: state.errorMessage!),
                      const SizedBox(height: 12),
                    ],
                    QBLoadingButton(
                      label: 'Sign Up',
                      semanticLabel: SemanticsLabels.registerSubmit,
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
                                'Account created successfully (mock).',
                              ),
                            ),
                          );
                          context.go(AppRoutes.otp);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR REGISTER WITH',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const SizedBox(
                      width: double.infinity,
                      child: QBGoogleSocialButton(
                        semanticLabel: 'Register with Google',
                        height: 48,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF475569),
                            fontSize: 14,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () => context.go(AppRoutes.login),
                                child: const Text(
                                  'Log In',
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
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: 0.5,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: SizedBox(
                          height: 96,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Color(0x1AF1277B),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              if (widget.useRemoteImages)
                                CachedNetworkImage(
                                  imageUrl:
                                      DesignAssets.registerDecorativeImage,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const ColoredBox(
                                        color: Color(0xFFFCE7F3),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const ColoredBox(
                                        color: Color(0xFFFCE7F3),
                                      ),
                                )
                              else
                                const ColoredBox(color: Color(0xFFFCE7F3)),
                            ],
                          ),
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

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}
