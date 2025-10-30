import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_model.dart';

class StoriesSection extends StatelessWidget {
  final List<Story> stories;

  const StoriesSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return _buildStoryItem(stories[index]);
        },
      ),
    );
  }

  Widget _buildStoryItem(Story story) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double radius = constraints.maxHeight / 3;
        final double fontSize = radius / 4;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: radius,
                backgroundImage: AssetImage(story.imageUrl),
                child: story.isLive
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('LIVE', style: AppTextStyles.caption.copyWith(fontSize: fontSize / 1.5)),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                story.label,
                style: AppTextStyles.bodyText2.copyWith(fontSize: fontSize),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
