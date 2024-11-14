import 'package:flutter/material.dart';

import '../../../addresses/domain/dtos/address_dto.dart';

class AddressListTile extends StatelessWidget {
  final AddressDto address;
  final VoidCallback? onTap;

  const AddressListTile({
    super.key,
    required this.address,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      selected: true,
      title: Text(
        address.postalCode ?? '-',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        address.fullAddress(),
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
