import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/accessibility/semantics_labels.dart';
import 'package:quickbite/core/constants/design_assets.dart';
import 'package:quickbite/core/constants/home_design_assets.dart';
import 'package:quickbite/shared/ui/atoms/qb_button.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.useRemoteImage = true});

  final bool useRemoteImage;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const _slides = <_OnboardingSlide>[
    _OnboardingSlide(
      titleStart: 'Food and groceries\n',
      titleEnd: 'delivered to your ',
      titleHighlight: 'doorstep',
      description:
          'The fastest way to get your favorite meals and essentials with QuickBite.',
      heroImageUrl: DesignAssets.onboardingHero,
    ),
    _OnboardingSlide(
      titleStart: 'Fresh ',
      titleHighlight: 'Groceries',
      titleEnd: ',\nAnytime',
      description:
          'Get fresh produce, dairy, and household essentials delivered from your favorite local stores in minutes.',
      heroImageUrl: HomeDesignAssets.onboardingGroceriesHero,
    ),
    _OnboardingSlide(
      titleStart: 'Unbeatable\nDeals & ',
      titleHighlight: 'Offers',
      titleEnd: '',
      description:
          'Enjoy exclusive discounts and save money with every order on QuickBite.',
      heroImageUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foregroundColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);

    return MobileFrameScaffold(
      frameColor: isDark
          ? QBTokens.backgroundDarkAlt
          : QBTokens.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _BrandLogo(textColor: foregroundColor),
                        const SizedBox(height: 24),
                        _HeroCard(
                          useRemoteImage: widget.useRemoteImage,
                          heroImageUrl: slide.heroImageUrl,
                        ),
                        const SizedBox(height: 32),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                            children: [
                              TextSpan(text: slide.titleStart),
                              TextSpan(
                                text: slide.titleHighlight,
                                style: const TextStyle(color: QBTokens.primary),
                              ),
                              TextSpan(text: slide.titleEnd),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  margin: EdgeInsets.only(
                    right: index == _slides.length - 1 ? 0 : 8,
                  ),
                  width: active ? 32 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: active
                        ? QBTokens.primary
                        : QBTokens.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  QBButton(
                    label: 'Get Started',
                    semanticLabel: SemanticsLabels.getStarted,
                    onPressed: () => context.go(AppRoutes.login),
                    height: 64,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: 128,
              height: 6,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: QBTokens.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Icon(Symbols.bolt, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          'QuickBite',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.useRemoteImage, required this.heroImageUrl});

  final bool useRemoteImage;
  final String? heroImageUrl;

  @override
  Widget build(BuildContext context) {
    if (heroImageUrl == null) {
      return const _PromoIconHeroCard();
    }

    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(QBTokens.radiusXl),
        border: Border.all(color: QBTokens.primary.withValues(alpha: 0.06)),
        color: const Color(0x1AF1277B),
      ),
      clipBehavior: Clip.antiAlias,
      child: useRemoteImage
          ? CachedNetworkImage(
              imageUrl: heroImageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const ColoredBox(color: Color(0xFFFCE7F3)),
              errorWidget: (context, url, error) =>
                  const ColoredBox(color: Color(0xFFFCE7F3)),
            )
          : const ColoredBox(color: Color(0xFFFCE7F3)),
    );
  }
}

class _PromoIconHeroCard extends StatelessWidget {
  const _PromoIconHeroCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(QBTokens.radiusXl),
        border: Border.all(color: QBTokens.primary.withValues(alpha: 0.08)),
        color: const Color(0x1AF1277B),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 26,
            top: 24,
            child: Icon(
              Symbols.percent,
              size: 62,
              color: QBTokens.primary.withValues(alpha: 0.35),
            ),
          ),
          Positioned(
            right: 22,
            bottom: 44,
            child: Icon(
              Symbols.redeem,
              size: 80,
              color: QBTokens.primary.withValues(alpha: 0.35),
            ),
          ),
          Positioned(
            left: 82,
            top: 168,
            child: Icon(
              Symbols.local_offer,
              size: 42,
              color: QBTokens.primary.withValues(alpha: 0.35),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 188,
                  height: 188,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: QBTokens.primary.withValues(alpha: 0.2),
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Symbols.card_giftcard,
                    size: 100,
                    fill: 1,
                    color: QBTokens.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: QBTokens.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'SAVE 50%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'HOT DEALS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.titleStart,
    required this.titleHighlight,
    required this.titleEnd,
    required this.description,
    required this.heroImageUrl,
  });

  final String titleStart;
  final String titleHighlight;
  final String titleEnd;
  final String description;
  final String? heroImageUrl;
}
