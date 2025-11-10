import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/services/dhikr_service.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class TesbihPage extends StatefulWidget {
  const TesbihPage({super.key});

  @override
  State<TesbihPage> createState() => _TesbihPageState();
}

class _TesbihPageState extends State<TesbihPage> {
  int? _selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.getBackgroundGradient(context),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.surfaceHigh.withValues(alpha: 0.3)
                              : AppColors.lightSurfaceHigh.withValues(alpha: 0.3),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Tesbih',
                      style: AppTextStyles.displayL.copyWith(
                        color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'سبحان الله',
                        transliteration: 'Subhana Allah',
                        translation: 'Allah\'ı tesbih ederim',
                        isSelected: _selectedCardIndex == 0,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 0;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'الحمد لله',
                        transliteration: 'Alhamdulillah',
                        translation: 'Hamd Allah\'a mahsustur',
                        isSelected: _selectedCardIndex == 1,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 1;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'لا إله إلا الله',
                        transliteration: 'La ilaha illa Allah',
                        translation: 'Allah\'tan başka ilah yoktur',
                        isSelected: _selectedCardIndex == 2,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 2;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'الله أكبر',
                        transliteration: 'Allahuakbar',
                        translation: 'Allah en büyüktür',
                        isSelected: _selectedCardIndex == 3,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 3;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'لا حول و لا قوة إلا بالله',
                        transliteration: 'La hawla wa la quwwata illa billah',
                        translation: 'Allah\'tan başka güç ve kuvvet yoktur',
                        isSelected: _selectedCardIndex == 4,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 4;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'سبحان الله وبحمده سبحان الله العظيم',
                        transliteration: 'Subhanallahi wa bihamdih',
                        translation: 'Allah\'ı noksan sıfatlardan tenzih ederim ve O\'na hamd ederim',
                        isSelected: _selectedCardIndex == 5,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 5;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'اللهم صل وسلم على سيدنا محمد وعلى آله وصحبه اجمعين',
                        transliteration: 'Allahumma Salle wa Salim \'Alaa Saiidina Muhammad',
                        translation: 'Allah\'ım, Efendimiz Muhammed\'e ve onun ailesine ve ashabına salat ve selam eyle',
                        isSelected: _selectedCardIndex == 6,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 6;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'لا اله الا انت سبحانك اني كنت من الظالمين',
                        transliteration: 'La illaha illa Anta Subhanak, inni kuntu mina adh-dhalimeen',
                        translation: 'Senden başka ilah yoktur, seni noksan sıfatlardan tenzih ederim, ben zalimlerden oldum',
                        isSelected: _selectedCardIndex == 7,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 7;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام',
                        transliteration: 'Allahumma anta salam wa minka salam tabarakta ya dhal jalali wal ikram',
                        translation: 'Allah\'ım, sen Selamsın, selamet sendendir. Ey Celal ve İkram sahibi, mübareksin',
                        isSelected: _selectedCardIndex == 8,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 8;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'أستغفر الله',
                        transliteration: 'Astaghfirullah',
                        translation: 'Allah\'tan bağışlanma dilerim',
                        isSelected: _selectedCardIndex == 9,
                        initialCount: 0,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 9;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DhikrCard(
                        arabicText: 'لا إله إلا الله محمد رسول الله',
                        transliteration: 'Laa Ilaha Illa-Allaah Muhammadan Rasool-Allaah',
                        translation: 'Allah\'tan başka ilah yoktur, Muhammed Allah\'ın elçisidir',
                        isSelected: _selectedCardIndex == 10,
                        initialCount: 0,
                        showMoreOptions: true,
                        onTap: () {
                          setState(() {
                            _selectedCardIndex = 10;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DhikrCard extends StatefulWidget {
  final String arabicText;
  final String transliteration;
  final String translation;
  final bool isSelected;
  final int initialCount;
  final bool showMoreOptions;
  final VoidCallback? onTap;

  const _DhikrCard({
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.isSelected,
    this.initialCount = 0,
    this.showMoreOptions = false,
    this.onTap,
  });

  @override
  State<_DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<_DhikrCard> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  void _incrementCount() async {
    setState(() {
      _count++;
    });
    // İlk kez çekildiğinde zikri kaydet
    if (_count == 1) {
      await DhikrService.saveRecitedDhikr(widget.translation);
    }
    // Toplam sayıyı artır
    await DhikrService.incrementTotalCount();
  }

  void _resetCount() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(28);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Arka plan rengi: seçili ise mavi, değilse tema rengine göre
    final backgroundColor = widget.isSelected
        ? const Color(0xFF4D8DFF)
        : (isDark
            ? const Color(0xFF1A2436)
            : AppColors.lightSurface.withValues(alpha: 0.95));
    
    // Metin renkleri: seçili ise beyaz, değilse tema rengine göre
    final textColor = widget.isSelected
        ? AppColors.white
        : (isDark ? AppColors.white : AppColors.lightTextPrimary);
    
    final secondaryTextColor = widget.isSelected
        ? AppColors.white.withValues(alpha: 0.9)
        : (isDark
            ? AppColors.textSecondary
            : AppColors.lightTextSecondary);

    return ClipRRect(
      borderRadius: borderRadius,
      child: GestureDetector(
        onTap: () {
          _incrementCount();
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: backgroundColor,
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.white.withValues(alpha: 0.1)
                  : (isDark
                      ? AppColors.white.withValues(alpha: 0.1)
                      : AppColors.lightTextMuted.withValues(alpha: 0.2)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Left side - Info, text, and action buttons
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Info icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? AppColors.white.withValues(alpha: 0.15)
                            : (isDark
                                ? AppColors.white.withValues(alpha: 0.15)
                                : AppColors.lightTextMuted.withValues(alpha: 0.15)),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: textColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Transliteration
                    Text(
                      widget.transliteration,
                      style: AppTextStyles.headingM.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Translation
                    Text(
                      widget.translation,
                      style: AppTextStyles.bodyM.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Reset or More options button
                    GestureDetector(
                      onTap: widget.showMoreOptions ? () {} : _resetCount,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.showMoreOptions
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.red.withValues(alpha: 0.3),
                        ),
                        child: Icon(
                          widget.showMoreOptions
                              ? Icons.more_vert_rounded
                              : Icons.refresh_rounded,
                          color: textColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Right side - Arabic text and counter
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Arabic text
                    Text(
                      widget.arabicText,
                      style: AppTextStyles.displayL.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Counter
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? Colors.black.withValues(alpha: 0.3)
                            : (isDark
                                ? AppColors.white.withValues(alpha: 0.1)
                                : AppColors.lightTextMuted.withValues(alpha: 0.1)),
                      ),
                      child: Center(
                        child: Text(
                          '$_count',
                          style: AppTextStyles.displayXL.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Tap instruction
                    Text(
                      '+1 eklemek için tıklayın',
                      style: AppTextStyles.bodyS.copyWith(
                        color: secondaryTextColor.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

