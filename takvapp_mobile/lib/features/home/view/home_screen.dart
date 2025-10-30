import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:takvapp_mobile/features/home/view/widgets/home_app_bar.dart';
import 'package:takvapp_mobile/features/home/view/widgets/stories_section.dart';
import 'package:takvapp_mobile/features/home/view/widgets/prayer_times_card.dart';
import 'package:takvapp_mobile/features/home/view/widgets/ask_imam_card.dart';
import 'package:takvapp_mobile/features/home/view/widgets/home_bottom_navigation_bar.dart';
import 'package:takvapp_mobile/features/home/view/widgets/story_model.dart';

class HomeScreen extends StatefulWidget {
  final DeviceStateResponse deviceState;

  const HomeScreen({Key? key, required this.deviceState}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<PrayerTimesBloc>().add(FetchPrayerTimes(widget.deviceState));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Story> _stories = [
    Story(imageUrl: 'assets/images/kaaba.png', label: 'Kaaba', isLive: true),
    Story(imageUrl: 'assets/images/daily_hadith.png', label: 'Daily Hadith'),
    Story(imageUrl: 'assets/images/profile.png', label: 'User 1'),
    Story(imageUrl: 'assets/images/profile.png', label: 'User 2'),
    Story(imageUrl: 'assets/images/profile.png', label: 'User 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StoriesSection(stories: _stories),
                  const PrayerTimesCard(),
                  const AskImamCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
