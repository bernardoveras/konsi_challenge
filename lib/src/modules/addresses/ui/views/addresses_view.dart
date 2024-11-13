import 'package:flutter/material.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
    );
  }
}
