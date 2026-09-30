import 'package:flutter_test/flutter_test.dart';
import 'package:trackstudy/services/statistics_service.dart';

void main() {
  test('startOfMonth removes time and selects first day', () {
    expect(
      StatisticsService.startOfMonth(DateTime(2026, 8, 24, 15, 45)),
      DateTime(2026, 8),
    );
  });

  test('custom period end includes the complete selected day', () {
    expect(
      StatisticsService.exclusiveEndOfDay(DateTime(2026, 8, 24, 15, 45)),
      DateTime(2026, 8, 25),
    );
  });
}
