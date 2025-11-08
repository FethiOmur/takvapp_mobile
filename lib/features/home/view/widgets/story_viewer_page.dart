import 'dart:async';

import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_model.dart';

class StoryViewerPage extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const StoryViewerPage({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  late PageController _pageController;
  late Timer _progressTimer;
  late int _currentIndex;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _startProgressTimer();
  }

  @override
  void dispose() {
    _progressTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startProgressTimer() {
    _progress = 0.0;
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _progress += 0.01;
          if (_progress >= 1.0) {
            _nextStory();
          }
        });
      }
    });
  }

  void _nextStory() {
    _progressTimer.cancel();
    if (_currentIndex < widget.stories.length - 1) {
      _currentIndex++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgressTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    _progressTimer.cancel();
    if (_currentIndex > 0) {
      _currentIndex--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgressTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _progress = 0.0;
    });
    _progressTimer.cancel();
    _startProgressTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return _StoryContent(story: story);
              },
            ),
            _StoryHeader(
              story: widget.stories[_currentIndex],
              progress: _progress,
              totalStories: widget.stories.length,
              currentIndex: _currentIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  final Story story;
  final double progress;
  final int totalStories;
  final int currentIndex;

  const _StoryHeader({
    required this.story,
    required this.progress,
    required this.totalStories,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < totalStories; i++)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: EdgeInsets.only(
                            right: i < totalStories - 1 ? 4 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: i == currentIndex
                              ? FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: progress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                )
                              : i < currentIndex
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    )
                                  : null,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        story.imageUrl,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 32,
                            height: 32,
                            color: AppColors.surfaceLow,
                            child: const Icon(
                              Icons.image,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                story.label,
                                style: AppTextStyles.bodyM.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (story.isLive) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    'LIVE',
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
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

class _StoryContent extends StatelessWidget {
  final Story story;

  const _StoryContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          story.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surfaceLow,
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: AppColors.textSecondary,
                  size: 64,
                ),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (story.title != null) ...[
                      Text(
                        story.title!,
                        style: AppTextStyles.displayL.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    if (story.contentText != null)
                      Text(
                        story.contentText!,
                        style: AppTextStyles.bodyL.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

