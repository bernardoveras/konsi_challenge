import 'package:flutter/material.dart';

import '../../../../shared/extensions/extensions.dart';
import '../../../addresses/domain/dtos/address_dto.dart';

class AddressInfoModal extends StatelessWidget {
  const AddressInfoModal({
    super.key,
    required this.address,
    this.onSubmit,
  });

  final AddressDto address;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.paddingOf(context).bottom + 24,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 6,
              width: MediaQuery.sizeOf(context).width * 0.10,
              decoration: ShapeDecoration(
                color: Colors.grey.shade400,
                shape: const StadiumBorder(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (address.postalCode.isNotBlank) ...[
                    Text(
                      address.postalCode!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    address.fullAddress(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSubmit,
              child: const Text('Salvar endereço'),
            ),
          ),
        ],
      ),
    );
  }
}
