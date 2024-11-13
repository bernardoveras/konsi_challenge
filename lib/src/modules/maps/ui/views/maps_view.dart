import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../shared/di/di.dart';
import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/ui/extensions/result_snackbar_extension.dart';
import '../../../../shared/ui/widgets/indicators/indicators.dart';
import '../store/maps_store.dart';
import '../widgets/map_blur.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  late final MapsStore store;

  late final GoogleMapController _mapController;

  var markers = <MarkerId, Marker>{};

  final _kDefaultInitialPosition = const CameraPosition(
    target: LatLng(-23.5489, -46.6388),
    zoom: 19,
  );

  Future<void> animateCameraToLocation(LatLngDto location) {
    final cameraPosition = CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 19,
    );

    return _mapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  Future<void> getAddressByLocation(LatLng location) async {
    //TODO: Exibir modal bottom sheet de carregamento enquanto busca o endereço.
    if (store.searchingAddress) return;

    final latLng = LatLngDto(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    final result = await store.getAddressByLocation(latLng);

    if (!mounted) return;

    final displayed = result.displaySnackbarWhenError(context);

    if (displayed) return;

    final address = result.getOrThrow();

    final markerId = MarkerId(address.hashCode.toString());
    final marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(
        title: 'Endereço',
        snippet: address.fullAddress(),
      ),
    );

    setState(() {
      markers.clear();
      markers[markerId] = marker;
    });

    animateCameraToLocation(latLng).ignore();

    await Future.delayed(const Duration(milliseconds: 250));

    _mapController.showMarkerInfoWindow(markerId);
  }

  @override
  void initState() {
    super.initState();

    store = MapsStore(
      geolocatorService: Dependencies.resolve(),
      addressService: Dependencies.resolve(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.searchCurrentLocation().then((result) {
        if (result.isError()) return;

        final latLng = result.getOrThrow();

        animateCameraToLocation(latLng);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kDefaultInitialPosition,
            onTap: getAddressByLocation,
            markers: markers.values.toSet(),
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          ListenableBuilder(
            listenable: store,
            builder: (context, child) {
              return Stack(
                children: [
                  IgnorePointer(
                    ignoring: !store.searchingCurrentLocation,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: store.searchingCurrentLocation ? 1 : 0,
                      curve: Curves.easeInOut,
                      child: const MapBlur(),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    reverseDuration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.ease,
                    switchOutCurve: Curves.ease,
                    child:
                        store.searchingCurrentLocation || store.searchingAddress
                            ? const Center(
                                key: ValueKey('search_progress_indicator'),
                                child: SquareCircleProgressIndicator(),
                              )
                            : const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
