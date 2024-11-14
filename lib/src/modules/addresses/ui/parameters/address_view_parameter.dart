import 'package:equatable/equatable.dart';

class AddressViewParameter extends Equatable {
  final String? id;
  final String? postalCode;
  final String? address;
  final String? number;
  final String? complement;

  const AddressViewParameter({
    this.id,
    this.postalCode,
    this.address,
    this.number,
    this.complement,
  });

  Map<String, String> toQueryParameter() {
    return {
      if (id != null) 'id': id!,
      if (postalCode != null) 'postalCode': postalCode!,
      if (address != null) 'address': address!,
      if (number != null) 'number': number!,
      if (complement != null) 'complement': complement!,
    };
  }

  factory AddressViewParameter.fromQueryParameter(Map<String, String> map) {
    return AddressViewParameter(
      id: map['id'],
      postalCode: map['postalCode'],
      address: map['address'],
      number: map['number'],
      complement: map['complement'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        postalCode,
        address,
        number,
        complement,
      ];
}
