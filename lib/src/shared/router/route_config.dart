import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/addresses/ui/parameters/address_view_parameter.dart';
import '../../modules/addresses/ui/views/address_view.dart';
import '../../modules/addresses/ui/views/addresses_view.dart';
import '../../modules/maps/ui/views/maps_view.dart';
import '../ui/widgets/shell_bottom_navigation_bar.dart';
import 'routes.dart';

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'appRouterKey');
final _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'appRouterKey');

abstract class RouteConfig {
  static GoRouter config = GoRouter(
    routes: routes,
    initialLocation: Routes.root,
    navigatorKey: navigatorKey,
  );

  static List<RouteBase> get routes => [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) =>
              ShellBottomNavigationBar(child: child),
          routes: [
            GoRoute(
              path: Routes.root,
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const MapsView(),
            ),
            GoRoute(
              path: Routes.addresses,
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const AddressesView(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: navigatorKey,
                  builder: (context, state) => AddressView(
                    parameter: state.uri.queryParameters.isEmpty
                        ? null
                        : AddressViewParameter.fromQueryParameter(
                            state.uri.queryParameters,
                          ),
                  ),
                ),
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: navigatorKey,
                  builder: (context, state) => AddressView(
                    editMode: true,
                    parameter: state.uri.queryParameters.isEmpty
                        ? null
                        : AddressViewParameter.fromQueryParameter(
                            state.uri.queryParameters,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ];
}
