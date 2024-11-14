import 'dart:convert';

import 'package:equatable/equatable.dart';

class CepLocatorDto extends Equatable {
  final String? cep;
  final String? street;
  final String? neighborhood;
  final String? city;
  final String? state;
  final String? complement;

  const CepLocatorDto({
    this.cep,
    this.street,
    this.neighborhood,
    this.city,
    this.state,
    this.complement,
  });

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': street,
      'bairro': neighborhood,
      'localidade': city,
      'uf': state,
      'complemento': complement,
    };
  }

  factory CepLocatorDto.fromMap(Map<String, dynamic> map) {
    return CepLocatorDto(
      cep: map['cep'],
      street: map['logradouro'],
      neighborhood: map['bairro'],
      city: map['localidade'],
      state: map['uf'],
      complement: map['complemento'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CepLocatorDto.fromJson(String source) =>
      CepLocatorDto.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        cep,
        street,
        neighborhood,
        city,
        state,
        complement,
      ];
}
