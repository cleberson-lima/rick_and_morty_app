import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';

Color statusColor(CharacterStatus status) => switch (status) {
  CharacterStatus.alive => const Color(0xFF55CC44),
  CharacterStatus.dead => const Color(0xFFD63D2E),
  CharacterStatus.unknown => const Color(0xFF9E9E9E),
};

/// Display names of character fields, from the app's strings.
extension CharacterLabels on AppLocalizations {
  String statusLabel(CharacterStatus status) => switch (status) {
    CharacterStatus.alive => statusAlive,
    CharacterStatus.dead => statusDead,
    CharacterStatus.unknown => statusUnknown,
  };

  /// The prototype shows species in Portuguese ("Humano"). Unknown values
  /// from the API are shown as they come.
  String speciesLabel(String species) => switch (species.toLowerCase()) {
    'human' => speciesHuman,
    'alien' => speciesAlien,
    'humanoid' => speciesHumanoid,
    'robot' => speciesRobot,
    'animal' => speciesAnimal,
    'mythological creature' => speciesMythologicalCreature,
    'disease' => speciesDisease,
    'unknown' => speciesUnknown,
    _ => species,
  };
}
