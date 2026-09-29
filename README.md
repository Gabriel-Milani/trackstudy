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

## Evolução consolidada

A versão consolidada adiciona persistência do cronômetro, tema persistente, filtros no histórico, backup/restauração local, exportação PDF, correções de métricas e prazo, melhoria das validações e otimização das consultas do dashboard/prioridade. Consulte `MELHORIAS_IMPLEMENTADAS.md` para o detalhamento técnico.

## Atualizações da versão consolidada (2026-09)

A versão consolidada adiciona e revisa os seguintes fluxos:

- cronômetro persistente, com recuperação segura após fechar o aplicativo;
- detecção de sessões anormalmente longas para evitar registrar horas esquecidas por engano;
- Pomodoro completo com foco, pausa curta, pausa longa e ciclos configuráveis;
- notificações locais ao concluir foco e pausas;
- anotações editáveis durante a sessão e persistidas automaticamente;
- proteção contra exclusão de disciplina com sessão ativa;
- tema claro, escuro ou do sistema persistente;
- dias habituais de estudo configuráveis, usados pelo algoritmo de prioridade;
- prioridade considerando meta, prazo, tempo sem estudar e rotina semanal;
- explicação dos motivos da disciplina recomendada;
- busca, filtros e agrupamento por data no histórico;
- backup externo em JSON, compartilhamento e restauração por arquivo com pré-visualização;
- backup interno automático antes de uma restauração;
- relatório PDF ampliado, salvável/compartilhável e exportável pelo período selecionado na tela de relatórios.

### Dependências adicionais

Após baixar o projeto, execute:

```bash
flutter pub get
```

No Android 13 ou superior, o aplicativo solicita permissão para exibir as notificações do cronômetro.
