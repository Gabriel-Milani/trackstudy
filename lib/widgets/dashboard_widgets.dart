import 'package:flutter/material.dart';
import 'package:trackstudy/database/daos/activities_dao.dart';
import 'package:trackstudy/theme/app_colors.dart';
import 'package:trackstudy/theme/app_text_styles.dart';
import 'package:trackstudy/theme/discipline_category.dart';

/// Texto que anima um número contando de 0 até [value] quando aparece na
/// tela, com [prefix] e [suffix] fixos (não animados) ao redor do número.
class AnimatedCountText extends StatelessWidget {
  const AnimatedCountText({
    super.key,
    required this.value,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 900),
  });

  final int value;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return Text('$prefix$animatedValue$suffix', style: style);
      },
    );
  }
}

/// Barra de progresso que anima do 0 até o valor final quando aparece na
/// tela, em vez de já surgir preenchida.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.valueColor,
    this.minHeight = 6,
    this.backgroundColor,
    this.borderRadius = 6,
  });

  final double value;
  final Color valueColor;
  final double minHeight;
  final Color? backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).dividerColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return LinearProgressIndicator(
            value: animatedValue,
            minHeight: minHeight,
            backgroundColor: bg,
            valueColor: AlwaysStoppedAnimation(valueColor),
          );
        },
      ),
    );
  }
}

/// Cabeçalho padrão: selo com gradiente + ícone, título em destaque e
/// subtítulo explicando a tela. Substitui o AppBar simples.
class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderBar({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actions,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final secondaryColor = brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return AppBar(
      titleSpacing: 12,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient(brightness),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: AppTextStyles.cardSubtitle(secondaryColor),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}

/// Botão circular "soft" (fundo tintado + ícone colorido).
class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.background,
    required this.iconColor,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// Card de destaque com gradiente, usado para a prioridade do momento.
class GradientHeroCard extends StatelessWidget {
  const GradientHeroCard({
    super.key,
    required this.disciplineName,
    required this.remainingMinutes,
    required this.goalMinutes,
    required this.progress,
    required this.onStudyPressed,
  });

  final String disciplineName;
  final int remainingMinutes;
  final int goalMinutes;
  final double progress;
  final VoidCallback onStudyPressed;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient(brightness),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  disciplineName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Faltam ',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              AnimatedCountText(
                value: remainingMinutes,
                suffix: ' min para a meta',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedProgressBar(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: Colors.white,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Meta semanal: ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
              AnimatedCountText(
                value: goalMinutes,
                suffix: ' min',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onStudyPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.gradientStart,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Estudar agora'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Um dos "pills" de estatística no resumo semanal. O número conta a
/// partir de 0 quando o card aparece.
class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.suffix = '',
  });

  final IconData icon;
  final String label;
  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLight),
          const SizedBox(height: 8),
          AnimatedCountText(
            value: value,
            suffix: suffix,
            style: AppTextStyles.statValue(textColor),
          ),
          Text(label, style: AppTextStyles.statLabel(secondaryColor)),
        ],
      ),
    );
  }
}

/// Gráfico de linha simples mostrando os minutos estudados em cada dia.
class WeeklyEvolutionChart extends StatelessWidget {
  const WeeklyEvolutionChart({super.key, required this.dailyMinutes});

  final List<int> dailyMinutes;

  static const _dayLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final lineColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.gradientStartDark
        : AppColors.gradientStart;
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Column(
      children: [
        SizedBox(
          height: 100,
          width: double.infinity,
          child: CustomPaint(
            painter: _LineChartPainter(dailyMinutes, lineColor),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _dayLabels
              .map((d) => Text(d, style: AppTextStyles.legenda(labelColor)))
              .toList(),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(this.values, this.color);

  final List<int> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue =
        (values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b)).clamp(
          1,
          double.infinity,
        );
    final stepX = size.width / (values.length - 1);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = color;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = size.height - (values[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = size.height - (values[i] / maxValue) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// Card de progresso de uma disciplina, com ícone e cor de acordo com a
/// categoria (Exatas, Tecnológicas, Humanas, Biológicas, Outras).
class DisciplineProgressCard extends StatelessWidget {
  const DisciplineProgressCard({
    super.key,
    required this.name,
    required this.studiedMinutes,
    required this.goalMinutes,
    required this.category,
    this.onTap,
  });

  final String name;
  final int studiedMinutes;
  final int goalMinutes;
  final DisciplineCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = goalMinutes == 0 ? 0.0 : studiedMinutes / goalMinutes;
    final bg = AppColors
        .disciplineBg[category.colorIndex % AppColors.disciplineBg.length];
    final fg = AppColors
        .disciplineFg[category.colorIndex % AppColors.disciplineFg.length];

    final String statusLabel;
    final Color statusColor;
    if (progress >= 1) {
      statusLabel = 'Meta concluída';
      statusColor = AppColors.success;
    } else if (progress >= 0.7) {
      statusLabel = 'No caminho certo';
      statusColor = fg;
    } else {
      statusLabel = 'Prioridade alta';
      statusColor = AppColors.alert;
    }

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: fg, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.cardTitle(textColor)),
                  const SizedBox(height: 2),
                  Text(
                    statusLabel,
                    style: AppTextStyles.cardSubtitle(statusColor),
                  ),
                  const SizedBox(height: 8),
                  AnimatedProgressBar(value: progress, valueColor: fg),
                  const SizedBox(height: 4),
                  Text(
                    '$studiedMinutes / $goalMinutes min',
                    style: AppTextStyles.cardSubtitle(secondaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botão do grid de "Ações rápidas".
class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.legenda(textColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mostrador do cronômetro: Horas / Minutos / Segundos em blocos separados.
class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key, required this.elapsed, required this.isLive});

  final Duration elapsed;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      child: Column(
        children: [
          if (isLive)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'AO VIVO',
                  style: AppTextStyles.legenda(AppColors.success),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TimeUnit(
                value: hours,
                label: 'Horas',
                color: textColor,
                secondaryColor: secondaryColor,
              ),
              _timeSeparator(textColor),
              _TimeUnit(
                value: minutes,
                label: 'Minutos',
                color: textColor,
                secondaryColor: secondaryColor,
              ),
              _timeSeparator(textColor),
              _TimeUnit(
                value: seconds,
                label: 'Segundos',
                color: textColor,
                secondaryColor: secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeSeparator(Color color) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Text(
      ':',
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: color),
    ),
  );
}

class _TimeUnit extends StatelessWidget {
  const _TimeUnit({
    required this.value,
    required this.label,
    required this.color,
    required this.secondaryColor,
  });

  final String value;
  final String label;
  final Color color;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.legenda(secondaryColor)),
        ],
      ),
    );
  }
}

/// Calendário de consistência (heatmap estilo GitHub) mostrando os minutos
/// estudados por dia nas últimas semanas.
class ConsistencyHeatmap extends StatelessWidget {
  const ConsistencyHeatmap({
    super.key,
    required this.dailyMinutes,
    this.weeks = 12,
  });

  final Map<DateTime, int> dailyMinutes;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);
    final endOfGrid = todayDay.add(Duration(days: 7 - todayDay.weekday));
    final startOfGrid = endOfGrid.subtract(Duration(days: weeks * 7 - 1));

    final maxMinutes = dailyMinutes.values.isEmpty
        ? 1
        : dailyMinutes.values.reduce((a, b) => a > b ? a : b);

    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppColors.gradientStartDark
        : AppColors.gradientStart;
    final emptyColor = Theme.of(context).dividerColor;
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    Color colorFor(int minutes) {
      if (minutes <= 0) return emptyColor;
      final intensity = (minutes / maxMinutes).clamp(0.0, 1.0);
      return Color.lerp(accent.withValues(alpha: 0.18), accent, intensity)!;
    }

    final columns = <Widget>[];
    for (var w = 0; w < weeks; w++) {
      final cells = <Widget>[];
      for (var d = 0; d < 7; d++) {
        final date = startOfGrid.add(Duration(days: w * 7 + d));
        final isFuture = date.isAfter(todayDay);
        final minutes = dailyMinutes[date] ?? 0;
        cells.add(
          Padding(
            padding: const EdgeInsets.all(1.5),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (w * 15)),
              curve: Curves.easeOut,
              builder: (context, value, _) => Opacity(
                opacity: isFuture ? 0 : value,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorFor(minutes),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      columns.add(Column(mainAxisSize: MainAxisSize.min, children: cells));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisSize: MainAxisSize.min, children: columns),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Menos', style: AppTextStyles.legenda(labelColor)),
            const SizedBox(width: 6),
            ...List.generate(4, (i) {
              final level = i / 3;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: level == 0
                        ? emptyColor
                        : Color.lerp(
                            accent.withValues(alpha: 0.18),
                            accent,
                            level,
                          ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
            const SizedBox(width: 6),
            Text('Mais', style: AppTextStyles.legenda(labelColor)),
          ],
        ),
      ],
    );
  }
}

/// Card de "Próximas atividades" na Home: mostra as próximas pendentes com
/// quantos dias faltam, ou uma mensagem de parabéns se não houver nenhuma.
class UpcomingActivitiesCard extends StatelessWidget {
  const UpcomingActivitiesCard({super.key, required this.activities});

  final List<ActivityWithDiscipline> activities;

  String _daysLabel(DateTime dueAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueAt.year, dueAt.month, dueAt.day);
    final diff = due.difference(today).inDays;
    if (diff < 0) return 'Atrasada há ${-diff} dia${-diff == 1 ? '' : 's'}';
    if (diff == 0) return 'Vence hoje';
    if (diff == 1) return 'Falta 1 dia';
    return 'Faltam $diff dias';
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      child: activities.isEmpty
          ? Row(
              children: [
                const Icon(Icons.celebration_rounded, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tudo feito! Parabéns.',
                    style: AppTextStyles.cardTitle(textColor),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < activities.length; i++) ...[
                  if (i > 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Divider(height: 1),
                    ),
                  _buildRow(context, activities[i], textColor, secondaryColor),
                ],
              ],
            ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    ActivityWithDiscipline item,
    Color textColor,
    Color secondaryColor,
  ) {
    final category = DisciplineCategory.fromKey(item.discipline.category);
    final bg = AppColors
        .disciplineBg[category.colorIndex % AppColors.disciplineBg.length];
    final fg = AppColors
        .disciplineFg[category.colorIndex % AppColors.disciplineFg.length];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      item.activity.dueAt.year,
      item.activity.dueAt.month,
      item.activity.dueAt.day,
    );
    final overdue = dueDay.isBefore(today);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(category.icon, color: fg, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.activity.title} • ${item.discipline.name}',
                style: AppTextStyles.cardTitle(textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _daysLabel(item.activity.dueAt),
                style: AppTextStyles.cardSubtitle(
                  overdue ? AppColors.alert : secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
