import 'package:flutter/material.dart';

import '../parameters/address_view_parameter.dart';

class AddressView extends StatelessWidget {
  final AddressViewParameter parameter;

  const AddressView({
    super.key,
    this.parameter = const AddressViewParameter(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Revisão'),
      ),
    );
  }
}
