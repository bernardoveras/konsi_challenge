import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../shared/di/di.dart';
import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/router/router.dart';
import '../../../../shared/ui/extensions/extensions.dart';
import '../../../../shared/ui/widgets/widgets.dart';
import '../../../addresses/domain/dtos/address_dto.dart';
import '../store/maps_store.dart';
import '../widgets/address_info_modal.dart';
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

  void clearMarkers() {
    setState(() => markers.clear());
  }

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
    try {
      if (store.searchingAddress) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const LoadingModal(
          description: 'Buscando endereço...',
        ),
      ).ignore();

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
        infoWindow: InfoWindow.noText,
        onTap: () => showAddressInfo(address),
      );

      setState(() {
        markers.clear();
        markers[markerId] = marker;
      });

      animateCameraToLocation(latLng).ignore();

      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      await showAddressInfo(address);
    } finally {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> showAddressInfo(AddressDto address) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddressInfoModal(
          address: address,
          onSubmit: () async {
            context.pop();
            
            final result = await context.push(
              Routes.editAddress(address: address),
            );

            if (result != true) return;

            clearMarkers();
          },
        );
      },
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const LoadingModal(
          description: 'Obtendo a sua localização atual...',
        ),
      ).ignore();

      final result = await store.searchCurrentLocation();

      if (result.isError()) return;

      final latLng = result.getOrThrow();

      animateCameraToLocation(latLng);
    } finally {
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    store = MapsStore(
      geolocatorService: Dependencies.resolve(),
      addressService: Dependencies.resolve(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: _kDefaultInitialPosition,
                  onTap: getAddressByLocation,
                  markers: markers.values.toSet(),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
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
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
