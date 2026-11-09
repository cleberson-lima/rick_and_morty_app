// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Rick and Morty';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get learnMore => 'Saiba mais';

  @override
  String get loading => 'Carregando';

  @override
  String get back => 'Voltar';

  @override
  String get backToHome => 'Voltar ao início';

  @override
  String get backToTop => 'Voltar ao topo';

  @override
  String get favoritesList => 'Lista de favoritos';

  @override
  String get clear => 'Limpar';

  @override
  String get previousPage => 'Página anterior';

  @override
  String get nextPage => 'Próxima página';

  @override
  String pageNumber(int page) {
    return 'Página $page';
  }

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String themeTooltip(String mode) {
    return 'Tema $mode';
  }

  @override
  String get switchToLightTheme => 'Tema claro';

  @override
  String get switchToDarkTheme => 'Tema escuro';

  @override
  String get resourceCharacter => 'Personagem';

  @override
  String get resourceCharacters => 'Personagens';

  @override
  String get resourceEpisode => 'Episódio';

  @override
  String get resourceEpisodes => 'Episódios';

  @override
  String get resourceLocation => 'Local';

  @override
  String get resourceLocations => 'Locais';

  @override
  String get failureTitleNetwork => 'Sem conexão';

  @override
  String get failureTitleTooManyRequests => 'Muitas requisições';

  @override
  String get failureTitleNotFound => 'Nada encontrado';

  @override
  String get failureTitleGeneric => 'Ops! Algo deu errado';

  @override
  String get failureNotFound => 'Nada encontrado.';

  @override
  String get failureNetwork =>
      'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String get failureTooManyRequests =>
      'Muitas requisições em pouco tempo. Aguarde alguns segundos e tente novamente.';

  @override
  String get failureServer => 'O servidor respondeu com erro. Tente novamente.';

  @override
  String failureServerWithStatus(int status) {
    return 'O servidor respondeu com erro ($status). Tente novamente.';
  }

  @override
  String get failureCancelled => 'Requisição cancelada.';

  @override
  String get failureCache => 'Não foi possível acessar os dados salvos.';

  @override
  String get failureUnexpected => 'Algo deu errado. Tente novamente.';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmptyTitle => 'Nenhum favorito ainda';

  @override
  String get favoritesEmptyMessage =>
      'Toque no coração de um personagem, episódio ou local para salvá-lo aqui.';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get homeHeadline => 'Saiba tudo em\num só ';

  @override
  String get homeHeadlineHighlight => 'lugar.';

  @override
  String get homeSubtitle =>
      'Personagens, localizações, episódios e muito mais.';

  @override
  String get homeTaglineDark => 'Aí sim, Porr#@%&*';

  @override
  String get homeTaglineLight => 'Wubba Lubba Dub Dub! Cuidado com os olhos.';

  @override
  String get homeSectionCharacters => 'Personagens';

  @override
  String get homeSectionEpisodes => 'Episódios';

  @override
  String get homeSectionLocations => 'Localizações';

  @override
  String get seeAll => 'Ver todos';

  @override
  String seeAllOf(String section) {
    return 'Ver todos: $section';
  }

  @override
  String get nothingHereShort => 'Nada por aqui.';

  @override
  String get searchHint => 'Personagem, episódio, localização...';

  @override
  String get filterBy => 'Filtrar por:';

  @override
  String get noResultsTitle => 'Nenhum resultado';

  @override
  String noResultsOfType(String type) {
    return 'Não encontramos nenhum $type.';
  }

  @override
  String noResultsForQuery(String type, String query) {
    return 'Não existe $type com o nome \"$query\". Confira a grafia ou tente outro termo.';
  }

  @override
  String get emptyTitle => 'Nada por aqui';

  @override
  String get emptyMessage => 'A busca não retornou resultados.';

  @override
  String resultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados',
      one: '1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get notFoundTitle => 'Não encontrado';

  @override
  String get notFoundMessage => 'Este item não existe ou foi removido da API.';

  @override
  String get moreCharacters => 'Mais personagens';

  @override
  String get moreEpisodes => 'Mais episódios';

  @override
  String get moreLocations => 'Mais localizações';

  @override
  String episodeCountOfCharacter(int count) {
    return 'Participou de $count episódios';
  }

  @override
  String charactersInEpisode(int count) {
    return '$count personagens participaram deste episódio';
  }

  @override
  String residentCount(int count) {
    return '$count residentes';
  }

  @override
  String get origin => 'Origem';

  @override
  String get lastLocation => 'Última localização';

  @override
  String get invalidLinkTitle => 'Link inválido';

  @override
  String get invalidLinkMessage => 'Não foi possível abrir este item.';

  @override
  String get statusAlive => 'Vivo';

  @override
  String get statusDead => 'Morto';

  @override
  String get statusUnknown => 'Desconhecido';

  @override
  String get speciesHuman => 'Humano';

  @override
  String get speciesAlien => 'Alienígena';

  @override
  String get speciesHumanoid => 'Humanoide';

  @override
  String get speciesRobot => 'Robô';

  @override
  String get speciesAnimal => 'Animal';

  @override
  String get speciesMythologicalCreature => 'Criatura mitológica';

  @override
  String get speciesDisease => 'Doença';

  @override
  String get speciesUnknown => 'Desconhecido';
}
