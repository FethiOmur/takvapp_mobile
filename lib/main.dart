import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takvapp_mobile/core/api/api_service.dart';
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/api/fake_api_service.dart';
import 'package:takvapp_mobile/core/services/background_task_service.dart';
import 'package:takvapp_mobile/core/services/device_service.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';
import 'package:takvapp_mobile/core/services/prayer_cache_service.dart';
import 'package:takvapp_mobile/core/theme/app_theme.dart';
import 'package:takvapp_mobile/features/app_init/cubit/app_init_cubit.dart';
import 'package:takvapp_mobile/features/onboarding/view/onboarding_screen.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';

// UYGULAMANIN SAHTE VERİ KULLANIP KULLANMAYACAĞINI KONTROL EDEN BAYRAK
const bool useFakeApi = true;

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiServiceInterface>(
          create: (context) => useFakeApi ? FakeApiService() : ApiService(),
        ),
        RepositoryProvider(create: (context) => DeviceService()),
        RepositoryProvider(create: (context) => LocationService()),
        RepositoryProvider(create: (context) => PrayerCacheService()),
        RepositoryProvider<BackgroundTaskService>(
          create: (context) => NoopBackgroundTaskService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppInitCubit(
              context.read<DeviceService>(),
              context.read<ApiServiceInterface>(),
            )..initializeApp(),
          ),
          BlocProvider(
            create: (context) => PrayerTimesBloc(
              context.read<LocationService>(),
              context.read<PrayerCacheService>(),
              context.read<ApiServiceInterface>(),
              context.read<BackgroundTaskService>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Takva App',
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: const OnboardingScreen(),
        ),
      ),
    );
  }
}
