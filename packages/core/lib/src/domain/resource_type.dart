/// The three kinds of resource the Rick and Morty API exposes.
enum ResourceType {
  character('Personagem', 'Personagens'),
  episode('Episódio', 'Episódios'),
  location('Local', 'Locais');

  const ResourceType(this.label, this.pluralLabel);

  final String label;
  final String pluralLabel;

  static ResourceType? tryParse(String? value) {
    for (final type in values) {
      if (type.name == value) return type;
    }
    return null;
  }
}
