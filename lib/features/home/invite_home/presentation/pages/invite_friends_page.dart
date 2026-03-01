import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/invite_home/application/invite_friends_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class InviteFriendsPage extends ConsumerWidget {
  const InviteFriendsPage({super.key, this.useRemoteImages = true});

  final bool useRemoteImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(inviteFriendsOverviewProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeProfile)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: double.infinity,
                              height: 250,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  useRemoteImages
                                      ? CachedNetworkImage(
                                          imageUrl: overview.heroImageUrl,
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
                                      : const ColoredBox(
                                          color: Color(0xFFFCE7F3),
                                        ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          (isDark
                                                  ? const Color(0xFF221017)
                                                  : const Color(0xFFF8F6F7))
                                              .withValues(alpha: 0.82),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: Column(
                            children: [
                              Text(
                                overview.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                overview.subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 15,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0x33F1277B),
                                width: 1.8,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'YOUR UNIQUE CODE',
                                  style: TextStyle(
                                    color: QBTokens.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overview.referralCode,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.8,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        key: const Key(
                                          'invite-copy-code-button',
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: overview.referralCode,
                                            ),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Referral code copied.',
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Symbols.content_copy,
                                          color: QBTokens.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Share via',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _ShareRow(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: QBTokens.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Share Invite Link',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'How it works',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 14),
                              for (
                                var i = 0;
                                i < overview.steps.length;
                                i++
                              ) ...[
                                _StepTile(step: overview.steps[i]),
                                if (i != overview.steps.length - 1)
                                  const SizedBox(height: 14),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _RewardsBottomBar(
                  onHomeTap: () => context.go(AppRoutes.homeFood),
                  onOrdersTap: () => context.go(AppRoutes.homeOrders),
                  onProfileTap: () => context.go(AppRoutes.homeProfile),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load invite page: $error')),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x1AF1277B),
              borderRadius: BorderRadius.circular(999),
            ),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Symbols.arrow_back_ios_new,
                color: QBTokens.primary,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Invite Friends',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow();

  @override
  Widget build(BuildContext context) {
    const items = <({IconData icon, String label, Color color})>[
      (icon: Symbols.chat, label: 'Messenger', color: Color(0xFF0084FF)),
      (icon: Symbols.call, label: 'WhatsApp', color: Color(0xFF25D366)),
      (icon: Symbols.send, label: 'Telegram', color: Color(0xFF0088CC)),
      (icon: Symbols.more_horiz, label: 'More', color: Color(0xFF64748B)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step});

  final InviteStepModel step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: QBTokens.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${step.stepNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                step.subtitle,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardsBottomBar extends StatelessWidget {
  const _RewardsBottomBar({
    required this.onHomeTap,
    required this.onOrdersTap,
    required this.onProfileTap,
  });

  final VoidCallback onHomeTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2211017) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Row(
        children: [
          _NavItem(label: 'Home', icon: Symbols.home, onTap: onHomeTap),
          _NavItem(
            label: 'Orders',
            icon: Symbols.receipt_long,
            onTap: onOrdersTap,
          ),
          const _NavItem(
            label: 'Rewards',
            icon: Symbols.card_giftcard,
            active: true,
          ),
          _NavItem(label: 'Profile', icon: Symbols.person, onTap: onProfileTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.active = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? QBTokens.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, fill: active ? 1 : 0, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
