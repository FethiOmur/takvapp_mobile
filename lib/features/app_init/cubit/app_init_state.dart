part of 'app_init_cubit.dart';

abstract class AppInitState extends Equatable {
  const AppInitState();
  @override
  List<Object> get props => [];
}

class AppInitInitial extends AppInitState {}

class AppInitLoading extends AppInitState {}

class AppInitSuccess extends AppInitState {
  final DeviceStateResponse deviceState;
  const AppInitSuccess(this.deviceState);
  @override
  List<Object> get props => [deviceState];
}

class AppInitFailure extends AppInitState {
  final String error;
  const AppInitFailure(this.error);
  @override
  List<Object> get props => [error];
}