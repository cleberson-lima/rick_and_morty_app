# Changelog

Todas as mudanças relevantes do app são registradas aqui.
O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o projeto usa [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Não lançado]

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

### Corrigido

- Erro **429** (limite de requisições da API) ao avançar rápido pelas últimas páginas de personagens: a requisição agora é repetida com espera crescente e, se ainda falhar, mostra uma mensagem própria.
- `ResultCard` estourava a altura em 4 px quando tinha subtítulo, legenda e rodapé ao mesmo tempo.

[Não lançado]: https://github.com/cleberson-lima/rick_and_morty_app/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/cleberson-lima/rick_and_morty_app/releases/tag/v0.1.0
