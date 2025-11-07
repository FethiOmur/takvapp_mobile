import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/features/home/view/widgets/ask_imam_card.dart';
import 'package:takvapp_mobile/features/home/view/widgets/home_app_bar.dart';
import 'package:takvapp_mobile/features/home/view/widgets/home_bottom_navigation_bar.dart';
import 'package:takvapp_mobile/features/home/view/widgets/home_insights_row.dart';
import 'package:takvapp_mobile/features/home/view/widgets/prayer_times_card.dart';
import 'package:takvapp_mobile/features/home/view/widgets/stories_section.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_model.dart';
import 'package:takvapp_mobile/features/qibla/cubit/qibla_cubit.dart';
import 'package:takvapp_mobile/features/qibla/view/qibla_page.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:takvapp_mobile/features/quran/view/quran_page.dart';

class HomeScreen extends StatefulWidget {
  final DeviceStateResponse deviceState;

  const HomeScreen({super.key, required this.deviceState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late final Widget _qiblaTab;
  Timer? _dayChangeTimer;

  final List<Story> _stories = const [
    Story(imageUrl: 'assets/images/kaaba.png', label: 'Kaaba', isLive: true),
    Story(imageUrl: 'assets/images/daily_hadith.png', label: 'Daily Hadith'),
    Story(imageUrl: 'assets/images/profile.png', label: 'Community'),
    Story(imageUrl: 'assets/images/profile.png', label: 'Dua of the day'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<PrayerTimesBloc>().add(FetchPrayerTimes(widget.deviceState));
    _qiblaTab = BlocProvider(
      create: (context) => QiblaCubit(
        context.read<LocationService>(),
      )..loadQibla(
        fallbackLocation: widget.deviceState.deviceState?.lastLocation,
      ),
      child: const QiblaPage(),
    );
    _startDayChangeWatcher();
    _checkDayChange();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkDayChange();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dayChangeTimer?.cancel();
    super.dispose();
  }

  void _startDayChangeWatcher() {
    _dayChangeTimer?.cancel();
    _dayChangeTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkDayChange(),
    );
  }

  void _checkDayChange() {
    if (!mounted) return;
    context.read<PrayerTimesBloc>().add(
          RefreshPrayerTimesIfDayChanged(
            referenceTime: DateTime.now(),
            deviceState: widget.deviceState,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.surfaceLow],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: const HomeAppBar(),
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _HomeOverview(stories: _stories),
                    _qiblaTab,
                    const _PlaceholderPage(label: 'Detailed timetable'),
                    const _PlaceholderPage(label: 'Insights'),
                    const QuranPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _HomeOverview extends StatelessWidget {
  final List<Story> stories;

  const _HomeOverview({required this.stories});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StoriesSection(stories: stories),
          const SizedBox(height: AppSpacing.lg),
          const PrayerTimesCard(),
          const SizedBox(height: AppSpacing.lg),
          const HomeInsightsRow(),
          const SizedBox(height: AppSpacing.lg),
          const AskImamCard(),
          const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String label;

  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
