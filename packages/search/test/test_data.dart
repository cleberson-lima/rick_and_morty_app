import 'package:search/src/domain/entities/character.dart';

const rick = Character(
  id: 1,
  name: 'Rick Sanchez',
  status: CharacterStatus.alive,
  species: 'Human',
  type: '',
  gender: 'Male',
  originName: 'Earth (C-137)',
  locationName: 'Citadel of Ricks',
  imageUrl: 'https://example.test/1.jpeg',
  episodeCount: 51,
);

const morty = Character(
  id: 2,
  name: 'Morty Smith',
  status: CharacterStatus.alive,
  species: 'Human',
  type: '',
  gender: 'Male',
  originName: 'unknown',
  locationName: 'Citadel of Ricks',
  imageUrl: 'https://example.test/2.jpeg',
  episodeCount: 51,
);
