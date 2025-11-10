import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const _surahs = [
    _QuranSurah(number: 1, turkishName: 'Fatiha', translation: 'Açılış', arabicName: 'ٱلْفَاتِحَة', isRead: true),
    _QuranSurah(number: 2, turkishName: 'Bakara', translation: 'İnek', arabicName: 'ٱلْبَقَرَة', isRead: true),
    _QuranSurah(number: 3, turkishName: 'Al-i İmran', translation: 'İmran Ailesi', arabicName: 'آلِ عِمْرَان', isRead: true),
    _QuranSurah(number: 4, turkishName: 'Nisa', translation: 'Kadınlar', arabicName: 'ٱلنِّسَاء', isRead: false),
    _QuranSurah(number: 5, turkishName: 'Maide', translation: 'Sofra', arabicName: 'ٱلْمَائِدَة', isRead: false),
    _QuranSurah(number: 6, turkishName: 'En\'am', translation: 'Davarlar', arabicName: 'ٱلْأَنْعَام', isRead: false),
    _QuranSurah(number: 7, turkishName: 'A\'raf', translation: 'Yüksek Yerler', arabicName: 'ٱلْأَعْرَاف', isRead: false),
    _QuranSurah(number: 8, turkishName: 'Enfal', translation: 'Ganimetler', arabicName: 'ٱلْأَنفَال', isRead: false),
    _QuranSurah(number: 9, turkishName: 'Tevbe', translation: 'Tövbe', arabicName: 'ٱلتَّوْبَة', isRead: false),
    _QuranSurah(number: 10, turkishName: 'Yunus', translation: 'Yunus', arabicName: 'يُونُس', isRead: false),
    _QuranSurah(number: 11, turkishName: 'Hud', translation: 'Hud', arabicName: 'هُود', isRead: false),
    _QuranSurah(number: 12, turkishName: 'Yusuf', translation: 'Yusuf', arabicName: 'يُوسُف', isRead: false),
    _QuranSurah(number: 13, turkishName: 'Ra\'d', translation: 'Gök Gürültüsü', arabicName: 'ٱلرَّعْد', isRead: false),
    _QuranSurah(number: 14, turkishName: 'İbrahim', translation: 'İbrahim', arabicName: 'إِبْرَٰهِيم', isRead: false),
    _QuranSurah(number: 15, turkishName: 'Hicr', translation: 'Hicr', arabicName: 'ٱلْحِجْر', isRead: false),
    _QuranSurah(number: 16, turkishName: 'Nahl', translation: 'Arı', arabicName: 'ٱلنَّحْل', isRead: false),
    _QuranSurah(number: 17, turkishName: 'İsra', translation: 'Gece Yürüyüşü', arabicName: 'ٱلْإِسْرَاء', isRead: false),
    _QuranSurah(number: 18, turkishName: 'Kehf', translation: 'Mağara', arabicName: 'ٱلْكَهْف', isRead: false),
    _QuranSurah(number: 19, turkishName: 'Meryem', translation: 'Meryem', arabicName: 'مَرْيَم', isRead: false),
    _QuranSurah(number: 20, turkishName: 'Taha', translation: 'Taha', arabicName: 'طه', isRead: false),
    _QuranSurah(number: 21, turkishName: 'Enbiya', translation: 'Peygamberler', arabicName: 'ٱلْأَنبِيَاء', isRead: false),
    _QuranSurah(number: 22, turkishName: 'Hac', translation: 'Hac', arabicName: 'ٱلْحَج', isRead: false),
    _QuranSurah(number: 23, turkishName: 'Mü\'minun', translation: 'Müminler', arabicName: 'ٱلْمُؤْمِنُون', isRead: false),
    _QuranSurah(number: 24, turkishName: 'Nur', translation: 'Işık', arabicName: 'ٱلنُّور', isRead: false),
    _QuranSurah(number: 25, turkishName: 'Furkan', translation: 'Furkan', arabicName: 'ٱلْفُرْقَان', isRead: false),
    _QuranSurah(number: 26, turkishName: 'Şuara', translation: 'Şairler', arabicName: 'ٱلشُّعَرَاء', isRead: false),
    _QuranSurah(number: 27, turkishName: 'Neml', translation: 'Karınca', arabicName: 'ٱلنَّمْل', isRead: false),
    _QuranSurah(number: 28, turkishName: 'Kasas', translation: 'Hikaye', arabicName: 'ٱلْقَصَص', isRead: false),
    _QuranSurah(number: 29, turkishName: 'Ankebut', translation: 'Örümcek', arabicName: 'ٱلْعَنكَبُوت', isRead: false),
    _QuranSurah(number: 30, turkishName: 'Rum', translation: 'Romalılar', arabicName: 'ٱلرُّوم', isRead: false),
    _QuranSurah(number: 31, turkishName: 'Lokman', translation: 'Lokman', arabicName: 'لُقْمَان', isRead: false),
    _QuranSurah(number: 32, turkishName: 'Secde', translation: 'Secde', arabicName: 'ٱلسَّجْدَة', isRead: false),
    _QuranSurah(number: 33, turkishName: 'Ahzab', translation: 'Gruplar', arabicName: 'ٱلْأَحْزَاب', isRead: false),
    _QuranSurah(number: 34, turkishName: 'Sebe', translation: 'Seba', arabicName: 'سَبَأ', isRead: false),
    _QuranSurah(number: 35, turkishName: 'Fatır', translation: 'Yaratıcı', arabicName: 'فَاطِر', isRead: false),
    _QuranSurah(number: 36, turkishName: 'Yasin', translation: 'Yasin', arabicName: 'يس', isRead: false),
    _QuranSurah(number: 37, turkishName: 'Saffat', translation: 'Sıralananlar', arabicName: 'ٱلصَّافَّات', isRead: false),
    _QuranSurah(number: 38, turkishName: 'Sad', translation: 'Sad', arabicName: 'ص', isRead: false),
    _QuranSurah(number: 39, turkishName: 'Zümer', translation: 'Gruplar', arabicName: 'ٱلزُّمَر', isRead: false),
    _QuranSurah(number: 40, turkishName: 'Gafir', translation: 'Bağışlayan', arabicName: 'غَافِر', isRead: false),
    _QuranSurah(number: 41, turkishName: 'Fussilet', translation: 'Açıklanan', arabicName: 'فُصِّلَت', isRead: false),
    _QuranSurah(number: 42, turkishName: 'Şura', translation: 'Danışma', arabicName: 'ٱلشُّورَىٰ', isRead: false),
    _QuranSurah(number: 43, turkishName: 'Zuhruf', translation: 'Süslemeler', arabicName: 'ٱلزُّخْرُف', isRead: false),
    _QuranSurah(number: 44, turkishName: 'Duhan', translation: 'Duman', arabicName: 'ٱلدُّخَان', isRead: false),
    _QuranSurah(number: 45, turkishName: 'Casiye', translation: 'Diz Çöken', arabicName: 'ٱلْجَاثِيَة', isRead: false),
    _QuranSurah(number: 46, turkishName: 'Ahkaf', translation: 'Kum Tepeleri', arabicName: 'ٱلْأَحْقَاف', isRead: false),
    _QuranSurah(number: 47, turkishName: 'Muhammed', translation: 'Muhammed', arabicName: 'مُحَمَّد', isRead: false),
    _QuranSurah(number: 48, turkishName: 'Fetih', translation: 'Fetih', arabicName: 'ٱلْفَتْح', isRead: false),
    _QuranSurah(number: 49, turkishName: 'Hucurat', translation: 'Odalar', arabicName: 'ٱلْحُجُرَات', isRead: false),
    _QuranSurah(number: 50, turkishName: 'Kaf', translation: 'Kaf', arabicName: 'ق', isRead: false),
    _QuranSurah(number: 51, turkishName: 'Zariyat', translation: 'Dağıtanlar', arabicName: 'ٱلذَّارِيَات', isRead: false),
    _QuranSurah(number: 52, turkishName: 'Tur', translation: 'Tur Dağı', arabicName: 'ٱلطُّور', isRead: false),
    _QuranSurah(number: 53, turkishName: 'Necm', translation: 'Yıldız', arabicName: 'ٱلنَّجْم', isRead: false),
    _QuranSurah(number: 54, turkishName: 'Kamer', translation: 'Ay', arabicName: 'ٱلْقَمَر', isRead: false),
    _QuranSurah(number: 55, turkishName: 'Rahman', translation: 'Rahman', arabicName: 'ٱلرَّحْمَٰن', isRead: false),
    _QuranSurah(number: 56, turkishName: 'Vakıa', translation: 'Olay', arabicName: 'ٱلْوَاقِعَة', isRead: false),
    _QuranSurah(number: 57, turkishName: 'Hadid', translation: 'Demir', arabicName: 'ٱلْحَدِيد', isRead: false),
    _QuranSurah(number: 58, turkishName: 'Mücadele', translation: 'Tartışma', arabicName: 'ٱلْمُجَادِلَة', isRead: false),
    _QuranSurah(number: 59, turkishName: 'Haşr', translation: 'Toplama', arabicName: 'ٱلْحَشْر', isRead: false),
    _QuranSurah(number: 60, turkishName: 'Mümtehine', translation: 'Sınanan', arabicName: 'ٱلْمُمْتَحَنَة', isRead: false),
    _QuranSurah(number: 61, turkishName: 'Saf', translation: 'Sıra', arabicName: 'ٱلصَّف', isRead: false),
    _QuranSurah(number: 62, turkishName: 'Cuma', translation: 'Cuma', arabicName: 'ٱلْجُمُعَة', isRead: false),
    _QuranSurah(number: 63, turkishName: 'Münafikun', translation: 'İkiyüzlüler', arabicName: 'ٱلْمُنَافِقُون', isRead: false),
    _QuranSurah(number: 64, turkishName: 'Teğabun', translation: 'Aldatma', arabicName: 'ٱلتَّغَابُن', isRead: false),
    _QuranSurah(number: 65, turkishName: 'Talak', translation: 'Boşanma', arabicName: 'ٱلطَّلَاق', isRead: false),
    _QuranSurah(number: 66, turkishName: 'Tahrim', translation: 'Yasaklama', arabicName: 'ٱلتَّحْرِيم', isRead: false),
    _QuranSurah(number: 67, turkishName: 'Mülk', translation: 'Egemenlik', arabicName: 'ٱلْمُلْك', isRead: false),
    _QuranSurah(number: 68, turkishName: 'Kalem', translation: 'Kalem', arabicName: 'ٱلْقَلَم', isRead: false),
    _QuranSurah(number: 69, turkishName: 'Hakka', translation: 'Gerçek', arabicName: 'ٱلْحَاقَّة', isRead: false),
    _QuranSurah(number: 70, turkishName: 'Mearic', translation: 'Yükselen Basamaklar', arabicName: 'ٱلْمَعَارِج', isRead: false),
    _QuranSurah(number: 71, turkishName: 'Nuh', translation: 'Nuh', arabicName: 'نُوح', isRead: false),
    _QuranSurah(number: 72, turkishName: 'Cin', translation: 'Cin', arabicName: 'ٱلْجِن', isRead: false),
    _QuranSurah(number: 73, turkishName: 'Müzzemmil', translation: 'Örtünen', arabicName: 'ٱلْمُزَّمِّل', isRead: false),
    _QuranSurah(number: 74, turkishName: 'Müddessir', translation: 'Örtüsüne Bürünen', arabicName: 'ٱلْمُدَّثِّر', isRead: false),
    _QuranSurah(number: 75, turkishName: 'Kıyame', translation: 'Diriliş', arabicName: 'ٱلْقِيَامَة', isRead: false),
    _QuranSurah(number: 76, turkishName: 'İnsan', translation: 'İnsan', arabicName: 'ٱلْإِنْسَان', isRead: false),
    _QuranSurah(number: 77, turkishName: 'Mürselat', translation: 'Gönderilenler', arabicName: 'ٱلْمُرْسَلَات', isRead: false),
    _QuranSurah(number: 78, turkishName: 'Nebe', translation: 'Haber', arabicName: 'ٱلنَّبَأ', isRead: false),
    _QuranSurah(number: 79, turkishName: 'Naziat', translation: 'Söküp Çıkaranlar', arabicName: 'ٱلنَّازِعَات', isRead: false),
    _QuranSurah(number: 80, turkishName: 'Abese', translation: 'Surat Astı', arabicName: 'عَبَسَ', isRead: false),
    _QuranSurah(number: 81, turkishName: 'Tekvir', translation: 'Bürüme', arabicName: 'ٱلتَّكْوِير', isRead: false),
    _QuranSurah(number: 82, turkishName: 'İnfitar', translation: 'Yarılma', arabicName: 'ٱلْإِنفِطَار', isRead: false),
    _QuranSurah(number: 83, turkishName: 'Mutaffifin', translation: 'Aldatanlar', arabicName: 'ٱلْمُطَفِّفِين', isRead: false),
    _QuranSurah(number: 84, turkishName: 'İnşikak', translation: 'Yarılma', arabicName: 'ٱلْإِنشِقَاق', isRead: false),
    _QuranSurah(number: 85, turkishName: 'Buruc', translation: 'Burçlar', arabicName: 'ٱلْبُرُوج', isRead: false),
    _QuranSurah(number: 86, turkishName: 'Tarık', translation: 'Gece Gelen', arabicName: 'ٱلطَّارِق', isRead: false),
    _QuranSurah(number: 87, turkishName: 'A\'la', translation: 'En Yüce', arabicName: 'ٱلْأَعْلَىٰ', isRead: false),
    _QuranSurah(number: 88, turkishName: 'Ğaşiye', translation: 'Kaplayan', arabicName: 'ٱلْغَاشِيَة', isRead: false),
    _QuranSurah(number: 89, turkishName: 'Fecr', translation: 'Şafak', arabicName: 'ٱلْفَجْر', isRead: false),
    _QuranSurah(number: 90, turkishName: 'Beled', translation: 'Şehir', arabicName: 'ٱلْبَلَد', isRead: false),
    _QuranSurah(number: 91, turkishName: 'Şems', translation: 'Güneş', arabicName: 'ٱلشَّمْس', isRead: false),
    _QuranSurah(number: 92, turkishName: 'Leyl', translation: 'Gece', arabicName: 'ٱللَّيْل', isRead: false),
    _QuranSurah(number: 93, turkishName: 'Duha', translation: 'Kuşluk Vakti', arabicName: 'ٱلضُّحَىٰ', isRead: false),
    _QuranSurah(number: 94, turkishName: 'İnşirah', translation: 'Açma', arabicName: 'ٱلشَّرْح', isRead: false),
    _QuranSurah(number: 95, turkishName: 'Tin', translation: 'İncir', arabicName: 'ٱلتِّين', isRead: false),
    _QuranSurah(number: 96, turkishName: 'Alak', translation: 'Pıhtı', arabicName: 'ٱلْعَلَق', isRead: false),
    _QuranSurah(number: 97, turkishName: 'Kadir', translation: 'Kadir', arabicName: 'ٱلْقَدْر', isRead: false),
    _QuranSurah(number: 98, turkishName: 'Beyyine', translation: 'Kanıt', arabicName: 'ٱلْبَيِّنَة', isRead: false),
    _QuranSurah(number: 99, turkishName: 'Zilzal', translation: 'Deprem', arabicName: 'ٱلزَّلْزَلَة', isRead: false),
    _QuranSurah(number: 100, turkishName: 'Adiyat', translation: 'Koşanlar', arabicName: 'ٱلْعَادِيَات', isRead: false),
    _QuranSurah(number: 101, turkishName: 'Karia', translation: 'Felaket', arabicName: 'ٱلْقَارِعَة', isRead: false),
    _QuranSurah(number: 102, turkishName: 'Tekasür', translation: 'Çoğaltma', arabicName: 'ٱلتَّكَاثُر', isRead: false),
    _QuranSurah(number: 103, turkishName: 'Asr', translation: 'Zaman', arabicName: 'ٱلْعَصْر', isRead: false),
    _QuranSurah(number: 104, turkishName: 'Hümeze', translation: 'Dedikoducu', arabicName: 'ٱلْهُمَزَة', isRead: false),
    _QuranSurah(number: 105, turkishName: 'Fil', translation: 'Fil', arabicName: 'ٱلْفِيل', isRead: false),
    _QuranSurah(number: 106, turkishName: 'Kureyş', translation: 'Kureyş', arabicName: 'قُرَيْش', isRead: false),
    _QuranSurah(number: 107, turkishName: 'Maun', translation: 'Yardım', arabicName: 'ٱلْمَاعُون', isRead: false),
    _QuranSurah(number: 108, turkishName: 'Kevser', translation: 'Kevser', arabicName: 'ٱلْكَوْثَر', isRead: false),
    _QuranSurah(number: 109, turkishName: 'Kafirun', translation: 'Kafirler', arabicName: 'ٱلْكَافِرُون', isRead: false),
    _QuranSurah(number: 110, turkishName: 'Nasr', translation: 'Yardım', arabicName: 'ٱلنَّصْر', isRead: false),
    _QuranSurah(number: 111, turkishName: 'Tebbet', translation: 'Kurumuş', arabicName: 'تَبَّت', isRead: false),
    _QuranSurah(number: 112, turkishName: 'İhlas', translation: 'Samimiyet', arabicName: 'ٱلْإِخْلَاص', isRead: false),
    _QuranSurah(number: 113, turkishName: 'Felak', translation: 'Şafak', arabicName: 'ٱلْفَلَق', isRead: false),
    _QuranSurah(number: 114, turkishName: 'Nas', translation: 'İnsanlar', arabicName: 'ٱلنَّاس', isRead: false),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_QuranSurah> get _filteredSurahs {
    if (_searchQuery.isEmpty) {
      return _surahs;
    }
    final query = _searchQuery.toLowerCase().trim();
    return _surahs.where((surah) {
      return surah.turkishName.toLowerCase().contains(query) ||
          surah.translation.toLowerCase().contains(query) ||
          surah.number.toString() == query;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const arabicHeadlineStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.secondary,
      height: 1.2,
      fontFamilyFallback: ['Noto Naskh Arabic', 'Geeza Pro', 'Arial'],
    );

    final filteredSurahs = _filteredSurahs;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.getBackgroundGradient(context),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              MediaQuery.of(context).padding.bottom + 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SurahSearchField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_searchQuery.isEmpty) ...[
                _LastReadCard(arabicHeadlineStyle: arabicHeadlineStyle),
                const SizedBox(height: AppSpacing.xl),
                ],
                ...List.generate(
                  filteredSurahs.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == filteredSurahs.length - 1 ? 0 : AppSpacing.md,
                    ),
                    child: _SurahCard(
                      surah: filteredSurahs[index],
                      arabicHeadlineStyle: arabicHeadlineStyle,
                    ),
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

class _SurahSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SurahSearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.bodyL.copyWith(
        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Sure ara...',
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceHigh.withValues(alpha: 0.8)
            : AppColors.lightSurfaceHigh.withValues(alpha: 0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark
              ? AppColors.textSecondary.withValues(alpha: 0.9)
              : AppColors.lightTextMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}

class _LastReadCard extends StatelessWidget {
  final TextStyle arabicHeadlineStyle;

  const _LastReadCard({required this.arabicHeadlineStyle});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A2436),
                    Color(0xFF0B111D),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lightSurface.withValues(alpha: 0.95),
                    AppColors.lightSurfaceHigh.withValues(alpha: 0.9),
                  ],
                ),
          border: Border.all(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.08)
                : AppColors.lightTextMuted.withValues(alpha: 0.2),
          ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -8),
                          child: Text(
                            'Son Okunan',
                            style: AppTextStyles.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.9)
                                  : AppColors.lightTextSecondary,
                              letterSpacing: 0.6,
                              height: 1.0,
                  ),
                ),
              ),
                        Transform.translate(
                          offset: const Offset(0, -60),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow effect
                                Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF62F5FF).withValues(alpha: 0.2),
                                        blurRadius: 50,
                                        spreadRadius: 10,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF4D8DFF).withValues(alpha: 0.175),
                                        blurRadius: 65,
                                        spreadRadius: 8,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF87CEEB).withValues(alpha: 0.15),
                                        blurRadius: 70,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // SVG
                                SvgPicture.asset(
                                  'assets/images/Quran.svg',
                                  width: 200,
                                  height: 200,
                                ),
                              ],
                  ),
                ),
              ),
                        Transform.translate(
                          offset: const Offset(0, -100),
                          child: Center(
                    child: Text(
                      'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      style: arabicHeadlineStyle.copyWith(
                        color: const Color(0xFFFFD27D),
                        fontSize: 26,
                                height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -85),
                    child: Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Bakara Suresi',
                          style: AppTextStyles.headingM.copyWith(
                            fontSize: 22,
                              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                            'Ayet 255',
                          style: AppTextStyles.bodyM.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.9)
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: 20,
              child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4D8DFF),
                          Color(0xFF62F5FF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF62F5FF).withValues(alpha: 0.16),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md + 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                              'Devam Et',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
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

class _SurahCard extends StatelessWidget {
  final _QuranSurah surah;
  final TextStyle arabicHeadlineStyle;

  const _SurahCard({
    required this.surah,
    required this.arabicHeadlineStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.textSecondary : AppColors.lightTextMuted;
    final borderRadius = BorderRadius.circular(36);
    final backgroundGradient = isDark
        ? const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A2436),
        Color(0xFF0B111D),
      ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lightSurface.withValues(alpha: 0.95),
              AppColors.lightSurfaceHigh.withValues(alpha: 0.9),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () {},
          splashColor: accentColor.withValues(alpha: 0.12),
          highlightColor: accentColor.withValues(alpha: 0.08),
          child: Opacity(
            opacity: surah.isRead ? 0.6 : 1.0,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: backgroundGradient,
                border: Border.all(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.08)
                      : AppColors.lightTextMuted.withValues(alpha: 0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.024),
                            accentColor.withValues(alpha: 0.012),
                          ],
                        ),
                        border: Border.all(color: accentColor.withValues(alpha: 0.03)),
                      ),
                      child: Text(
                        surah.number.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            surah.turkishName,
                            style: AppTextStyles.headingM.copyWith(
                              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            surah.translation,
                            style: AppTextStyles.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.9)
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Text(
                      surah.arabicName,
                      style: arabicHeadlineStyle.copyWith(
                        color: surah.isRead
                            ? (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)
                            : const Color(0xFFFFD27D),
                        fontSize: surah.isRead ? 24 : 22,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuranSurah {
  final int number;
  final String turkishName;
  final String translation;
  final String arabicName;
  final bool isRead;

  const _QuranSurah({
    required this.number,
    required this.turkishName,
    required this.translation,
    required this.arabicName,
    required this.isRead,
  });
}
