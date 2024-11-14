import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../shared/extensions/extensions.dart';

class AddressBookDto extends Equatable {
  final String id;
  final String postalCode;
  final String address;
  final String number;
  final String? complement;

  const AddressBookDto({
    required this.id,
    required this.postalCode,
    required this.address,
    required this.number,
    this.complement,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postalCode': postalCode,
      'address': address,
      'number': number.defaultIfEmpty('S\\N'),
      'complement': complement.nullIfEmpty(),
    };
  }

  factory AddressBookDto.fromMap(Map<String, dynamic> map) {
    return AddressBookDto(
      id: map['id'],
      postalCode: map['postalCode'],
      address: map['address'],
      number: map['number'],
      complement: map['complement'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressBookDto.fromJson(String source) =>
      AddressBookDto.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        id,
        postalCode,
        address,
        number,
        complement,
      ];
}
