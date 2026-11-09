import 'package:flutter/material.dart';

import '../../../data/models/models.dart';

Color statusColor(CharacterStatus status) => switch (status) {
  CharacterStatus.alive => const Color(0xFF55CC44),
  CharacterStatus.dead => const Color(0xFFD63D2E),
  CharacterStatus.unknown => const Color(0xFF9E9E9E),
};

/// The prototype shows species in Portuguese ("Humano"). Unknown values from
/// the API are shown as they come.
String speciesLabel(String species) => switch (species.toLowerCase()) {
  'human' => 'Humano',
  'alien' => 'Alienígena',
  'humanoid' => 'Humanoide',
  'robot' => 'Robô',
  'animal' => 'Animal',
  'mythological creature' => 'Criatura mitológica',
  'disease' => 'Doença',
  'unknown' => 'Desconhecido',
  _ => species,
};
