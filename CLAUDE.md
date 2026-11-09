# Rick & Morty App — regras do projeto

## Stack
Flutter 3.41+, Dart 3.8+, Melos 8 (pub workspaces), flutter_modular, dio,
freezed 4 (freezed_annotation 3) + json_serializable, mocktail, flutter_bloc + bloc_concurrency + bloc_test,
shared_preferences, cached_network_image, google_fonts.

Versões fixadas de propósito (não atualizar sem testar):
- `flutter_modular: ^6.4.1` — a 7.x é outra API e seu `context.read/watch` conflita com o flutter_bloc.
  Em arquivos que importam os dois, use `import 'package:flutter_modular/flutter_modular.dart' hide ModularWatchExtension;`
- `google_fonts: 8.0.0` (versão exata no `core`) — a 9.x usa `material_ui`, com `TextTheme` incompatível com o do SDK.

## Testes
- Widget tests usam `AppTheme.light(useGoogleFonts: false)` (sem rede).
- O `LoadingSkeleton` anima para sempre: não use `pumpAndSettle` com ele na tela; faça `pump` em passos.
- Fixtures reais da API em `packages/search/test/fixtures/`; `FakeAdapter` (test/helpers.dart) exercita o Dio de verdade.

## Estrutura
- raiz do repositório — o app Flutter (`lib/`, `android/`, `ios/`): `main.dart`, `AppModule`, `AppWidget`
- `packages/core` — Dio client, `Result`, `Failure`, `ResourceType`, `PaginatedList`, tema, `ThemeCubit`, widgets em `lib/src/ui`
- `packages/favorites` — favoritos persistidos (shared_preferences)
- `packages/search` — busca de personagens, episódios e locais + tela de detalhe

## Arquitetura
- `packages/<feature>/lib/src/{data,presentation}` — sem camada `domain`: nada de entidades, use cases ou contratos de repositório
- `data/models`: uma classe freezed por recurso, com `@Freezed(fromJson: false, toJson: false)` e `factory X.fromJson` escrito à mão (models da API). A UI usa as models direto
- `data/search_api.dart` (`SearchApi`) e `data/favorites_storage.dart` (`FavoritesStorage`) fazem o acesso; a model nova entra passando o `X.fromJson` para `_search`/`_getById`
- API e storage retornam `Result<T>` (`Success(data)` / `Failed(failure)`, do `core`) e nunca lançam exceção; trate com `switch`, não com `try/catch`
- 404 da API vira `NotFoundFailure` → estado `notFound` (não é erro genérico)
- `Failure` não tem texto: os estados guardam o `Failure` e a UI usa `FailurePresentation` (`title`, `message`, `icon`) / `MessageView.failure` do `core`
- Estados de tela são sealed classes do freezed: loading, success, empty, notFound, error
- Cubit para carregar dados; Bloc só no `SearchBloc` (debounce/`restartable`/`droppable` pelos transformers de evento)
- O state fica em `x_state.dart` como `part of 'x_cubit.dart'` (eventos do Bloc idem); os imports ficam só na cubit e quem usa o state importa a cubit
- Cancelamento: o `SearchApi` cancela o `CancelToken` anterior do mesmo tipo a cada busca; o Bloc descarta resultados antigos. Telas que não podem se cancelar usam instâncias separadas do `SearchApi`

## Regras
- Todo código novo vem com teste (unit para data e Bloc/Cubit, widget para telas)
- Widgets reutilizáveis ficam em `packages/core/lib/src/ui`
- Use `const` sempre que possível; listas com `.builder`/slivers
- freezed 3+/4: classes `abstract class X with _$X` ou `sealed class X with _$X`
- Commits em Conventional Commits (inglês); uma branch `feature/*` por tarefa
- Arquivos gerados (`*.g.dart`, `*.freezed.dart`) são versionados

## Comandos
- `melos bootstrap`     # resolve o workspace
- `melos run gen`       # build_runner em todos os pacotes
- `melos run analyze`
- `melos run test`
- `melos run coverage`

## Antes de dizer que terminou
Rode analyze e test e mostre a saída.
