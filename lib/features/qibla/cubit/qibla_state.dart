part of 'qibla_cubit.dart';

enum QiblaStatus { initial, loading, success, failure }

class QiblaState extends Equatable {
  const QiblaState({
    this.status = QiblaStatus.initial,
    this.userLatitude,
    this.userLongitude,
    this.qiblaBearing,
    this.distanceToKaabaKm,
    this.locationDescription,
    this.qiblaDirectionLabel,
    this.usedFallbackPosition = false,
    this.errorMessage,
  });

  final QiblaStatus status;
  final double? userLatitude;
  final double? userLongitude;
  final double? qiblaBearing;
  final double? distanceToKaabaKm;
  final String? locationDescription;
  final String? qiblaDirectionLabel;
  final bool usedFallbackPosition;
  final String? errorMessage;

  QiblaState copyWith({
    QiblaStatus? status,
    double? userLatitude,
    double? userLongitude,
    double? qiblaBearing,
    double? distanceToKaabaKm,
    String? locationDescription,
    String? qiblaDirectionLabel,
    bool? usedFallbackPosition,
    String? errorMessage,
  }) {
    return QiblaState(
      status: status ?? this.status,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      qiblaBearing: qiblaBearing ?? this.qiblaBearing,
      distanceToKaabaKm: distanceToKaabaKm ?? this.distanceToKaabaKm,
      locationDescription: locationDescription ?? this.locationDescription,
      qiblaDirectionLabel: qiblaDirectionLabel ?? this.qiblaDirectionLabel,
      usedFallbackPosition: usedFallbackPosition ?? this.usedFallbackPosition,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userLatitude,
        userLongitude,
        qiblaBearing,
        distanceToKaabaKm,
        locationDescription,
        qiblaDirectionLabel,
        usedFallbackPosition,
        errorMessage,
      ];
}
