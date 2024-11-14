import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/constants/asset_path.dart';
import '../../../../shared/di/di.dart';
import '../../../../shared/router/router.dart';
import '../../../../shared/services/geolocator/ui/stores/geolocator_store.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final GeolocatorStore geolocatorStore;

  Future<void> getCurrentLocation() async {
    try {
      await geolocatorStore.searchCurrentLocation();
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();

    geolocatorStore = Dependencies.resolve();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation().then((_) async {
        if (!mounted) return;

        context.go(Routes.root);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SizedBox.square(
          dimension: MediaQuery.sizeOf(context).width * 0.5,
          child: Image.asset(
            AssetPath.splashGif,
          ),
        ),
      ),
    );
  }
}
