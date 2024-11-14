import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../shared/di/di.dart';
import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/router/router.dart';
import '../../../../shared/ui/extensions/extensions.dart';
import '../../../../shared/ui/widgets/widgets.dart';
import '../../../../shared/utils/debouncer.dart';
import '../../../../shared/utils/utils.dart';
import '../../../addresses/domain/dtos/address_dto.dart';
import '../store/maps_store.dart';
import '../widgets/address_info_modal.dart';
import '../widgets/address_list_tile.dart';
import '../widgets/map_blur.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  late final MapsStore store;

  late final GoogleMapController _mapController;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  final searchDebouncer = Debouncer(milliseconds: 500);

  var markers = <MarkerId, Marker>{};

  final _kDefaultInitialPosition = const CameraPosition(
    target: LatLng(-23.5489, -46.6388),
    zoom: 19,
  );

  void clearMarkers() {
    if (markers.isEmpty) return;
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

      final address = result.getOrThrow().first;

      await setAddressMarker(address);

      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      await showAddressInfo(address);
    } finally {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> getAddressByText(String addressText) async {
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

      final result = await store.getAddressByText(addressText);

      if (!mounted) return;

      final displayed = result.displaySnackbarWhenError(context);

      if (displayed) return;

      final address = result.getOrThrow().first;

      await setAddressMarker(address);

      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      await showAddressInfo(address);
    } finally {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> setAddressMarker(AddressDto address) async {
    final markerId = MarkerId(address.hashCode.toString());
    final marker = Marker(
      markerId: markerId,
      position: LatLng(address.latitude!, address.longitude!),
      infoWindow: InfoWindow.noText,
      onTap: () => showAddressInfo(address),
    );

    setState(() {
      markers.clear();
      markers[markerId] = marker;
    });

    animateCameraToLocation(
      LatLngDto(
        latitude: address.latitude!,
        longitude: address.longitude!,
      ),
    ).ignore();
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
            searchController.clear();
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
      searchFocusNode.addListener(() => setState(() {}));
      getCurrentLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();

    searchController.dispose();
    searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      floatingActionButton: searchFocusNode.hasFocus
          ? SizedBox.square(
              dimension: 64,
              child: FloatingActionButton(
                onPressed: () {
                  hideKeyboard(context);
                  clearMarkers();

                  if (searchController.text.isEmpty) return;

                  getAddressByText(searchController.text);
                },
                child: const Icon(
                  Icons.search,
                  size: 32,
                ),
              ),
            )
          : null,
      body: GestureDetector(
        onTap: () {},
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: GoogleMap(
                    mapType: MapType.normal,
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
                            duration: const Duration(milliseconds: 250),
                            opacity: store.searchingCurrentLocation ? 1 : 0,
                            curve: Curves.easeInOut,
                            child: const MapBlur(),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          reverseDuration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.ease,
                          switchOutCurve: Curves.ease,
                          child: (store.addresses.isNotEmpty &&
                                      searchFocusNode.hasFocus) ||
                                  searchFocusNode.hasFocus &&
                                      store.searchingAddress
                              ? Container(
                                  key: const ValueKey('search_background'),
                                  color: Colors.white,
                                  width: double.infinity,
                                )
                              : const SizedBox.shrink(),
                        ),
                        Padding(
                          key: const ValueKey('address_search_bar'),
                          padding: EdgeInsets.only(
                            top: MediaQuery.paddingOf(context).top + 16,
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            children: [
                              SearchBar(
                                hintText: 'Buscar',
                                focusNode: searchFocusNode,
                                controller: searchController,
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.only(
                                    left: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) =>
                                    getAddressByText(searchController.text),
                                onChanged: (value) {
                                  if (value.isEmpty) return;
                                  if (value.length < 3) return;

                                  searchDebouncer.run(() {
                                    if (store.searchingAddress) return;
                                    store.getAddressByText(value);
                                  });
                                },
                                trailing: searchController.text.isNotEmpty ||
                                        searchFocusNode.hasFocus
                                    ? [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hideKeyboard(context);
                                              clearMarkers();
                                              searchController.clear();
                                              store.addresses.clear();
                                            });
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ]
                                    : null,
                                leading: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  reverseDuration:
                                      const Duration(milliseconds: 300),
                                  switchInCurve: Curves.ease,
                                  switchOutCurve: Curves.ease,
                                  child: searchFocusNode.hasFocus
                                      ? store.searchingAddress
                                          ? const CircularProgressIndicator()
                                          : ListView.separated(
                                              itemCount: store.addresses.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(),
                                              itemBuilder: (context, index) {
                                                final address =
                                                    store.addresses[index];

                                                return AddressListTile(
                                                  address: address,
                                                  onTap: () {
                                                    hideKeyboard(context);
                                                    setAddressMarker(address);
                                                    showAddressInfo(address);
                                                  },
                                                );
                                              },
                                            )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
