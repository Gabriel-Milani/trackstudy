import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/external_file_service.dart';
import 'package:trackstudy/services/statistics_service.dart';
import 'package:trackstudy/services/storage/file_storage.dart';

class ReportExportService {
  ReportExportService(this.database);

  final AppDatabase database;

  Future<String> exportPdf({DateTime? start, DateTime? end}) async {
    final bytes = await buildPdf(start: start, end: end);
    return writeAppFile(_fileName(start, end), bytes);
  }

  Future<String?> savePdfExternally({DateTime? start, DateTime? end}) async {
    final bytes = await buildPdf(start: start, end: end);
    return ExternalFileService.saveBytes(
      suggestedName: _fileName(start, end),
      bytes: bytes,
      allowedExtensions: const ['pdf'],
    );
  }

  Future<void> sharePdf({DateTime? start, DateTime? end}) async {
    final path = await exportPdf(start: start, end: end);
    await ExternalFileService.sharePath(
      path,
      text: 'Relatório de estudos do TrackStudy',
    );
  }

  Future<List<int>> buildPdf({DateTime? start, DateTime? end}) async {
    final statistics = await StatisticsService(database).getStatistics(
      start: start,
      end: end,
    );
    final sessions = start != null && end != null
        ? await database.studySessionsDao.getSessionsBetween(start, end)
        : await database.studySessionsDao.getAllStudySessions();
    final activitiesWithDiscipline = await database.activitiesDao.watchActivities().first;
    final activities = activitiesWithDiscipline.map((e) => e.activity).where((activity) {
      if (start == null || end == null) return true;
      return !activity.dueAt.isBefore(start) && activity.dueAt.isBefore(end);
    }).toList();

    final totalSeconds = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final largestSession = sessions.fold<int>(0, (max, s) => s.durationSeconds > max ? s.durationSeconds : max);
    final activeDays = sessions
        .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
        .toSet()
        .length;
    final averageDailySeconds = activeDays == 0 ? 0 : totalSeconds ~/ activeDays;
    final completedActivities = activities.where((a) => a.isCompleted).length;
    final pendingActivities = activities.length - completedActivities;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final overdueActivities = activities.where((a) {
      if (a.isCompleted) return false;
      final due = DateTime(a.dueAt.year, a.dueAt.month, a.dueAt.day);
      return due.isBefore(today);
    }).length;

    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (_) => [
          pw.Text(
            'TrackStudy - Relatório de Estudos',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(_periodLabel(start, end)),
          pw.Text('Gerado em ${_date(DateTime.now())}'),
          pw.SizedBox(height: 20),
          pw.Text('Resumo', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _metric('Tempo total', _duration(totalSeconds)),
              _metric('Sessões', '${sessions.length}'),
              _metric('Média por dia ativo', _duration(averageDailySeconds)),
              _metric('Maior sessão', _duration(largestSession)),
              _metric('Atividades concluídas', '$completedActivities'),
              _metric('Atividades pendentes', '$pendingActivities'),
              _metric('Atividades atrasadas', '$overdueActivities'),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Tempo por disciplina', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            children: [
              pw.TableRow(
                children: [
                  _cell('Disciplina', bold: true),
                  _cell('Meta semanal', bold: true),
                  _cell('Tempo', bold: true),
                ],
              ),
              for (final item in statistics)
                pw.TableRow(
                  children: [
                    _cell(item.discipline.name),
                    _cell('${item.discipline.weeklyGoalMinutes} min'),
                    _cell(_duration(item.totalSeconds)),
                  ],
                ),
            ],
          ),
          if (activities.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text('Atividades', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(children: [
                  _cell('Atividade', bold: true),
                  _cell('Prazo', bold: true),
                  _cell('Status', bold: true),
                ]),
                for (final activity in activities)
                  pw.TableRow(children: [
                    _cell(activity.title),
                    _cell(_date(activity.dueAt)),
                    _cell(activity.isCompleted ? 'Concluída' : 'Pendente'),
                  ]),
              ],
            ),
          ],
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _metric(String label, String value) => pw.Container(
        width: 150,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 2),
            pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );

  pw.Widget _cell(String text, {bool bold = false}) => pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text,
          style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
        ),
      );

  String _duration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds ~/ 60) % 60;
    return h > 0 ? '${h}h ${m}min' : '${m}min';
  }

  String _periodLabel(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Período: todo o histórico';
    final inclusiveEnd = end.subtract(const Duration(days: 1));
    return 'Período: ${_date(start)} a ${_date(inclusiveEnd)}';
  }

  String _fileName(DateTime? start, DateTime? end) {
    final now = DateTime.now();
    return 'trackstudy_relatorio_${now.year}${_two(now.month)}${_two(now.day)}_${_two(now.hour)}${_two(now.minute)}.pdf';
  }

  String _date(DateTime d) =>
      '${_two(d.day)}/${_two(d.month)}/${d.year}';

  String _two(int value) => value.toString().padLeft(2, '0');
}
