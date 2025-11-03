import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/app_init/view/app_init_wrapper_page.dart';
import 'package:takvapp_mobile/features/onboarding/view/email_verification_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
          Image.asset(
            'assets/images/openingscreencami.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => _skip(context),
                      child: const Text('Skip'),
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
                          style: AppTextStyles.displayXL.copyWith(
                            letterSpacing: 8,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _AuthButtons(onEmail: () => _openEmailVerification(context)),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
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
                ],
              ),
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
          icon: Icons.apple,
          label: 'Continue with Apple',
          onTap: onEmail,
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.black,
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialButton(
          icon: Icons.g_translate,
          label: 'Continue with Google',
          onTap: onEmail,
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.black87,
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialButton(
          label: 'Continue with Email',
          onTap: onEmail,
          backgroundColor: Colors.black.withValues(alpha: 0.6),
          foregroundColor: AppColors.white,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? icon;
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
              Icon(icon, color: foregroundColor),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label, style: AppTextStyles.bodyM.copyWith(color: foregroundColor)),
          ],
        ),
      ),
    );
  }
}
