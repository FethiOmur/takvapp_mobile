import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class AskImamCard extends StatelessWidget {
  const AskImamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: AppColors.darkGrey.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/images/ask_imam.png', height: 24),
                const SizedBox(width: 8),
                const Text('Ask to the Imam AI', style: AppTextStyles.headline2),
              ],
            ),
            const SizedBox(height: 8),
            const Text('What is Eid al-Fitr?', style: AppTextStyles.bodyText2),
          ],
        ),
      ),
    );
  }
}
