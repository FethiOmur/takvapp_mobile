import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_model.dart';

class StoriesSection extends StatelessWidget {
  final List<Story> stories;

  const StoriesSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Row(
          children: [
            for (int i = 0; i < stories.length; i++) ...[
              if (i != 0) const SizedBox(width: AppSpacing.md),
              _StoryBubble(story: stories[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  final Story story;

  const _StoryBubble({required this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Color(0xFFFF5F6D),
                Color(0xFFFFC371),
                Color(0xFF42C3FF),
                Color(0xFFFF5F6D),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  story.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.surfaceLow,
                      child: const Icon(Icons.image, color: AppColors.textSecondary),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(story.label, style: AppTextStyles.bodyS),
            if (story.isLive) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text('LIVE', style: AppTextStyles.label.copyWith(color: AppColors.white, fontSize: 10)),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
