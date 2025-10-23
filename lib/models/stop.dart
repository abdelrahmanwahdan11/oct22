import 'package:flutter/material.dart';

@immutable
class Stop {
  const Stop({
    required this.id,
    required this.code,
    required this.address,
    required this.pallets,
    required this.weightLb,
    required this.eta,
    required this.selected,
    this.lockedToCompartmentId,
  });

  final String id;
  final String code;
  final String address;
  final int pallets;
  final int weightLb;
  final String eta;
  final bool selected;
  final String? lockedToCompartmentId;

  Stop copyWith({
    String? id,
    String? code,
    String? address,
    int? pallets,
    int? weightLb,
    String? eta,
    bool? selected,
    String? lockedToCompartmentId,
  }) {
    return Stop(
      id: id ?? this.id,
      code: code ?? this.code,
      address: address ?? this.address,
      pallets: pallets ?? this.pallets,
      weightLb: weightLb ?? this.weightLb,
      eta: eta ?? this.eta,
      selected: selected ?? this.selected,
      lockedToCompartmentId: lockedToCompartmentId ?? this.lockedToCompartmentId,
    );
  }
}
