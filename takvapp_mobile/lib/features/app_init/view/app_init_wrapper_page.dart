
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/features/app_init/cubit/app_init_cubit.dart';
import 'package:takvapp_mobile/features/home/view/home_screen.dart';

class AppInitWrapperPage extends StatelessWidget {
  const AppInitWrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppInitCubit, AppInitState>(
      builder: (context, state) {
        if (state is AppInitSuccess) {
          // Başarılı: HomeScreen'e yönlendir ve `deviceState`'i aktar
          return HomeScreen(deviceState: state.deviceState);
        }
        if (state is AppInitFailure) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Uygulama başlatılırken bir hata oluştu:\n${state.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        // Initial veya Loading durumu
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
