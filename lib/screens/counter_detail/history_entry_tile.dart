import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';

final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

/// Formats a [Duration] as a human-readable string (e.g. "3h 20m", "45s").
String formatDuration(Duration d) {
  final abs = d.abs();
  if (abs.inSeconds < 60) return '${abs.inSeconds}s';
  if (abs.inMinutes < 60) {
    final m = abs.inMinutes;
    final s = abs.inSeconds % 60;
    return s > 0 ? '${m}m ${s}s' : '${m}m';
  }
  if (abs.inHours < 24) {
    final h = abs.inHours;
    final m = abs.inMinutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }
  final days = abs.inDays;
  final h = abs.inHours % 24;
  return h > 0 ? '${days}d ${h}h' : '${days}d';
}

/// Formats a numeric diff value with sign, trimming unnecessary decimals.
/// Returns e.g. "+3", "-1.5", "+0.25". Returns null if either value is null
/// or the result is not finite (NaN / Infinity).
String? formatDiff(double? currentNum, double? prevNum) {
  if (currentNum == null || prevNum == null) return null;
  final diff = currentNum - prevNum;
  if (!diff.isFinite) return null;
  final sign = diff >= 0 ? '+' : '';
  if (diff % 1 == 0) {
    return '$sign${diff.toInt()}';
  }
  final str = diff.toStringAsFixed(2);
  final trimmed =
      str.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  return '$sign$trimmed';
}

/// Returns the event type badge label for a given [EventType].
String _eventTypeLabel(EventType type) {
  switch (type) {
    case EventType.start:
      return 'Start';
    case EventType.continueEvent:
      return 'Continue';
    case EventType.finish:
      return 'Finish';
    case EventType.value:
      return 'Log';
  }
}

/// Returns the background color for the event type badge.
Color _eventTypeBadgeColor(EventType type) {
  switch (type) {
    case EventType.start:
      return Colors.green;
    case EventType.continueEvent:
      return Colors.blue;
    case EventType.finish:
      return Colors.orange;
    case EventType.value:
      return Colors.grey;
  }
}

/// A tile displaying a single history [CounterEntry].
///
/// Shows value, event badge (for event counters), timestamp, duration since
/// previous entry, numeric diff, and a comment preview.
class HistoryEntryTile extends ConsumerWidget {
  const HistoryEntryTile({
    super.key,
    required this.entry,
    required this.counter,
    this.previousEntry,
    this.onTap,
  });

  final CounterEntry entry;
  final Counter counter;

  /// The entry immediately before [entry] in time (i.e. the older entry).
  final CounterEntry? previousEntry;

  /// Called when the tile is tapped. If null the tile is not interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isEventCounter = counter.behaviorType == BehaviorType.event;
    final hasComment =
        entry.comment != null && entry.comment!.isNotEmpty;

    // Duration since previous entry
    String? durationStr;
    if (previousEntry != null) {
      final duration =
          entry.recordedAt.difference(previousEntry!.recordedAt).abs();
      durationStr = formatDuration(duration);
    }

    // Numeric diff
    final currentNum = entry.numericValue;
    final prevNum = previousEntry?.numericValue;
    final diffStr = formatDiff(currentNum, prevNum);
    final double? diffValue =
        (currentNum != null && prevNum != null) ? currentNum - prevNum : null;

    // Comment truncated to 50 chars
    String? commentPreview;
    if (hasComment) {
      final raw = entry.comment!;
      commentPreview = raw.length > 50 ? '${raw.substring(0, 50)}…' : raw;
    }

    Widget tile = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ListTile(
        leading: isEventCounter
            ? _EventBadgeIcon(eventType: entry.eventType)
            : const Icon(Icons.radio_button_unchecked, size: 20),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            entry.value != null
                ? Text(
                    entry.value!,
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )
                : Text(
                    '(no value)',
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
            if (isEventCounter) ...[
              const SizedBox(width: 8),
              _EventBadge(eventType: entry.eventType),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            Text(
              _dateFormat.format(entry.recordedAt),
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),

            // Duration + diff row
            if (durationStr != null || diffStr != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    if (durationStr != null)
                      Text(
                        '\u23f1 $durationStr since previous',
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    const Spacer(),
                    if (diffStr != null && diffValue != null)
                      Text(
                        diffStr,
                        style: textTheme.bodySmall?.copyWith(
                          color:
                              diffValue >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),

            // Comment preview
            if (commentPreview != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  commentPreview,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        trailing: onTap != null
            ? const Icon(Icons.edit_outlined, color: Colors.grey)
            : (hasComment
                ? const Icon(Icons.comment_outlined, color: Colors.grey)
                : null),
        onTap: onTap,
        isThreeLine: commentPreview != null ||
            durationStr != null ||
            diffStr != null,
      ),
    );

    return tile;
  }
}

/// A small colored icon representing the event type.
class _EventBadgeIcon extends StatelessWidget {
  const _EventBadgeIcon({required this.eventType});

  final EventType eventType;

  @override
  Widget build(BuildContext context) {
    final color = _eventTypeBadgeColor(eventType);
    IconData icon;
    switch (eventType) {
      case EventType.start:
        icon = Icons.play_circle_outline;
      case EventType.continueEvent:
        icon = Icons.redo;
      case EventType.finish:
        icon = Icons.check_circle_outline;
      case EventType.value:
        icon = Icons.radio_button_checked;
    }
    return Icon(icon, color: color, size: 24);
  }
}

/// A small rounded chip-style badge showing the event type label.
class _EventBadge extends StatelessWidget {
  const _EventBadge({required this.eventType});

  final EventType eventType;

  @override
  Widget build(BuildContext context) {
    final color = _eventTypeBadgeColor(eventType);
    final label = _eventTypeLabel(eventType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        border: Border.all(color: color.withAlpha(120)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color.withAlpha(220),
        ),
      ),
    );
  }
}
