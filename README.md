# TrackStudy

Aplicativo para organizar a rotina de estudos, acompanhar o tempo dedicado a cada disciplina e ajudar na escolha do que estudar em seguida.

O TrackStudy está sendo desenvolvido como Trabalho de Conclusão de Curso de Análise e Desenvolvimento de Sistemas no IFSP — Câmpus Campinas. A proposta é reunir cronômetro, metas, histórico e planejamento em uma ferramenta simples, que funcione mesmo sem conexão com a internet.

## O que já funciona

- cadastro, edição e exclusão de disciplinas;
- definição de metas semanais em minutos;
- cronômetro vinculado a uma disciplina;
- pausa e retomada sem contabilizar o intervalo;
- modo Pomodoro com ciclos de 25 ou 50 minutos;
- observações sobre o conteúdo estudado;
- cadastro manual, edição e exclusão de sessões;
- histórico ordenado das sessões de estudo;
- atividades com prazo, estimativa de tempo e status de conclusão;
- lembretes de atividades próximas ou atrasadas dentro do aplicativo;
- relatórios por semana, mês, período completo ou intervalo personalizado;
- comparação do desempenho com as metas semanais;
- resumo da semana e comparação com a semana anterior;
- sugestões de estudo calculadas por prioridade.

Todos os dados ficam armazenados localmente em SQLite.

## Como funciona a prioridade

A sugestão inicial parte do tempo que ainda falta para alcançar a meta:

```text
score = (meta semanal - tempo estudado) / dias úteis restantes
```

O cálculo também considera atividades próximas e atrasadas. Quanto maior o déficit e mais urgente o prazo, maior a posição da disciplina na lista.

Metas já atingidas não geram prioridade positiva. Quando não existem mais dias úteis na semana, o aplicativo usa o déficit absoluto para evitar divisão por zero.

## Tecnologias

- Flutter e Dart;
- Drift;
- SQLite;
- drift_flutter;
- build_runner e drift_dev.

O desenvolvimento é voltado principalmente para Android. A aplicação não depende de backend, conta de usuário ou conexão com serviços externos.

## Organização do projeto

```text
lib/
├── database/
│   ├── daos/
│   ├── tables/
│   ├── app_database.dart
│   └── database_connection.dart
├── pages/
├── services/
└── main.dart
```

A comunicação entre as camadas segue um fluxo direto:

```text
Interface → Service → DAO → Drift → SQLite
```

Regras simples de cadastro e consulta podem acessar o DAO diretamente. Os services ficam responsáveis pelos cálculos de prioridade, estatísticas e resumo semanal.

## Executando o projeto

### Pré-requisitos

- Flutter compatível com Dart 3.11 ou superior;
- Android Studio ou Android SDK configurado;
- emulador Android ou aparelho com depuração USB habilitada.

Confira se o ambiente está pronto:

```bash
flutter doctor
```

Depois, na pasta do projeto:

```bash
flutter pub get
flutter run
```

## Gerando os arquivos do Drift

Os arquivos `.g.dart` são gerados automaticamente e não devem ser editados à mão. Depois de alterar uma tabela ou DAO, execute:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Verificações

Para rodar a análise estática e os testes:

```bash
flutter analyze
flutter test
```

Para gerar um APK de desenvolvimento:

```bash
flutter build apk --debug
```

## Próximos passos

- backup e restauração dos dados;
- exportação de relatórios;
- avaliação de usabilidade com estudantes.

## Autores

Carlos Eduardo Ruzene Nascimento  
Luís Gabriel Milani da Silva

Projeto desenvolvido no Instituto Federal de Educação, Ciência e Tecnologia de São Paulo — Câmpus Campinas, em 2026.
