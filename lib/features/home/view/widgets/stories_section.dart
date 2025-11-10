import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_model.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_viewer_page.dart';

class StoriesSection extends StatelessWidget {
  final List<Story> stories;

  const StoriesSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        itemCount: stories.length + 1,
        cacheExtent: 200,
        itemBuilder: (context, index) {
          if (index == stories.length) {
            return const SizedBox(width: AppSpacing.xl);
          }
          return RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? AppSpacing.md : 0,
              ),
              child: _StoryBubble(
                key: ValueKey('story_${stories[index].label}_$index'),
                story: stories[index],
                index: index,
                allStories: stories,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  final Story story;
  final int index;
  final List<Story> allStories;

  const _StoryBubble({
    super.key,
    required this.story,
    required this.index,
    required this.allStories,
  });

  static const _normalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE1306C),
      Color(0xFFF77737),
      Color(0xFFFCAF45),
      Color(0xFFE1306C),
    ],
    stops: [0.0, 0.25, 0.5, 1.0],
  );

  static const _liveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF0069),
      Color(0xFFFF0069),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StoryViewerPage(
              stories: allStories,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: story.isLive ? _liveGradient : _normalGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.background : AppColors.lightBackground,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: story.imageUrl.contains('profile.png')
                      ? Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.surfaceHigh
                                : AppColors.lightSurfaceHigh.withValues(alpha: 0.8),
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                story.imageUrl,
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                                cacheWidth: 150,
                                cacheHeight: 150,
                                filterQuality: FilterQuality.low,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 75,
                                    height: 75,
                                    color: isDark
                                        ? AppColors.surfaceLow
                                        : AppColors.lightSurfaceLow,
                                    child: Icon(
                                      Icons.person,
                                      color: isDark
                                          ? AppColors.textSecondary
                                          : AppColors.lightTextSecondary,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                              // Profil resmi için overlay ekle
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.white.withValues(alpha: 0.1)
                                        : AppColors.lightTextMuted.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.asset(
                          story.imageUrl,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          cacheWidth: 150,
                          cacheHeight: 150,
                          filterQuality: FilterQuality.low,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 75,
                              height: 75,
                              color: isDark
                                  ? AppColors.surfaceLow
                                  : AppColors.lightSurfaceLow,
                              child: Icon(
                                Icons.image,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                                size: 32,
                              ),
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
              Text(
                story.label,
                style: AppTextStyles.bodyS.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
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
      ),
    );
  }
}
