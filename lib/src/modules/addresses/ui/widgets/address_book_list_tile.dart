import 'package:flutter/material.dart';

import '../../domain/dtos/address_book_dto.dart';

class AddressBookListTile extends StatelessWidget {
  final AddressBookDto addressBook;
  final VoidCallback? onTap;

  const AddressBookListTile({
    super.key,
    required this.addressBook,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        addressBook.postalCode,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        addressBook.address,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
          fontSize: 18,
        ),
      ),
      trailing: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.08),
        ),
        child: Icon(
          Icons.bookmark_rounded,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
