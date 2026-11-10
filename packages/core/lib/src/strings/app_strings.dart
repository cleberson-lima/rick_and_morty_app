import '../types/resource_type.dart';

/// Every text shown on screen, in Portuguese (pt-BR).
///
/// Screens read them from here (`AppStrings.retry`) instead of writing the
/// text inline, so a wording change happens in one place. Texts with a value
/// inside are functions (`AppStrings.resultCount(51)`).
///
/// Material's own strings (e.g. the back button tooltip) come from
/// `flutter_localizations`, set to Portuguese in the `AppWidget`.
abstract final class AppStrings {
  // Comum.

  /// App name in the task switcher and the logo.
  static const appTitle = 'Rick and Morty';

  static const retry = 'Tentar novamente';

  /// Button that opens an item's details.
  static const learnMore = 'Saiba mais';

  /// Screen reader label of the loading skeleton.
  static const loading = 'Carregando';

  static const back = 'Voltar';

  static const backToHome = 'Voltar ao início';

  static const backToTop = 'Voltar ao topo';

  static const favoritesList = 'Lista de favoritos';

  static const clear = 'Limpar';

  static const previousPage = 'Página anterior';

  static const nextPage = 'Próxima página';

  static String pageNumber(int page) => 'Página $page';

  // Tema.

  static const themeDark = 'Escuro';

  static const themeLight = 'Claro';

  /// Tooltip of a theme option; mode is the lowercase option name.
  static String themeTooltip(String mode) => 'Tema $mode';

  static const switchToLightTheme = 'Tema claro';

  static const switchToDarkTheme = 'Tema escuro';

  // Tipos de recurso.

  static const resourceCharacter = 'Personagem';

  static const resourceCharacters = 'Personagens';

  static const resourceEpisode = 'Episódio';

  static const resourceEpisodes = 'Episódios';

  static const resourceLocation = 'Local';

  static const resourceLocations = 'Locais';

  // Falhas.

  static const failureTitleNetwork = 'Sem conexão';

  static const failureTitleTooManyRequests = 'Muitas requisições';

  static const failureTitleNotFound = 'Nada encontrado';

  static const failureTitleGeneric = 'Ops! Algo deu errado';

  static const failureNotFound = 'Nada encontrado.';

  static const failureNetwork =
      'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  static const failureTooManyRequests =
      'Muitas requisições em pouco tempo. Aguarde alguns segundos e tente novamente.';

  static const failureServer =
      'O servidor respondeu com erro. Tente novamente.';

  static String failureServerWithStatus(int status) =>
      'O servidor respondeu com erro ($status). Tente novamente.';

  static const failureCancelled = 'Requisição cancelada.';

  static const failureCache = 'Não foi possível acessar os dados salvos.';

  static const failureUnexpected = 'Algo deu errado. Tente novamente.';

  // Favoritos.

  static const favoritesTitle = 'Favoritos';

  static const favoritesEmptyTitle = 'Nenhum favorito ainda';

  static const favoritesEmptyMessage =
      'Toque no coração de um personagem, episódio ou local para salvá-lo aqui.';

  static const addToFavorites = 'Adicionar aos favoritos';

  static const removeFromFavorites = 'Remover dos favoritos';

  // Página inicial.

  /// Hero headline before the highlighted word; keep the trailing space.
  static const homeHeadline = 'Saiba tudo em\num só ';

  /// Highlighted (cyan) end of the hero headline.
  static const homeHeadlineHighlight = 'lugar.';

  static const homeSubtitle =
      'Personagens, localizações, episódios e muito mais.';

  /// Tagline of the dark theme (from the prototype).
  static const homeTaglineDark = 'Aí sim, Porr#@%&*';

  /// Tagline of the light theme (from the prototype).
  static const homeTaglineLight = 'Wubba Lubba Dub Dub! Cuidado com os olhos.';

  static const homeSectionCharacters = 'Personagens';

  static const homeSectionEpisodes = 'Episódios';

  static const homeSectionLocations = 'Localizações';

  static const seeAll = 'Ver todos';

  static String seeAllOf(String section) => 'Ver todos: $section';

  static const nothingHereShort = 'Nada por aqui.';

  // Busca.

  static const searchHint = 'Personagem, episódio, localização...';

  static const filterBy = 'Filtrar por:';

  static const noResultsTitle = 'Nenhum resultado';

  /// type is the lowercase resource name.
  static String noResultsOfType(String type) => 'Não encontramos nenhum $type.';

  /// type is the lowercase resource name.
  static String noResultsForQuery(String type, String query) =>
      'Não existe $type com o nome "$query". Confira a grafia ou tente outro termo.';

  static const emptyTitle = 'Nada por aqui';

  static const emptyMessage = 'A busca não retornou resultados.';

  /// "1 resultado", "51 resultados".
  static String resultCount(int count) =>
      count == 1 ? '1 resultado' : '$count resultados';

  // Detalhes.

  static const notFoundTitle = 'Não encontrado';

  static const notFoundMessage = 'Este item não existe ou foi removido da API.';

  static const moreCharacters = 'Mais personagens';

  static const moreEpisodes = 'Mais episódios';

  static const moreLocations = 'Mais localizações';

  static String episodeCountOfCharacter(int count) =>
      'Participou de $count episódios';

  static String charactersInEpisode(int count) =>
      '$count personagens participaram deste episódio';

  static String residentCount(int count) => '$count residentes';

  static const origin = 'Origem';

  static const lastLocation = 'Última localização';

  static const invalidLinkTitle = 'Link inválido';

  static const invalidLinkMessage = 'Não foi possível abrir este item.';

  // Personagem.

  static const statusAlive = 'Vivo';

  static const statusDead = 'Morto';

  static const statusUnknown = 'Desconhecido';

  static const speciesHuman = 'Humano';

  static const speciesAlien = 'Alienígena';

  static const speciesHumanoid = 'Humanoide';

  static const speciesRobot = 'Robô';

  static const speciesAnimal = 'Animal';

  static const speciesMythologicalCreature = 'Criatura mitológica';

  static const speciesDisease = 'Doença';

  static const speciesUnknown = 'Desconhecido';

  // Helpers.

  static String resourceLabel(ResourceType type) => switch (type) {
    ResourceType.character => resourceCharacter,
    ResourceType.episode => resourceEpisode,
    ResourceType.location => resourceLocation,
  };

  static String resourcePluralLabel(ResourceType type) => switch (type) {
    ResourceType.character => resourceCharacters,
    ResourceType.episode => resourceEpisodes,
    ResourceType.location => resourceLocations,
  };
}
