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
  final double? latitude;
  final double? longitude;

  const AddressDto({
    this.street,
    this.city,
    this.state,
    this.neighborhood,
    this.country,
    this.postalCode,
    this.number,
    this.latitude,
    this.longitude,
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
      'latitude': latitude,
      'longitude': longitude,
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
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  factory AddressDto.fromQueryParameters(Map<String, String> queryParameters) {
    return AddressDto(
      street: queryParameters['street'],
      city: queryParameters['city'],
      state: queryParameters['state'],
      neighborhood: queryParameters['neighborhood'],
      country: queryParameters['country'],
      postalCode: queryParameters['postalCode'],
      number: queryParameters['number'],
      latitude: queryParameters['latitude'] == null
          ? null
          : double.parse(queryParameters['latitude']!),
      longitude: queryParameters['longitude'] == null
          ? null
          : double.parse(queryParameters['longitude']!),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressDto.fromJson(String source) =>
      AddressDto.fromMap(json.decode(source));

  AddressDto copyWith({
    String? street,
    String? city,
    String? state,
    String? neighborhood,
    String? country,
    String? postalCode,
    String? number,
    double? latitude,
    double? longitude,
  }) {
    return AddressDto(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      neighborhood: neighborhood ?? this.neighborhood,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      number: number ?? this.number,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        street,
        city,
        state,
        neighborhood,
        country,
        postalCode,
        number,
        latitude,
        longitude,
      ];
}
