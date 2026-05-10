import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/photos_provider.dart';
import '../../theme/app_theme.dart';

final _dateFormat = DateFormat('dd MMM');
final _timeFormat = DateFormat('HH:mm');

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

/// Returns the localised event type badge label for a given [EventType].
String _eventTypeLabel(AppLocalizations l10n, EventType type) {
  switch (type) {
    case EventType.start:
      return l10n.eventTypeStart;
    case EventType.continueEvent:
      return l10n.eventTypeContinue;
    case EventType.finish:
      return l10n.eventTypeFinish;
    case EventType.value:
      return l10n.eventTypeLog;
  }
}

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
  final CounterEntry? previousEntry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isEventCounter = counter.dataType == DataType.event;
    final hasComment = entry.comment != null && entry.comment!.isNotEmpty;
    final tint = tintFromBackgroundColor(counter.backgroundColor);

    final photosAsync = ref.watch(photosForEntryProvider(entry.id));
    final photos = photosAsync.valueOrNull ?? [];

    // Numeric diff
    final currentNum = entry.numericValue;
    final prevNum = previousEntry?.numericValue;
    final diffStr = formatDiff(currentNum, prevNum);
    final double? diffValue =
        (currentNum != null && prevNum != null) ? currentNum - prevNum : null;

    // Time gap since previous entry
    final String? gapStr = previousEntry == null
        ? null
        : formatDuration(entry.recordedAt.difference(previousEntry!.recordedAt));

    // Comment truncated
    String? commentPreview;
    if (hasComment) {
      final raw = entry.comment!;
      commentPreview = raw.length > 50 ? '${raw.substring(0, 50)}\u2026' : raw;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.line),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column
            SizedBox(
              width: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dateFormat.format(entry.recordedAt),
                    style: const TextStyle(
                      fontFamily: 'SF Mono',
                      fontSize: 13,
                      color: AppColors.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _timeFormat.format(entry.recordedAt),
                    style: const TextStyle(
                      fontFamily: 'SF Mono',
                      fontSize: 11,
                      color: AppColors.ink3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Value + details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (entry.value != null)
                        Text(
                          entry.value!,
                          style: const TextStyle(
                            fontFamily: 'SF Mono',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        )
                      else
                        Text(
                          l10n.noValueEntry,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppColors.ink3,
                          ),
                        ),
                      if (diffStr != null && diffValue != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          diffStr,
                          style: TextStyle(
                            fontFamily: 'SF Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: diffValue >= 0
                                ? const Color(0xFF8A5A2B)
                                : const Color(0xFF3B5238),
                          ),
                        ),
                      ],
                      if (isEventCounter) ...[
                        const SizedBox(width: 8),
                        _EventBadge(
                          eventType: entry.eventType,
                          l10n: l10n,
                        ),
                      ],
                      if (photos.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.ink4,
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 10,
                            color: AppColors.surface,
                          ),
                        ),
                      ],
                      if (gapStr != null) ...[
                        const Spacer(),
                        Text(
                          '+$gapStr',
                          style: const TextStyle(
                            fontFamily: 'SF Mono',
                            fontSize: 11,
                            color: AppColors.ink3,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (commentPreview != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '\u201c$commentPreview\u201d',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.ink2,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Photo thumbnails
                  if (photos.isNotEmpty)
                    SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photos.length,
                        itemBuilder: (context, i) {
                          final photo = photos[i];
                          return Padding(
                            padding: const EdgeInsets.only(right: 4, top: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                File(photo.localPath),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey.shade200,
                                  child:
                                      const Icon(Icons.broken_image, size: 20),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Trailing color strip
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: (diffValue != null && diffValue < 0)
                    ? tint.dot.withAlpha(89)
                    : (diffValue != null && diffValue > 0)
                        ? const Color(0xFFC49866).withAlpha(89)
                        : AppColors.ink4.withAlpha(89),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventBadge extends StatelessWidget {
  const _EventBadge({required this.eventType, required this.l10n});

  final EventType eventType;
  final AppLocalizations l10n;

  Color get _badgeColor {
    switch (eventType) {
      case EventType.start:
        return const Color(0xFF3B5238);
      case EventType.continueEvent:
        return const Color(0xFF2E4A66);
      case EventType.finish:
        return const Color(0xFF8A5A2B);
      case EventType.value:
        return AppColors.ink3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor;
    final label = _eventTypeLabel(l10n, eventType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color.withAlpha(76)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
