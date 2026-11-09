# Changelog

Todas as mudanças relevantes do app são registradas aqui.
O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o projeto usa [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Não lançado]

### Adicionado

- Fonte **Inter** empacotada no app (pesos 400, 500, 700 e 800): o texto aparece na fonte certa já no primeiro uso, mesmo offline. A licença da fonte (SIL OFL) aparece na página de licenças.
- Exceções inesperadas na API e no armazenamento local (por exemplo, JSON fora do formato esperado) passam a ser registradas no log do `dart:developer` em vez de sumirem como um erro genérico. O destino pode ser trocado em `Result.reportError`.

### Alterado

- O `google_fonts` saiu das dependências, junto com o parâmetro `useGoogleFonts` de `AppTheme.light()`/`AppTheme.dark()`.
- Arquitetura simplificada: as features passam a ter só `data` e `presentation`. Saíram as entidades, os use cases e os contratos de repositório; as telas e os Blocs/Cubits usam as models (`Character`, `Episode`, `Location`, `FavoriteItem`) direto.
- O acesso aos dados fica em uma classe por fonte: `SearchApi` (Rick and Morty API) e `FavoritesStorage` (`shared_preferences`). O formato salvo dos favoritos não mudou.
- O `Either` do `dartz` foi trocado por `Result<T>` (`Success` / `Failed`) do `core`, tratado com `switch`; o `dartz` saiu das dependências.
- Fluxo de branches com só a `main`: a `develop` deixa de existir, e o CI roda em PRs e pushes para a `main`.
- Nomes mais descritivos: `PageResult` → `PaginatedList`, `MoreItemsCubit` → `RelatedItemsCubit` (e `RelatedCharactersCubit`/`RelatedEpisodesCubit`/`RelatedLocationsCubit`), `StateView` → `MessageView`, `FavoritesDataModule`/`FavoritesModule` → `FavoritesBindingsModule`/`FavoritesRoutesModule`, a função de busca paginada passa a ser `SearchFunction<T>` e `package:core/domain.dart` → `package:core/types.dart`.
- As telas de erro agora variam com o tipo de falha: sem conexão e excesso de requisições têm título e ícone próprios, e o erro do servidor mostra o código de status.
- Os estados de tela (`SearchState`, `RelatedItemsState`, `DetailsState`, `FavoritesState`) guardam o `Failure` em vez da mensagem pronta. Os textos saíram do `Failure` (domínio) para a extensão `FailurePresentation` em `core/lib/src/ui`, e o `MessageView.failure` monta a tela de erro a partir dele.

## [0.1.0] - 2026-11-08

Primeira versão publicada.

### Adicionado

- Página inicial no layout do protótipo do Figma: topo com seletor de tema **Escuro / Claro**, busca única com filtros (**Personagens / Localizações / Episódios**) e seções com prévia de cada tipo e **Ver todos**.
- Busca por nome de **personagens, episódios e locais**, com debounce de 400 ms e cancelamento da requisição anterior.
- **Paginação** com scroll infinito e "tentar novamente" quando uma página falha.
- Estados de **carregamento** (skeleton), **erro** com nova tentativa, **vazio** e **não encontrado** (404 da API).
- Tela de **detalhes** carregada por tipo e id, acessível pela busca, pelos favoritos ou por link direto (`/details/:type/:id`). O personagem mostra cards de **origem** e **última localização** que abrem o local, e cada tela termina com uma seção **"Mais ..."** com paginação numerada.
- **Favoritos** salvos no aparelho: adicionar, listar e remover, com o coração sincronizado em todas as telas.
- Tema **claro/escuro** salvo entre aberturas do app, com as cores, a fonte (Inter) e os ícones (Phosphor) do protótipo, e cache de imagens em disco.
- Margem de segurança (**SafeArea**) no rodapé de todas as telas.
- Layout **responsivo**: lista no celular, grade de 2 a 4 colunas em tablet/paisagem e detalhes lado a lado em telas largas.
- Assinatura do APK de release via `key.properties`, com a chave de debug como alternativa no build local.
- Workflows do GitHub Actions: **CI** (formatação, análise, testes e cobertura mínima de 80%) e **release** (APK assinado anexado à release a cada tag `v*`).
- Relatório de cobertura unificado (`melos run coverage`): 91,3% das linhas, sem contar código gerado.

### Alterado

- As models da API estendem a classe abstrata `Model`, com `fromJson` escrito à mão e `toEntity()`. `Model.fromJson<T>` é a factory central, o que eliminou o código gerado dessas classes.
- Os states das cubits ficam em arquivos próprios (`x_state.dart`), declarados como `part` da cubit.

### Corrigido

- Erro **429** (limite de requisições da API) ao avançar rápido pelas últimas páginas de personagens: a requisição agora é repetida com espera crescente e, se ainda falhar, mostra uma mensagem própria.
- `ResultCard` estourava a altura em 4 px quando tinha subtítulo, legenda e rodapé ao mesmo tempo.

[Não lançado]: https://github.com/cleberson-lima/rick_and_morty_app/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/cleberson-lima/rick_and_morty_app/releases/tag/v0.1.0
