import 'package:counters/screens/counter_detail/history_entry_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDuration', () {
    test('returns seconds when under 60s', () {
      expect(formatDuration(const Duration(seconds: 0)), '0s');
      expect(formatDuration(const Duration(seconds: 1)), '1s');
      expect(formatDuration(const Duration(seconds: 59)), '59s');
    });

    test('returns minutes only when seconds remainder is zero', () {
      expect(formatDuration(const Duration(minutes: 1)), '1m');
      expect(formatDuration(const Duration(minutes: 45)), '45m');
    });

    test('returns minutes and seconds when remainder non-zero', () {
      expect(formatDuration(const Duration(minutes: 1, seconds: 30)), '1m 30s');
      expect(
          formatDuration(const Duration(minutes: 59, seconds: 1)), '59m 1s');
    });

    test('returns hours only when minute remainder is zero', () {
      expect(formatDuration(const Duration(hours: 1)), '1h');
      expect(formatDuration(const Duration(hours: 23)), '23h');
    });

    test('returns hours and minutes when remainder non-zero', () {
      expect(formatDuration(const Duration(hours: 3, minutes: 20)), '3h 20m');
      expect(formatDuration(const Duration(hours: 1, minutes: 1)), '1h 1m');
    });

    test('returns days only when hour remainder is zero', () {
      expect(formatDuration(const Duration(days: 1)), '1d');
      expect(formatDuration(const Duration(days: 7)), '7d');
    });

    test('returns days and hours when remainder non-zero', () {
      expect(formatDuration(const Duration(days: 2, hours: 5)), '2d 5h');
      expect(formatDuration(const Duration(days: 1, hours: 12)), '1d 12h');
    });

    test('works correctly with negative durations (abs)', () {
      expect(formatDuration(const Duration(seconds: -45)), '45s');
      expect(formatDuration(const Duration(hours: -3, minutes: -20)), '3h 20m');
    });
  });

  group('formatDiff', () {
    test('positive integer shows + prefix', () {
      expect(formatDiff(3.0), '+3');
      expect(formatDiff(100.0), '+100');
    });

    test('negative integer shows no + prefix', () {
      expect(formatDiff(-1.0), '-1');
      expect(formatDiff(-50.0), '-50');
    });

    test('zero is formatted with + prefix as integer', () {
      expect(formatDiff(0.0), '+0');
    });

    test('decimal values trim trailing zeros', () {
      expect(formatDiff(3.5), '+3.5');
      expect(formatDiff(-1.25), '-1.25');
      // 3.10 trimmed to 3.1
      expect(formatDiff(3.10), '+3.1');
    });

    test('values that round to integer are shown as integer', () {
      // 2.00 → 2 (exact integer test via modulo)
      expect(formatDiff(2.0), '+2');
    });

    test('small decimal values are handled', () {
      expect(formatDiff(0.5), '+0.5');
      expect(formatDiff(-0.25), '-0.25');
    });
  });
}
