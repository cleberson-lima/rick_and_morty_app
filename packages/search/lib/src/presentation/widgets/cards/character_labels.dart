import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';

Color statusColor(CharacterStatus status) => switch (status) {
  CharacterStatus.alive => const Color(0xFF55CC44),
  CharacterStatus.dead => const Color(0xFFD63D2E),
  CharacterStatus.unknown => const Color(0xFF9E9E9E),
};

/// Name of [status] on screen.
String statusLabel(CharacterStatus status) => switch (status) {
  CharacterStatus.alive => AppStrings.statusAlive,
  CharacterStatus.dead => AppStrings.statusDead,
  CharacterStatus.unknown => AppStrings.statusUnknown,
};

/// The prototype shows species in Portuguese ("Humano"). Unknown values from
/// the API are shown as they come.
String speciesLabel(String species) => switch (species.toLowerCase()) {
  'human' => AppStrings.speciesHuman,
  'alien' => AppStrings.speciesAlien,
  'humanoid' => AppStrings.speciesHumanoid,
  'robot' => AppStrings.speciesRobot,
  'animal' => AppStrings.speciesAnimal,
  'mythological creature' => AppStrings.speciesMythologicalCreature,
  'disease' => AppStrings.speciesDisease,
  'unknown' => AppStrings.speciesUnknown,
  _ => species,
};
