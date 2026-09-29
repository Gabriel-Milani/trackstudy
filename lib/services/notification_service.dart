import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings();
      const settings = InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      );
      await _plugin.initialize(settings);
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      _initialized = true;
    } catch (_) {
      // Notificações são complementares: uma falha de plataforma não pode
      // impedir o cronômetro de funcionar.
    }
  }

  Future<void> showFocusComplete({required String discipline}) async {
    await initialize();
    if (!_initialized) return;
    await _plugin.show(
      1001,
      'Sessão de foco concluída',
      '$discipline: hora de fazer uma pausa.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trackstudy_focus',
          'Sessões de foco',
          channelDescription: 'Avisos do cronômetro e ciclos de foco.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showBreakComplete() async {
    await initialize();
    if (!_initialized) return;
    await _plugin.show(
      1002,
      'Pausa concluída',
      'Seu próximo ciclo de foco já pode começar.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trackstudy_focus',
          'Sessões de foco',
          channelDescription: 'Avisos do cronômetro e ciclos de foco.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
