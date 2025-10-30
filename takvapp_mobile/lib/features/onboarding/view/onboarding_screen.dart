
import 'package:flutter/material.dart';
import 'package:takvapp_mobile/features/app_init/view/app_init_wrapper_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  void _navigateToApp(BuildContext context) {
    // Giriş/Onboarding ekranına geri dönülmemesi için 'pushReplacement' kullanıyoruz.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AppInitWrapperPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Arka Plan Cami Görseli (Doğru dosya adı)
          Image.asset(
            'assets/images/openingscreencami.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  "'assets/images/openingscreencami.png' bulunamadı.\nLütfen manuel olarak eklediğinizden emin olun.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            },
          ),

          // 2. Arka Planı Karartma
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.5, 0.7, 1.0],
              ),
            ),
          ),

          // 3. Ana İçerik (Logo, Butonlar, vb.)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // 'Skip' (Atla) Butonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _navigateToApp(context),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 1), 

                  // Logo (Doğru dosya adı)
                  Image.asset(
                    'assets/images/takvapplogo.png',
                    height: 150, 
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: const Text(
                          "'assets/images/takvapplogo.png' bulunamadı.\nLütfen manuel olarak eklediğinizden emin olun.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      );
                    },
                  ),
                  
                  // 'TAKVA APP' Metni
                  const Text(
                    'T Δ K V Δ   Δ P P', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0, 
                    ),
                  ),

                  const Spacer(flex: 2), 

                  // Giriş Butonları
                  _buildLoginButton(
                    context,
                    text: 'Continue with Apple',
                    icon: Icons.apple,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      _navigateToApp(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildLoginButton(
                    context,
                    text: 'Continue with Google',
                    icon: Icons.g_mobiledata_sharp, 
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      _navigateToApp(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildLoginButton(
                    context,
                    text: 'Continue with Email',
                    backgroundColor: Colors.grey.shade800.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _navigateToApp(context);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Footer Linkleri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () { /* TODO: Gizlilik Politikası */ },
                        child: const Text(
                          'Privacy policy',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () { /* TODO: Hizmet Şartları */ },
                        child: const Text(
                          'Terms of service',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
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

  // Butonları tekrar etmemek için yardımcı metot
  Widget _buildLoginButton(
    BuildContext context, {
    required String text,
    IconData? icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon != null ? Icon(icon, size: 28) : const SizedBox(width: 0),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Yuvarlak buton
          ),
          alignment: icon != null ? Alignment.center : Alignment.center,
        ),
      ),
    );
  }
}
