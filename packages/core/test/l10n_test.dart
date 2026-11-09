import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('pt'));

  testWidgets('context.l10n reads the registered localizations', (
    tester,
  ) async {
    late AppLocalizations found;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            found = context.l10n;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(found.retry, 'Tentar novamente');
    // Material's own strings follow the same locale.
    final material = MaterialLocalizations.of(
      tester.element(find.byType(SizedBox)),
    );
    expect(material.backButtonTooltip, 'Voltar');
  });

  testWidgets('context.l10n falls back to Portuguese without a delegate', (
    tester,
  ) async {
    late AppLocalizations found;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          found = context.l10n;
          return const SizedBox();
        },
      ),
    );

    expect(found.localeName, 'pt');
  });

  test('every resource type has a name and a plural', () {
    expect(l10n.resourceLabel(ResourceType.character), 'Personagem');
    expect(l10n.resourceLabel(ResourceType.episode), 'Episódio');
    expect(l10n.resourceLabel(ResourceType.location), 'Local');
    expect(l10n.resourcePluralLabel(ResourceType.character), 'Personagens');
    expect(l10n.resourcePluralLabel(ResourceType.episode), 'Episódios');
    expect(l10n.resourcePluralLabel(ResourceType.location), 'Locais');
  });

  test('plurals and placeholders', () {
    expect(l10n.resultCount(1), '1 resultado');
    expect(l10n.resultCount(51), '51 resultados');
    expect(l10n.pageNumber(3), 'Página 3');
    expect(
      l10n.noResultsForQuery('personagem', 'xyz'),
      'Não existe personagem com o nome "xyz". '
      'Confira a grafia ou tente outro termo.',
    );
  });
}
