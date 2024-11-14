import 'package:flutter/material.dart';

class AddressListTile extends StatelessWidget {
  final VoidCallback? onTap;

  const AddressListTile({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      selected: true,
      title: const Text(
        '40170-115',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        'Avenida Anita Garibaldi - Ondin...' * 2,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
          fontSize: 18,
        ),
      ),
      leading: Icon(
        Icons.location_pin,
        color: Theme.of(context).primaryColor,
        size: 32,
      ),
    );
  }
}
