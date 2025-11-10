import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/app_init/view/app_init_wrapper_page.dart';
import 'package:takvapp_mobile/features/onboarding/view/email_verification_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final String _randomSvgPath;

  @override
  void initState() {
    super.initState();
    final onboardingSvgs = [
      'assets/images/onboarding/onboarding_1.svg',
      'assets/images/onboarding/onboarding_2.svg',
      'assets/images/onboarding/onboarding_3.svg',
      'assets/images/onboarding/onboarding_4.svg',
      'assets/images/onboarding/onboarding_5.svg',
      'assets/images/onboarding/onboarding_6.svg',
    ];
    final random = Random();
    _randomSvgPath = onboardingSvgs[random.nextInt(onboardingSvgs.length)];
  }

  void _openEmailVerification(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
    );
  }

  void _skip(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppInitWrapperPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              _randomSvgPath,
              fit: BoxFit.cover,
              placeholderBuilder: (context) => Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorBuilder: (context, error, stackTrace) {
                // Fallback to original image if SVG fails
                return Image.asset(
                  'assets/images/openingscreencami.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.975),
                  Colors.black.withValues(alpha: 1.0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.xl,
                    right: AppSpacing.xl,
                    top: AppSpacing.lg,
                    bottom: MediaQuery.of(context).size.height * 0.10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.background.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () => _skip(context),
                                child: Text(
                                  'Skip',
                                  style: AppTextStyles.bodyM.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/takvapplogo.png',
                              height: 110,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'TAKVAPP',
                              style: TextStyle(
                                fontFamily: 'Major Mono Display',
                                fontSize: AppTextStyles.displayXL.fontSize,
                                fontWeight: AppTextStyles.displayXL.fontWeight,
                                letterSpacing: 8,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _AuthButtons(onEmail: () => _openEmailVerification(context)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: AppSpacing.lg,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Privacy policy'),
                      ),
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Terms of service'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButtons extends StatelessWidget {
  final VoidCallback onEmail;

  const _AuthButtons({required this.onEmail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SocialButton(
          icon: _AppleIcon(),
          label: 'Continue with Apple',
          onTap: onEmail,
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.black,
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialButton(
          icon: _GoogleIcon(),
          label: 'Continue with Google',
          onTap: onEmail,
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.black87,
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialButton(
          label: 'Continue with Email',
          onTap: onEmail,
          backgroundColor: AppColors.white.withValues(alpha: 0.15),
          foregroundColor: AppColors.white,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget? icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SocialButton({
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 14,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SizedBox(width: 24, height: 24, child: icon),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label, style: AppTextStyles.bodyM.copyWith(color: foregroundColor)),
          ],
        ),
      ),
    );
  }
}

class _AppleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/apple.svg',
      width: 24,
      height: 24,
      fit: BoxFit.contain,
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/google.svg',
      width: 24,
      height: 24,
      fit: BoxFit.contain,
    );
  }
}
