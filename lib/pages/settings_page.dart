import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/backup_service.dart';
import 'package:trackstudy/services/app_preferences.dart';
import 'package:trackstudy/services/external_file_service.dart';
import 'package:trackstudy/services/report_export_service.dart';
import 'package:trackstudy/theme/theme_controller.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.database});
  final AppDatabase database;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _busy = false;

  Future<T?> _busyRun<T>(Future<T> Function() action) async {
    setState(() => _busy = true);
    try {
      return await action();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível concluir: $error')));
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _createInternalBackup() async {
    final path = await _busyRun(() => BackupService(widget.database).createBackup());
    if (path != null) _message('Cópia de segurança interna criada.');
  }

  Future<void> _exportBackup() async {
    final path = await _busyRun(() => BackupService(widget.database).exportBackup());
    if (path != null) _message('Backup salvo fora do aplicativo.');
  }

  Future<void> _restoreFromFile() async {
    final service = BackupService(widget.database);
    final bytes = await _busyRun(service.pickBackupFile);
    if (bytes == null) return;
    BackupPreview preview;
    try {
      preview = service.preview(bytes);
    } catch (error) {
      _message('Arquivo inválido: $error');
      return;
    }
    if (!mounted) return;
    final created = preview.createdAt == null ? 'data desconhecida' : _dateTime(preview.createdAt!);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar este backup?'),
        content: Text(
          'Backup de $created\n\n'
          '${preview.disciplines} disciplinas\n'
          '${preview.activities} atividades\n'
          '${preview.sessions} sessões\n\n'
          'Os dados atuais serão substituídos. Antes disso, o TrackStudy criará automaticamente uma cópia interna de segurança e encerrará qualquer sessão ativa.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restaurar')),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await _busyRun(() async {
      await service.restoreBytes(bytes);
      return true;
    });
    if (ok == true) _message('Backup restaurado. A sessão ativa, se existia, foi encerrada.');
  }

  Future<void> _savePdf() async {
    final path = await _busyRun(() => ReportExportService(widget.database).savePdfExternally());
    if (path != null) _message('Relatório PDF salvo.');
  }

  Future<void> _sharePdf() async {
    final ok = await _busyRun(() async {
      await ReportExportService(widget.database).sharePdf();
      return true;
    });
    if (ok == true) _message('Relatório preparado para compartilhamento.');
  }

  Future<void> _shareBackup() async {
    final path = await _busyRun(() => BackupService(widget.database).createBackup());
    if (path == null) return;
    await _busyRun(() async {
      await ExternalFileService.sharePath(path, text: 'Backup do TrackStudy');
      return true;
    });
  }


  Future<void> _editStudyDays() async {
    final prefs = AppPreferences();
    final initial = await prefs.loadStudyWeekdays();
    if (!mounted) return;
    final selected = <int>{...initial};
    final result = await showDialog<Set<int>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Dias habituais de estudo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in const [
                (DateTime.monday, 'Segunda'),
                (DateTime.tuesday, 'Terça'),
                (DateTime.wednesday, 'Quarta'),
                (DateTime.thursday, 'Quinta'),
                (DateTime.friday, 'Sexta'),
                (DateTime.saturday, 'Sábado'),
                (DateTime.sunday, 'Domingo'),
              ])
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: selected.contains(entry.$1),
                  title: Text(entry.$2),
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        selected.add(entry.$1);
                      } else {
                        selected.remove(entry.$1);
                      }
                    });
                  },
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(
              onPressed: selected.isEmpty ? null : () => Navigator.pop(context, selected),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      await prefs.saveStudyWeekdays(result);
      _message('Dias de estudo atualizados. A prioridade passará a considerar essa rotina.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.of(context);
    return Scaffold(
      appBar: const AppHeaderBar(icon: Icons.settings_rounded, title: 'Configurações', subtitle: 'Preferências, segurança dos dados e exportação.'),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_busy) const LinearProgressIndicator(),
            Text('Aparência', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Column(children: [
                RadioListTile<ThemeMode>(title: const Text('Usar tema do sistema'), value: ThemeMode.system, groupValue: theme.themeMode, onChanged: (v) { if (v != null) theme.setThemeMode(v); }),
                RadioListTile<ThemeMode>(title: const Text('Tema claro'), value: ThemeMode.light, groupValue: theme.themeMode, onChanged: (v) { if (v != null) theme.setThemeMode(v); }),
                RadioListTile<ThemeMode>(title: const Text('Tema escuro'), value: ThemeMode.dark, groupValue: theme.themeMode, onChanged: (v) { if (v != null) theme.setThemeMode(v); }),
              ]),
            ),
            const SizedBox(height: 20),
            Text('Planejamento', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_view_week_rounded),
                title: const Text('Dias habituais de estudo'),
                subtitle: const Text('A prioridade distribui a meta pelos dias que você realmente costuma estudar.'),
                onTap: _editStudyDays,
              ),
            ),
            const SizedBox(height: 20),
            Text('Backup e restauração', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Column(children: [
                ListTile(leading: const Icon(Icons.save_alt_rounded), title: const Text('Salvar backup como arquivo'), subtitle: const Text('Escolha onde guardar uma cópia JSON fora do aplicativo.'), onTap: _exportBackup),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.share_rounded), title: const Text('Compartilhar backup'), subtitle: const Text('Envie para Drive, e-mail ou outro aplicativo.'), onTap: _shareBackup),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.restore_rounded), title: const Text('Restaurar de um arquivo'), subtitle: const Text('Escolha um backup e veja o conteúdo antes de restaurar.'), onTap: _restoreFromFile),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.security_rounded), title: const Text('Criar cópia interna de segurança'), subtitle: const Text('Útil antes de alterações; não substitui um backup externo.'), onTap: _createInternalBackup),
              ]),
            ),
            const SizedBox(height: 20),
            Text('Relatórios', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Column(children: [
                ListTile(leading: const Icon(Icons.picture_as_pdf_rounded), title: const Text('Salvar relatório PDF'), subtitle: const Text('Gera um relatório completo de todo o histórico.'), onTap: _savePdf),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.ios_share_rounded), title: const Text('Compartilhar relatório PDF'), subtitle: const Text('Compartilhe o PDF sem precisar localizar o diretório interno.'), onTap: _sharePdf),
              ]),
            ),
            const SizedBox(height: 16),
            const Text('Dica: mantenha pelo menos um backup externo. Arquivos internos podem ser removidos ao limpar os dados ou desinstalar o aplicativo.'),
          ],
        ),
      ),
    );
  }

  String _dateTime(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
