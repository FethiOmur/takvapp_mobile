
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/api/api_service.dart';
import 'package:takvapp_mobile/core/api/fake_api_service.dart'; // SAHTE OLANI İÇERİ AKTAR
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/services/device_service.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';
import 'package:takvapp_mobile/features/app_init/cubit/app_init_cubit.dart';
import 'package:takvapp_mobile/features/app_init/view/app_init_wrapper_page.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:takvapp_mobile/features/onboarding/view/onboarding_screen.dart';

// UYGULAMANIN SAHTE VERİ KULLANIP KULLANMAYACAĞINI KONTROL EDEN BAYRAK
const bool USE_FAKE_API = true;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ApiService'i koşullu olarak sağla:
        RepositoryProvider<ApiServiceInterface>(
          create: (context) => USE_FAKE_API ? FakeApiService() : ApiService(),
        ),
        RepositoryProvider(create: (context) => DeviceService()),
        RepositoryProvider(create: (context) => LocationService()),
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
              // Burası önemli: 'dynamic' olarak oku
              context.read<ApiServiceInterface>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Takva App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          home: const OnboardingScreen(),
        ),
      ),
    );
  }
}
