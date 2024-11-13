import 'package:flutter/material.dart';

import '../../../../shared/services/geolocator/domain/services/i_geolocator_service.dart';
import '../../../../shared/services/geolocator/ui/mixins/geolocator_store_mixin.dart';

class MapsStore extends ChangeNotifier with GeolocatorStoreMixin {
  @override
  final IGeolocatorService geolocatorService;

  MapsStore({
    required this.geolocatorService,
  });
}
