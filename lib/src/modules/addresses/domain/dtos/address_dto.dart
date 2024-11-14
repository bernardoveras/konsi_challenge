import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../shared/extensions/extensions.dart';

class AddressDto extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? neighborhood;
  final String? country;
  final String? postalCode;
  final String? number;

  const AddressDto({
    this.street,
    this.city,
    this.state,
    this.neighborhood,
    this.country,
    this.postalCode,
    this.number,
  });

  String fullAddress() {
    var address = '';

    if (street.isNotBlank) {
      if (address.isNotBlank) address += ', ';
      address += street!;
    }

    if (number.isNotBlank) {
      if (address.isNotBlank) address += ', ';
      address += number!;
    }

    if (city.isNotBlank) {
      if (address.isNotBlank) address += ', ';
      address += city!;
    }

    if (neighborhood.isNotBlank) {
      if (address.isNotBlank) address += ', ';
      address += neighborhood!;
    }

    if (state.isNotBlank) {
      if (address.isNotBlank) address += ', ';
      address += state!;
    }

    if (country.isNotBlank) {
      if (address.isNotBlank) address += ' - ';
      address += country!;
    }

    return address;
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'neighborhood': neighborhood,
      'country': country,
      'postalCode': postalCode,
      'number': number,
    };
  }

  factory AddressDto.fromMap(Map<String, dynamic> map) {
    return AddressDto(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      neighborhood: map['neighborhood'],
      country: map['country'],
      postalCode: map['postalCode'],
      number: map['number'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressDto.fromJson(String source) =>
      AddressDto.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        street,
        city,
        state,
        neighborhood,
        country,
        postalCode,
        number,
      ];
}
