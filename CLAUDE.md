# Rick & Morty App — regras do projeto

## Stack
Flutter 3.41+, Dart 3.8+, Melos 8 (pub workspaces), go_router, dio,
freezed 4 (freezed_annotation 3) + json_serializable, mocktail, flutter_bloc + bloc_concurrency + bloc_test,
shared_preferences, cached_network_image. Fonte Inter empacotada em `packages/core/assets/fonts` (sem `google_fonts`).

Versões fixadas de propósito (não atualizar sem testar):
- `go_router: ^17.0.0` — a 18.x exige Flutter 3.44 / Dart 3.12, acima do mínimo do projeto.

## Testes
- Nos testes, compare com o texto literal ou com `AppStrings.chave`.
- Widget tests usam `AppTheme.light()`; a Inter não é carregada nos testes (usa a fonte de teste), a não ser via `FontLoader`.
- O `LoadingSkeleton` anima para sempre: não use `pumpAndSettle` com ele na tela; faça `pump` em passos.
- Fixtures reais da API em `packages/search/test/fixtures/`; `FakeAdapter` (test/helpers.dart) exercita o Dio de verdade.

## Estrutura
- raiz do repositório — o app Flutter (`lib/`, `android/`, `ios/`): `main.dart` e `AppWidget` (GoRouter + cubits globais); testes em `test/`
- `packages/core` — Dio client, `Result`, `Failure`, `ResourceType`, `PaginatedList`, `FavoriteItem`, tema, `ThemeCubit`, widgets em `lib/src/ui`
- `packages/favorites` — favoritos persistidos (shared_preferences)
- `packages/search` — busca de personagens, episódios e locais + tela de detalhe

## Arquitetura
- `packages/<feature>/lib/src/{data,presentation}` — sem camada `domain`: nada de entidades, use cases ou contratos de repositório
- `data/models`: uma classe freezed por recurso, com `@Freezed(fromJson: false, toJson: false)` e `factory X.fromJson` escrito à mão (models da API). A UI usa as models direto
- `data/search_api.dart` (`SearchApi`) e `data/favorites_storage.dart` (`FavoritesStorage`) fazem o acesso; a model nova entra passando o `X.fromJson` para `_search`/`_getById`
- API e storage retornam `Result<T>` (`Success(data)` / `Failed(failure)`, do `core`) e nunca lançam exceção; trate com `switch`, não com `try/catch`. Use `Result.guard`, que manda exceções inesperadas para `Result.reportError` (log por padrão)
- 404 da API vira `NotFoundFailure` → estado `notFound` (não é erro genérico)
- `Failure` não tem texto: os estados guardam o `Failure` e a UI usa `FailurePresentation` (`title`, `message`, `icon`) / `MessageView.failure` do `core`
- Nenhum texto de tela escrito direto no widget: todos ficam em `AppStrings` (`packages/core/lib/src/strings/app_strings.dart`), como `static const` (ou função, quando o texto tem um valor dentro), e as telas usam `AppStrings.chave`. Tipos e models não têm texto (`ResourceType`, `CharacterStatus`): use `AppStrings.resourceLabel(type)`, `statusLabel(status)`, `speciesLabel(species)`
- Estados de tela são sealed classes do freezed: loading, success, empty, notFound, error
- Sem container de DI: o `main()` cria o `CoreDependencies` (`preferences`, `dio`) e o passa às rotas de cada feature (`searchRoutes(core)`, `favoritesRoute()`). Cada tela cria seus Blocs/Cubits em `BlocProvider(create: ...)`, que os fecha; nunca `BlocProvider.value` com instância criada fora. Navegação com `context.push(AppRoutes...)`
- Cubit para carregar dados; Bloc só no `SearchBloc` (debounce/`restartable`/`droppable` pelos transformers de evento)
- O state fica em `x_state.dart` como `part of 'x_cubit.dart'` (eventos do Bloc idem); os imports ficam só na cubit e quem usa o state importa a cubit
- Features não dependem umas das outras (só do `core`). O coração de favorito entra como `FavoriteSlot(item: ...)`; o app liga o `FavoriteButtonProvider` do `favorites` na raiz. Nos testes do `search`, use `FakeFavorites().wrap(...)` (test/helpers.dart)
- Cache offline: o `Dio` do `CoreDependencies.load()` tem o `OfflineCacheInterceptor` (rede primeiro; cópia salva só quando a conexão falha). 404/429/5xx e cancelamentos nunca vêm do cache
- Cancelamento: o `SearchApi` cancela o `CancelToken` anterior do mesmo tipo a cada busca; o Bloc descarta resultados antigos. Telas que não podem se cancelar usam instâncias separadas do `SearchApi`

## Regras
- Todo código novo vem com teste (unit para data e Bloc/Cubit, widget para telas)
- Widgets reutilizáveis ficam em `packages/core/lib/src/ui`; os de uma feature ficam em `presentation/widgets/<tela>/` (`cards`, `home`, `search`, `details`), um widget público por arquivo, e as páginas só os montam
- Use `const` sempre que possível; listas com `.builder`/slivers
- freezed 3+/4: classes `abstract class X with _$X` ou `sealed class X with _$X`
- Commits em Conventional Commits (inglês); uma branch `feature/*` (ou `fix/*`) por tarefa, criada a partir da `main` e mesclada nela por PR. Não há `develop`
- Arquivos gerados (`*.g.dart`, `*.freezed.dart`) são versionados

## CI
- Actions fixadas pelo SHA do commit, com a versão em comentário (`uses: x/y@<sha> # vN.N.N`); o Dependabot abre um PR semanal agrupado. Nunca use `@vN` nem `@main`. Antes de mesclar uma versão principal nova de `setup-java`, `auth` ou `action-gh-release`, leia as notas: elas só rodam numa tag `v*`, então o CI do PR não as exercita
- Release: tag `v*` em um commit da `main`; o `release.yml` recusa tags fora dela

## Comandos
- `melos bootstrap`     # resolve o workspace
- `melos run gen`       # build_runner em todos os pacotes
- `melos run analyze`
- `melos run test`
- `melos run coverage`

## Antes de dizer que terminou
Rode analyze e test e mostre a saída.
