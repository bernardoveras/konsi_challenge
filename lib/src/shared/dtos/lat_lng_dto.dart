import 'package:equatable/equatable.dart';

class LatLngDto extends Equatable {
  final double latitude;
  final double longitude;

  const LatLngDto({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
      ];
}
