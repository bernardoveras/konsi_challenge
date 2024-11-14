import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../router/router.dart';

class ShellBottomNavigationBar extends StatefulWidget {
  final Widget child;

  const ShellBottomNavigationBar({
    super.key,
    required this.child,
  });

  @override
  State<ShellBottomNavigationBar> createState() =>
      _ShellBottomNavigationBarScaff();
}

class _ShellBottomNavigationBarScaff extends State<ShellBottomNavigationBar> {
  int currentIndex = 0;

  void changeTab(int value) {
    ScaffoldMessenger.of(context).clearSnackBars();

    switch (value) {
      case 0:
        context.go(Routes.root);
        break;
      case 1:
        context.go(Routes.addresses);
        break;
    }

    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeTab,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: currentIndex == 0
                  ? ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: Theme.of(context).primaryColor.withOpacity(0.08),
                    )
                  : null,
              child: const Icon(HugeIcons.strokeRoundedMapsGlobal01),
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: currentIndex == 1
                  ? ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: Theme.of(context).primaryColor.withOpacity(0.08),
                    )
                  : null,
              child: const Icon(HugeIcons.strokeRoundedTask01),
            ),
            label: 'Caderneta',
          ),
        ],
      ),
    );
  }
}
