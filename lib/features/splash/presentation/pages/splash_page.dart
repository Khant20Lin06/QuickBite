import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.enableAutoRedirect = true});

  final bool enableAutoRedirect;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _redirectDelay = Duration(milliseconds: 2800);
  static const _progressTick = Duration(milliseconds: 70);
  Timer? _redirectTimer;
  Timer? _progressTimer;
  double _progress = 0.18;
  bool _progressIncreasing = true;

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
    if (widget.enableAutoRedirect) {
      _redirectTimer = Timer(_redirectDelay, () {
        if (!mounted) {
          return;
        }
        context.go(AppRoutes.onboarding);
      });
    }
  }

  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(_progressTick, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        const step = 0.028;
        if (_progressIncreasing) {
          _progress += step;
          if (_progress >= 0.94) {
            _progress = 0.94;
            _progressIncreasing = false;
          }
        } else {
          _progress -= step;
          if (_progress <= 0.18) {
            _progress = 0.18;
            _progressIncreasing = true;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: QBTokens.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MobileFrameScaffold(
        frameColor: QBTokens.primary,
        child: _SplashContent(progress: _progress),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return SafeArea(
      child: Stack(
        children: [
          const Positioned(
            top: -96,
            right: -96,
            child: _DecorativeOrb(size: 256),
          ),
          const Positioned(
            bottom: -48,
            left: -48,
            child: _DecorativeOrb(size: 192),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 176,
                          height: 176,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 128,
                          height: 128,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 40,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/branding/splash_logo.png',
                            width: 82,
                            height: 82,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'QuickBite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Delivering Happiness',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'STARTING UP',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: progress,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'PREMIUM FOOD DELIVERY',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.56),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.6,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 128,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeOrb extends StatelessWidget {
  const _DecorativeOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
    );
  }
}
