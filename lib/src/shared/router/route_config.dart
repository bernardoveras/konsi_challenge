import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/addresses/domain/dtos/address_dto.dart';
import '../../modules/addresses/ui/views/address_view.dart';
import '../../modules/addresses/ui/views/addresses_view.dart';
import '../../modules/maps/ui/views/maps_view.dart';
import 'routes.dart';

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'appRouterKey');

abstract class RouteConfig {
  static GoRouter config = GoRouter(
    routes: routes,
    initialLocation: Routes.root,
    navigatorKey: navigatorKey,
  );

  static List<GoRoute> get routes => [
        GoRoute(
          path: Routes.root,
          builder: (context, state) => const MapsView(),
        ),
        GoRoute(
          path: Routes.addresses,
          builder: (context, state) => const AddressesView(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const AddressView(),
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) => AddressView(
                address: state.uri.queryParameters.isEmpty
                    ? null
                    : AddressDto.fromQueryParameters(state.uri.queryParameters),
              ),
            ),
          ],
        ),
      ];
}
