# Desafio Flutter - Doutor-IE

Aplicação Flutter responsiva (mobile e desktop/Windows) para autenticação e CRUD de livros utilizando a API fornecida.

## Funcionalidades
- Login com e-mail e senha e uso do Bearer Token nas demais requisições.
- Listagem de livros com ações de visualizar, editar e excluir.
- Visualização de livro com todos os índices e subíndices (aninhados).
- Cadastro/Edição de livro com índices e subíndices editáveis in-line.
- Exclusão com modal de confirmação.
- Layout responsivo com centralização e largura máxima para desktop.
- Gerenciamento de estado com flutter_bloc.
- Teste unitário simples para serialização do modelo.

## Endpoints
Base: definida via arquivo .env (variável `BASE_URL`). Exemplo: `http://18.231.37.245:8080/api/v1`
- POST `/auth/login` { email, senha }
- GET `/livros`
- POST `/livros`
- PUT `/livros/{id}`
- DELETE `/livros/{id}`

Os headers enviados incluem `Accept: application/json` e `Content-Type: application/json`. Após o login, o token é salvo via `shared_preferences` e adicionado como `Authorization: Bearer <token>`.

## Configuração (.env)
Crie um arquivo `.env` na raiz do projeto com o conteúdo abaixo (um arquivo de exemplo já está no repositório):

```
BASE_URL=http://18.231.37.245:8080/api/v1
```

Você pode alterar esse valor para apontar para diferentes ambientes (dev/homolog/produção) sem precisar modificar o código.

## Como rodar
1. Configure o Flutter (3.9+) e execute:
   - Mobile: `flutter run` (Android/iOS)
   - Windows: `flutter run -d windows`
2. Informe as credenciais de teste no login (enviadas com o desafio).
3. Após logado, utilize a tela de Livros para cadastrar/editar/excluir.

## Estrutura principal
- `lib/core/api_client.dart`: cliente HTTP e persistência do token.
- `lib/repositories/`: AuthRepository, BooksRepository (chamadas à API).
- `lib/bloc/`: AuthCubit, BooksCubit (estado de autenticação e livros).
- `lib/ui/`: páginas Login, Lista, Detalhe e Formulário.

## Testes
Execute `flutter test`.
