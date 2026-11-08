import 'package:core/domain.dart';

import '../entities/character.dart';
import '../entities/episode.dart';
import '../entities/location.dart';

/// Contract for the Rick and Morty API. Implementations must cancel the
/// previous in-flight search of the same kind when a new one starts.
abstract interface class SearchRepository {
  Future<Either<Failure, PageResult<Character>>> searchCharacters(
    String name, {
    int page = 1,
  });

  Future<Either<Failure, PageResult<Episode>>> searchEpisodes(
    String name, {
    int page = 1,
  });

  Future<Either<Failure, PageResult<Location>>> searchLocations(
    String name, {
    int page = 1,
  });

  Future<Either<Failure, Character>> getCharacter(int id);

  Future<Either<Failure, Episode>> getEpisode(int id);

  Future<Either<Failure, Location>> getLocation(int id);
}
