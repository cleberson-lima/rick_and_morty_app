import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('texts with a value build the sentence', () {
    expect(AppStrings.pageNumber(3), 'Página 3');
    expect(AppStrings.themeTooltip('escuro'), 'Tema escuro');
    expect(AppStrings.seeAllOf('Personagens'), 'Ver todos: Personagens');
    expect(
      AppStrings.failureServerWithStatus(500),
      'O servidor respondeu com erro (500). Tente novamente.',
    );
    expect(
      AppStrings.noResultsOfType('personagem'),
      'Não encontramos nenhum personagem.',
    );
    expect(
      AppStrings.noResultsForQuery('personagem', 'xyz'),
      'Não existe personagem com o nome "xyz". '
      'Confira a grafia ou tente outro termo.',
    );
    expect(
      AppStrings.episodeCountOfCharacter(51),
      'Participou de 51 episódios',
    );
    expect(
      AppStrings.charactersInEpisode(19),
      '19 personagens participaram deste episódio',
    );
    expect(AppStrings.residentCount(27), '27 residentes');
  });

  test('resultCount uses the singular only for one', () {
    expect(AppStrings.resultCount(1), '1 resultado');
    expect(AppStrings.resultCount(0), '0 resultados');
    expect(AppStrings.resultCount(51), '51 resultados');
  });

  test('every resource type has a name and a plural', () {
    expect(AppStrings.resourceLabel(ResourceType.character), 'Personagem');
    expect(AppStrings.resourceLabel(ResourceType.episode), 'Episódio');
    expect(AppStrings.resourceLabel(ResourceType.location), 'Local');
    expect(
      AppStrings.resourcePluralLabel(ResourceType.character),
      'Personagens',
    );
    expect(AppStrings.resourcePluralLabel(ResourceType.episode), 'Episódios');
    expect(AppStrings.resourcePluralLabel(ResourceType.location), 'Locais');
  });

  test('the hero headline keeps its line break and trailing space', () {
    expect(AppStrings.homeHeadline, 'Saiba tudo em\num só ');
    expect(AppStrings.homeHeadlineHighlight, 'lugar.');
  });
}
