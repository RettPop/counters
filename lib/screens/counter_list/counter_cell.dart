import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/entries_provider.dart';
import '../../theme/app_theme.dart';

const _uuid = Uuid();

String _formatValue(double val) {
  String s = val.toStringAsFixed(2);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

String _relTime(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt).inSeconds;
  if (diff < 60) return 'just now';
  if (diff < 3600) return '${diff ~/ 60}m ago';
  if (diff < 86400) return '${diff ~/ 3600}h ago';
  if (diff < 86400 * 7) return '${diff ~/ 86400}d ago';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${dt.day} ${months[dt.month - 1]}';
}

String _dataTypeLabel(DataType type) {
  return switch (type) {
    DataType.numeric => 'Numeric',
    DataType.datetime => 'Moment',
    DataType.freeText => 'Text',
    DataType.event => 'Event',
  };
}

class CounterCell extends ConsumerWidget {
  const CounterCell({super.key, required this.counter});

  final Counter counter;

  bool get _hasStep {
    if (counter.changeStep == null) return false;
    if (double.tryParse(counter.changeStep!) == null) return false;
    return counter.dataType == DataType.numeric;
  }

  Future<void> _handleStep(
    WidgetRef ref,
    CounterEntry? lastEntry,
    double multiplier,
  ) async {
    final step = double.tryParse(counter.changeStep ?? '');
    if (step == null) return;
    final lastValue = lastEntry?.numericValue ?? 0;
    final newValue = lastValue + (step * multiplier);
    final formatted = _formatValue(newValue);
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: formatted,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
  }

  Future<void> _handleTimestamp(WidgetRef ref, CounterEntry? lastEntry) async {
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: lastEntry?.value,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
  }

  Future<void> _handleEventStep(WidgetRef ref, CounterEntry? lastEntry) async {
    final eventType =
        (lastEntry == null || lastEntry.eventType == EventType.finish)
            ? EventType.start
            : EventType.continueEvent;
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: eventType,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
  }

  Future<void> _handleEventFinish(WidgetRef ref) async {
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.finish,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lastEntryAsync = ref.watch(lastEntryStreamProvider(counter.id));
    final lastEntry = lastEntryAsync.valueOrNull;
    final tint = tintFromBackgroundColor(counter.backgroundColor);

    final isNumeric = counter.dataType == DataType.numeric;
    final isEvent = counter.dataType == DataType.event;
    final isText = counter.dataType == DataType.freeText;
    final isDT = counter.dataType == DataType.datetime;
    final isRunning = isEvent &&
        lastEntry != null &&
        lastEntry.eventType != EventType.finish;

    return GestureDetector(
      onTap: () => context.push('/counter/${counter.id}'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: name + value ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tint.dot,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              counter.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                                color: AppColors.ink,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 4),
                        child: Row(
                          children: [
                            Text(
                              _dataTypeLabel(counter.dataType),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.ink3,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '\u00b7',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.ink4,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              lastEntry != null
                                  ? _relTime(lastEntry.recordedAt)
                                  : 'no entries',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.ink3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Right-aligned value display ──
                if (isNumeric)
                  _NumericValue(
                    value: lastEntry?.value,
                    placeholder: l10n.noValuePlaceholder,
                  ),
                if (isEvent) _EventPill(running: isRunning, lastEntry: lastEntry),
                if (isText)
                  _TextQuote(
                    value: lastEntry?.value,
                    placeholder: l10n.noValuePlaceholder,
                  ),
                if (isDT)
                  _DatetimeValue(
                    value: lastEntry?.value,
                    placeholder: l10n.noValuePlaceholder,
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Action buttons ──
            Row(
              children: [
                if (isNumeric && _hasStep) ...[
                  _ActionBtn(
                    tint: tint,
                    big: true,
                    onTap: () => _handleStep(ref, lastEntry, -1.0),
                    child: Text(
                      '\u2212${_formatValue(double.parse(counter.changeStep!))}',
                      style: const TextStyle(
                        fontFamily: 'SF Mono',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    tint: tint,
                    big: true,
                    primary: true,
                    onTap: () => _handleStep(ref, lastEntry, 1.0),
                    child: Text(
                      '+${_formatValue(double.parse(counter.changeStep!))}',
                      style: const TextStyle(
                        fontFamily: 'SF Mono',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                if (isNumeric && !_hasStep)
                  _ActionBtn(
                    tint: tint,
                    wide: true,
                    primary: true,
                    onTap: () => context.push('/counter/${counter.id}'),
                    child: const Text(
                      'Log value',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (isEvent && !isRunning)
                  _ActionBtn(
                    tint: tint,
                    wide: true,
                    primary: true,
                    onTap: () => _handleEventStep(ref, lastEntry),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 16, color: tint.ink),
                        const SizedBox(width: 6),
                        Text(
                          l10n.buttonStart,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isEvent && isRunning) ...[
                  _ActionBtn(
                    tint: tint,
                    primary: true,
                    onTap: () => _handleEventStep(ref, lastEntry),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 16, color: tint.ink),
                        const SizedBox(width: 6),
                        Text(
                          l10n.buttonReLog,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    tint: tint,
                    big: true,
                    onTap: () => _handleEventFinish(ref),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stop,
                          size: 14,
                          color: Color(0xFF6B3A34),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Finish',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B3A34),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (isText)
                  _ActionBtn(
                    tint: tint,
                    wide: true,
                    primary: true,
                    onTap: () => context.push('/counter/${counter.id}'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notes, size: 14, color: tint.ink),
                        const SizedBox(width: 6),
                        const Text(
                          'New entry',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isDT)
                  _ActionBtn(
                    tint: tint,
                    wide: true,
                    primary: true,
                    onTap: () => _handleTimestamp(ref, lastEntry),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: tint.ink),
                        const SizedBox(width: 6),
                        Text(
                          l10n.buttonReLog,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // ── Tags ──
            if (counter.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: counter.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: tint.dot.withAlpha(51)),
                      color: tint.dot.withAlpha(16),
                    ),
                    child: Text(
                      tag.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: tint.dot,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Value display widgets
// ─────────────────────────────────────────────────────────────

class _NumericValue extends StatelessWidget {
  const _NumericValue({required this.value, required this.placeholder});
  final String? value;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ?? placeholder,
      style: const TextStyle(
        fontFamily: 'SF Mono',
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
        letterSpacing: -1,
        height: 1,
      ),
    );
  }
}

class _EventPill extends StatelessWidget {
  const _EventPill({required this.running, required this.lastEntry});
  final bool running;
  final CounterEntry? lastEntry;

  String get _label {
    if (!running) return 'Idle';
    if (lastEntry == null) return 'Idle';
    final elapsed = DateTime.now().difference(lastEntry!.recordedAt);
    if (elapsed.inMinutes < 1) return 'just started';
    if (elapsed.inMinutes < 60) return '${elapsed.inMinutes}m in';
    return '${elapsed.inHours}h ${elapsed.inMinutes % 60}m in';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: running ? const Color(0xFFE7F0DC) : AppColors.bg,
        border: Border.all(
          color: running ? const Color(0xFFBED29B) : AppColors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: running ? const Color(0xFF6B8E3D) : AppColors.ink4,
              boxShadow: running
                  ? [BoxShadow(color: const Color(0x386B8E3D), blurRadius: 4)]
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: running ? const Color(0xFF3E5522) : AppColors.ink3,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextQuote extends StatelessWidget {
  const _TextQuote({required this.value, required this.placeholder});
  final String? value;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 170),
      child: Text(
        value != null ? '\u201c${value!}\u201d' : placeholder,
        style: const TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: AppColors.ink2,
        ),
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _DatetimeValue extends StatelessWidget {
  const _DatetimeValue({required this.value, required this.placeholder});
  final String? value;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ?? placeholder,
      style: const TextStyle(
        fontFamily: 'SF Mono',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
        letterSpacing: -0.5,
        height: 1,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Action button
// ─────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.tint,
    required this.child,
    this.big = false,
    this.primary = false,
    this.wide = false,
    this.onTap,
  });

  final CounterTint tint;
  final Widget child;
  final bool big;
  final bool primary;
  final bool wide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = primary ? tint.bg : AppColors.bg;
    final fgColor = primary ? tint.ink : AppColors.ink2;

    return Expanded(
      flex: wide ? 1 : (big ? 1 : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: primary ? null : Border.all(color: AppColors.line),
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: fgColor),
            child: IconTheme(
              data: IconThemeData(color: fgColor),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
