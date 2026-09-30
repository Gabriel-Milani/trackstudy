# TrackStudy — revisão consolidada

## Correções críticas

- Sessão ativa é persistida e recuperada após fechamento do app.
- Intervalos superiores a 4 horas são tratados como anormais e exigem decisão do usuário antes de serem contabilizados.
- Uma disciplina com sessão ativa não pode ser excluída.
- Restauração de backup limpa qualquer timer ativo para evitar referência a disciplina inexistente.
- Antes de restaurar, o estado atual é salvo em `trackstudy_pre_restore_backup.json`.
- Atividades com prazo no dia atual não são classificadas como atrasadas.
- Tempo estimado de atividade deve ser maior que zero.

## Cronômetro e Pomodoro

- Modo livre e modo Pomodoro.
- Foco, pausa curta, pausa longa e número de ciclos configuráveis.
- Pausas não contam como tempo estudado.
- Estado de fase/ciclo também é persistido.
- Notificações locais ao finalizar uma fase.
- Observações podem ser alteradas durante a sessão e são persistidas automaticamente.

## Prioridade

O cálculo agora combina:

- déficit da meta semanal;
- dias de estudo restantes configurados pelo usuário;
- urgência da atividade mais próxima;
- recência da última sessão daquela disciplina.

A Home apresenta os principais motivos da recomendação.

## Backup e restauração

- backup interno de segurança;
- salvar backup JSON em local escolhido pelo usuário;
- compartilhar backup;
- selecionar arquivo JSON para restauração;
- validar estrutura e versão;
- mostrar quantidade de disciplinas, atividades e sessões antes de confirmar.

## Relatórios

- PDF com tempo total, sessões, média por dia ativo, maior sessão e atividades;
- tabela de tempo por disciplina;
- exportação e compartilhamento;
- tela Relatórios exporta o período atualmente selecionado.

## Histórico

- filtro de período;
- filtro de disciplina;
- busca por disciplina ou anotação;
- agrupamento visual por dia.

## Observação de validação

Este ambiente não possui o SDK Flutter/Dart. Foram realizadas revisões estáticas de estrutura, referências e sintaxe básica, mas a etapa final deve incluir `flutter pub get`, `flutter analyze` e `flutter test` em um ambiente com Flutter instalado.
