import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pt')];

  /// App name in the task switcher and the logo.
  ///
  /// In pt, this message translates to:
  /// **'Rick and Morty'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get retry;

  /// Button that opens an item's details.
  ///
  /// In pt, this message translates to:
  /// **'Saiba mais'**
  String get learnMore;

  /// Screen reader label of the loading skeleton.
  ///
  /// In pt, this message translates to:
  /// **'Carregando'**
  String get loading;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @backToHome.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao início'**
  String get backToHome;

  /// No description provided for @backToTop.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao topo'**
  String get backToTop;

  /// No description provided for @favoritesList.
  ///
  /// In pt, this message translates to:
  /// **'Lista de favoritos'**
  String get favoritesList;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @previousPage.
  ///
  /// In pt, this message translates to:
  /// **'Página anterior'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In pt, this message translates to:
  /// **'Próxima página'**
  String get nextPage;

  /// No description provided for @pageNumber.
  ///
  /// In pt, this message translates to:
  /// **'Página {page}'**
  String pageNumber(int page);

  /// No description provided for @themeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// Tooltip of a theme option; mode is the lowercase option name.
  ///
  /// In pt, this message translates to:
  /// **'Tema {mode}'**
  String themeTooltip(String mode);

  /// No description provided for @switchToLightTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema claro'**
  String get switchToLightTheme;

  /// No description provided for @switchToDarkTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema escuro'**
  String get switchToDarkTheme;

  /// No description provided for @resourceCharacter.
  ///
  /// In pt, this message translates to:
  /// **'Personagem'**
  String get resourceCharacter;

  /// No description provided for @resourceCharacters.
  ///
  /// In pt, this message translates to:
  /// **'Personagens'**
  String get resourceCharacters;

  /// No description provided for @resourceEpisode.
  ///
  /// In pt, this message translates to:
  /// **'Episódio'**
  String get resourceEpisode;

  /// No description provided for @resourceEpisodes.
  ///
  /// In pt, this message translates to:
  /// **'Episódios'**
  String get resourceEpisodes;

  /// No description provided for @resourceLocation.
  ///
  /// In pt, this message translates to:
  /// **'Local'**
  String get resourceLocation;

  /// No description provided for @resourceLocations.
  ///
  /// In pt, this message translates to:
  /// **'Locais'**
  String get resourceLocations;

  /// No description provided for @failureTitleNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão'**
  String get failureTitleNetwork;

  /// No description provided for @failureTitleTooManyRequests.
  ///
  /// In pt, this message translates to:
  /// **'Muitas requisições'**
  String get failureTitleTooManyRequests;

  /// No description provided for @failureTitleNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Nada encontrado'**
  String get failureTitleNotFound;

  /// No description provided for @failureTitleGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Ops! Algo deu errado'**
  String get failureTitleGeneric;

  /// No description provided for @failureNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Nada encontrado.'**
  String get failureNotFound;

  /// No description provided for @failureNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão com a internet. Verifique sua rede e tente novamente.'**
  String get failureNetwork;

  /// No description provided for @failureTooManyRequests.
  ///
  /// In pt, this message translates to:
  /// **'Muitas requisições em pouco tempo. Aguarde alguns segundos e tente novamente.'**
  String get failureTooManyRequests;

  /// No description provided for @failureServer.
  ///
  /// In pt, this message translates to:
  /// **'O servidor respondeu com erro. Tente novamente.'**
  String get failureServer;

  /// No description provided for @failureServerWithStatus.
  ///
  /// In pt, this message translates to:
  /// **'O servidor respondeu com erro ({status}). Tente novamente.'**
  String failureServerWithStatus(int status);

  /// No description provided for @failureCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Requisição cancelada.'**
  String get failureCancelled;

  /// No description provided for @failureCache.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível acessar os dados salvos.'**
  String get failureCache;

  /// No description provided for @failureUnexpected.
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado. Tente novamente.'**
  String get failureUnexpected;

  /// No description provided for @favoritesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Favoritos'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum favorito ainda'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In pt, this message translates to:
  /// **'Toque no coração de um personagem, episódio ou local para salvá-lo aqui.'**
  String get favoritesEmptyMessage;

  /// No description provided for @addToFavorites.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar aos favoritos'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In pt, this message translates to:
  /// **'Remover dos favoritos'**
  String get removeFromFavorites;

  /// Hero headline before the highlighted word; keep the trailing space.
  ///
  /// In pt, this message translates to:
  /// **'Saiba tudo em\num só '**
  String get homeHeadline;

  /// Highlighted (cyan) end of the hero headline.
  ///
  /// In pt, this message translates to:
  /// **'lugar.'**
  String get homeHeadlineHighlight;

  /// No description provided for @homeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Personagens, localizações, episódios e muito mais.'**
  String get homeSubtitle;

  /// Tagline of the dark theme (from the prototype).
  ///
  /// In pt, this message translates to:
  /// **'Aí sim, Porr#@%&*'**
  String get homeTaglineDark;

  /// Tagline of the light theme (from the prototype).
  ///
  /// In pt, this message translates to:
  /// **'Wubba Lubba Dub Dub! Cuidado com os olhos.'**
  String get homeTaglineLight;

  /// No description provided for @homeSectionCharacters.
  ///
  /// In pt, this message translates to:
  /// **'Personagens'**
  String get homeSectionCharacters;

  /// No description provided for @homeSectionEpisodes.
  ///
  /// In pt, this message translates to:
  /// **'Episódios'**
  String get homeSectionEpisodes;

  /// No description provided for @homeSectionLocations.
  ///
  /// In pt, this message translates to:
  /// **'Localizações'**
  String get homeSectionLocations;

  /// No description provided for @seeAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver todos'**
  String get seeAll;

  /// No description provided for @seeAllOf.
  ///
  /// In pt, this message translates to:
  /// **'Ver todos: {section}'**
  String seeAllOf(String section);

  /// No description provided for @nothingHereShort.
  ///
  /// In pt, this message translates to:
  /// **'Nada por aqui.'**
  String get nothingHereShort;

  /// No description provided for @searchHint.
  ///
  /// In pt, this message translates to:
  /// **'Personagem, episódio, localização...'**
  String get searchHint;

  /// No description provided for @filterBy.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar por:'**
  String get filterBy;

  /// No description provided for @noResultsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum resultado'**
  String get noResultsTitle;

  /// type is the lowercase resource name.
  ///
  /// In pt, this message translates to:
  /// **'Não encontramos nenhum {type}.'**
  String noResultsOfType(String type);

  /// type is the lowercase resource name.
  ///
  /// In pt, this message translates to:
  /// **'Não existe {type} com o nome \"{query}\". Confira a grafia ou tente outro termo.'**
  String noResultsForQuery(String type, String query);

  /// No description provided for @emptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nada por aqui'**
  String get emptyTitle;

  /// No description provided for @emptyMessage.
  ///
  /// In pt, this message translates to:
  /// **'A busca não retornou resultados.'**
  String get emptyMessage;

  /// No description provided for @resultCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 resultado} other{{count} resultados}}'**
  String resultCount(int count);

  /// No description provided for @notFoundTitle.
  ///
  /// In pt, this message translates to:
  /// **'Não encontrado'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In pt, this message translates to:
  /// **'Este item não existe ou foi removido da API.'**
  String get notFoundMessage;

  /// No description provided for @moreCharacters.
  ///
  /// In pt, this message translates to:
  /// **'Mais personagens'**
  String get moreCharacters;

  /// No description provided for @moreEpisodes.
  ///
  /// In pt, this message translates to:
  /// **'Mais episódios'**
  String get moreEpisodes;

  /// No description provided for @moreLocations.
  ///
  /// In pt, this message translates to:
  /// **'Mais localizações'**
  String get moreLocations;

  /// No description provided for @episodeCountOfCharacter.
  ///
  /// In pt, this message translates to:
  /// **'Participou de {count} episódios'**
  String episodeCountOfCharacter(int count);

  /// No description provided for @charactersInEpisode.
  ///
  /// In pt, this message translates to:
  /// **'{count} personagens participaram deste episódio'**
  String charactersInEpisode(int count);

  /// No description provided for @residentCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} residentes'**
  String residentCount(int count);

  /// No description provided for @origin.
  ///
  /// In pt, this message translates to:
  /// **'Origem'**
  String get origin;

  /// No description provided for @lastLocation.
  ///
  /// In pt, this message translates to:
  /// **'Última localização'**
  String get lastLocation;

  /// No description provided for @invalidLinkTitle.
  ///
  /// In pt, this message translates to:
  /// **'Link inválido'**
  String get invalidLinkTitle;

  /// No description provided for @invalidLinkMessage.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir este item.'**
  String get invalidLinkMessage;

  /// No description provided for @statusAlive.
  ///
  /// In pt, this message translates to:
  /// **'Vivo'**
  String get statusAlive;

  /// No description provided for @statusDead.
  ///
  /// In pt, this message translates to:
  /// **'Morto'**
  String get statusDead;

  /// No description provided for @statusUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Desconhecido'**
  String get statusUnknown;

  /// No description provided for @speciesHuman.
  ///
  /// In pt, this message translates to:
  /// **'Humano'**
  String get speciesHuman;

  /// No description provided for @speciesAlien.
  ///
  /// In pt, this message translates to:
  /// **'Alienígena'**
  String get speciesAlien;

  /// No description provided for @speciesHumanoid.
  ///
  /// In pt, this message translates to:
  /// **'Humanoide'**
  String get speciesHumanoid;

  /// No description provided for @speciesRobot.
  ///
  /// In pt, this message translates to:
  /// **'Robô'**
  String get speciesRobot;

  /// No description provided for @speciesAnimal.
  ///
  /// In pt, this message translates to:
  /// **'Animal'**
  String get speciesAnimal;

  /// No description provided for @speciesMythologicalCreature.
  ///
  /// In pt, this message translates to:
  /// **'Criatura mitológica'**
  String get speciesMythologicalCreature;

  /// No description provided for @speciesDisease.
  ///
  /// In pt, this message translates to:
  /// **'Doença'**
  String get speciesDisease;

  /// No description provided for @speciesUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Desconhecido'**
  String get speciesUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
