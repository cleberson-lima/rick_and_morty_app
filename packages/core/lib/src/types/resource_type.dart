/// The three kinds of resource the Rick and Morty API exposes. Their names
/// on screen come from `AppLocalizations.resourceLabel`.
enum ResourceType {
  character,
  episode,
  location;

  static ResourceType? tryParse(String? value) {
    for (final type in values) {
      if (type.name == value) return type;
    }
    return null;
  }
}
