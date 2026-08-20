import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;

  DateTime? _startedAt;

  Duration _elapsed = Duration.zero;

  bool _isRunning = false;

  void _startTimer() {
    _startedAt = DateTime.now();

    setState(() {
      _isRunning = true;
      _elapsed = Duration.zero;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_startedAt == null) return;

        setState(() {
          _elapsed = DateTime.now().difference(_startedAt!);
        });
      },
    );
  }

  void _stopTimer() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');

    final minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronômetro'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDuration(_elapsed),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            FilledButton(
              onPressed: _isRunning ? _stopTimer : _startTimer,
              child: Text(
                _isRunning ? 'Parar' : 'Iniciar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}