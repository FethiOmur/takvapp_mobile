import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: 'https://www.figma.com/api/mcp/asset/30f612b3-459b-4787-a93d-a8c0b37120f7', // imgBottomFrame
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildStories(),
                  _buildPrayerTimesCard(),
                  _buildAskImamCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://www.figma.com/api/mcp/asset/462648e5-0295-4eb0-a54b-bb4911847c62'), // imgProfileImage
          ),
        ],
      ),
    );
  }

  Widget _buildStories() {
    // Placeholder data for stories
    final stories = [
      {'image': 'https://www.figma.com/api/mcp/asset/24f24b5e-ffa9-4c85-a770-18ded452db6e', 'label': 'Kaaba', 'live': true},
      {'image': 'https://www.figma.com/api/mcp/asset/cdf213b6-62b0-45ab-b832-daa68b124406', 'label': 'Daily Hadith'},
      {'image': 'https://www.figma.com/api/mcp/asset/462648e5-0295-4eb0-a54b-bb4911847c62', 'label': 'Seyitin'},
      {'image': 'https://www.figma.com/api/mcp/asset/462648e5-0295-4eb0-a54b-bb4911847c62', 'label': 'Götü Bitli'},
      {'image': 'https://www.figma.com/api/mcp/asset/462648e5-0295-4eb0-a54b-bb4911847c62', 'label': 'Müko'},
    ];

    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return _buildStoryItem(stories[index]);
        },
      ),
    );
  }

  Widget _buildStoryItem(Map<String, dynamic> story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(story['image']!),
            child: story['live'] == true
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8)),
                    ),
                  )
                : null,
          ),
          SizedBox(height: 4),
          Text(story['label']!, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesCard() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
          builder: (context, state) {
            if (state is PrayerTimesLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is PrayerTimesFailure) {
              return Center(child: Text(state.error, style: TextStyle(color: Colors.white)));
            }
            if (state is PrayerTimesSuccess) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('17:21', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text('Istanbul, Turkey', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Text('Maghrib will begin in -00:37:25', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Image.network('https://www.figma.com/api/mcp/asset/a174b467-3bc3-4e12-9943-7ac287c22d2a', height: 72), // imgFi1852617
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPrayerTime('Fajr', state.prayerTimes.fajr ?? '-', 'https://www.figma.com/api/mcp/asset/22e5bfa4-c874-4a93-bf8f-fda5e5cc8e5e'),
                      _buildPrayerTime('Dhuhr', state.prayerTimes.dhuhr ?? '-', 'https://www.figma.com/api/mcp/asset/13a1a9ed-4c33-4856-8075-dec1d205e087'),
                      _buildPrayerTime('Asr', state.prayerTimes.asr ?? '-', 'https://www.figma.com/api/mcp/asset/22e5bfa4-c874-4a93-bf8f-fda5e5cc8e5e'),
                      _buildPrayerTime('Maghrib', state.prayerTimes.maghrib ?? '-', 'https://www.figma.com/api/mcp/asset/11cdf9ee-5a66-4cdd-ba70-dbfc6d9dc1d5', isCurrent: true),
                      _buildPrayerTime('Isha', state.prayerTimes.isha ?? '-', 'https://www.figma.com/api/mcp/asset/27ad15dc-5a05-4720-a40b-6c66e48d5f6e'),
                    ],
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildPrayerTime(String name, String time, String iconUrl, {bool isCurrent = false}) {
    return Column(
      children: [
        Text(name, style: TextStyle(color: isCurrent ? Colors.cyan : Colors.white, fontSize: 14)),
        SizedBox(height: 4),
        Image.network(iconUrl, height: 24),
        SizedBox(height: 4),
        Text(time, style: TextStyle(color: isCurrent ? Colors.cyan : Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildAskImamCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network('https://www.figma.com/api/mcp/asset/115cbbf6-3947-4dd7-8e0d-2459ee272f9e', height: 24), // imgVuesaxLinearVoiceSquare
                SizedBox(width: 8),
                Text('Ask to the Imam AI', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text('What is Eid al-Fitr?', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Qibla',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Prayer Times',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Quran',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black.withOpacity(0.8),
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}