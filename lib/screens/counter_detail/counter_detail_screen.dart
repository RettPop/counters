import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/counters_provider.dart';
import '../../providers/entries_provider.dart';
import '../../providers/photos_provider.dart';
import '../../theme/app_theme.dart';
import 'counter_history_chart.dart';
import 'entry_edit_sheet.dart';
import 'history_entry_tile.dart';

const _uuid = Uuid();
final _datetimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

String _formatValue(double val) {
  String s = val.toStringAsFixed(2);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

class CounterDetailScreen extends ConsumerStatefulWidget {
  const CounterDetailScreen({super.key, required this.counterId});

  final String counterId;

  @override
  ConsumerState<CounterDetailScreen> createState() =>
      _CounterDetailScreenState();
}

class _CounterDetailScreenState extends ConsumerState<CounterDetailScreen> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  Timer? _autoSaveTimer;
  bool _noteExpanded = false;
  CounterEntry? _autoSavedEntry;
  bool _datetimePreFilled = false;

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _valueController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onValueChanged(String value) {
    final counterAsync = ref.read(counterByIdProvider(widget.counterId));
    final counter = counterAsync.valueOrNull;
    if (counter?.autoSave != true) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      if (_valueController.text.trim().isNotEmpty) {
        _logEntry().then((_) {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.snackbarSaved),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        });
      }
    });
  }

  void _resetInlineNote() {
    setState(() {
      _autoSavedEntry = null;
      _commentController.clear();
      _noteExpanded = false;
    });
  }

  Future<bool> _autoSaveEntryForPhoto() async {
    if (_autoSavedEntry != null) return true;
    final now = DateTime.now();
    final comment = _commentController.text.trim();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: EventType.value,
      value: _valueController.text.trim().isEmpty
          ? null
          : _valueController.text.trim(),
      comment: comment.isEmpty ? null : comment,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    if (!mounted) return false;
    setState(() {
      _autoSavedEntry = entry;
      _valueController.clear();
      _commentController.clear();
    });
    return true;
  }

  Future<void> _pickInlinePhoto(ImageSource source) async {
    final saved = await _autoSaveEntryForPhoto();
    if (!saved) return;
    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${dir.path}/entry_photos');
    if (!await photosDir.exists()) await photosDir.create(recursive: true);
    final ext = picked.path.split('.').last;
    final photoId = _uuid.v4();
    final dest = '${photosDir.path}/$photoId.$ext';
    await File(picked.path).copy(dest);
    final photo = EntryPhoto(
      id: photoId,
      entryId: _autoSavedEntry!.id,
      localPath: dest,
      createdAt: DateTime.now(),
    );
    if (!mounted) return;
    await ref
        .read(photoNotifierProvider(_autoSavedEntry!.id).notifier)
        .addPhoto(photo);
  }

  Future<void> _logEntry() async {
    final value = _valueController.text.trim();
    if (value.isEmpty) return;
    final comment = _commentController.text.trim();
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: EventType.value,
      value: value,
      comment: comment.isEmpty ? null : comment,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    if (!mounted) return;
    _valueController.clear();
    _resetInlineNote();
  }

  Future<void> _logEventEntry(EventType eventType) async {
    final value = _valueController.text.trim();
    final comment = _commentController.text.trim();
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: eventType,
      value: value.isEmpty ? null : value,
      comment: comment.isEmpty ? null : comment,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    if (!mounted) return;
    _resetInlineNote();
  }

  Future<void> _handleStep(
      Counter counter, CounterEntry? lastEntry, double multiplier) async {
    final step = double.tryParse(counter.changeStep ?? '');
    if (step == null) return;
    final lastValue = lastEntry?.numericValue ?? 0;
    final newValue = lastValue + (step * multiplier);
    final formatted = _formatValue(newValue);
    final comment = _commentController.text.trim();
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: EventType.value,
      value: formatted,
      comment: comment.isEmpty ? null : comment,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    if (!mounted) return;
    _resetInlineNote();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;
    final combined = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );
    _valueController.text = _datetimeFormat.format(combined);
  }

  void _onEntryTap(CounterEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => EntryEditSheet(
        entry: entry,
        counterId: widget.counterId,
      ),
    );
  }

  bool _showStepButtons(Counter counter) {
    if (counter.changeStep == null) return false;
    if (double.tryParse(counter.changeStep!) == null) return false;
    return counter.dataType == DataType.numeric;
  }

  String _formatRecordedAt(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final counterAsync = ref.watch(counterByIdProvider(widget.counterId));
    final lastEntryAsync = ref.watch(lastEntryStreamProvider(widget.counterId));

    return counterAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric(error.toString()))),
      ),
      data: (counter) {
        if (counter == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.errorCounterNotFound)),
          );
        }

        if (counter.dataType == DataType.datetime && !_datetimePreFilled) {
          _datetimePreFilled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _valueController.text.isEmpty) {
              _valueController.text = _datetimeFormat.format(DateTime.now());
            }
          });
        }

        final lastEntry = lastEntryAsync.valueOrNull;
        final entriesAsync =
            ref.watch(entriesForCounterProvider(widget.counterId));
        final entries = entriesAsync.valueOrNull ?? [];
        final tint = tintFromBackgroundColor(counter.backgroundColor);

        final isEvent = counter.dataType == DataType.event;
        final isRunning = isEvent &&
            lastEntry != null &&
            lastEntry.eventType != EventType.finish;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: CustomScrollView(
            slivers: [
              // ── Colored header band ──
              SliverToBoxAdapter(
                child: _HeaderBand(
                  counter: counter,
                  tint: tint,
                  lastEntry: lastEntry,
                  isEvent: isEvent,
                  isRunning: isRunning,
                  entries: entries,
                ),
              ),

              // ── Log action strip (numeric with step) ──
              if (_showStepButtons(counter))
                SliverToBoxAdapter(
                  child: _LogStrip(
                    counter: counter,
                    tint: tint,
                    lastEntry: lastEntry,
                    valueController: _valueController,
                    onDecrement: () => _handleStep(counter, lastEntry, -1.0),
                    onIncrement: () => _handleStep(counter, lastEntry, 1.0),
                    onLogValue: _logEntry,
                  ),
                ),

              // ── Event action buttons ──
              if (isEvent)
                SliverToBoxAdapter(
                  child: _EventActions(
                    tint: tint,
                    isRunning: isRunning,
                    onStart: () => _logEventEntry(EventType.start),
                    onContinue: () => _logEventEntry(EventType.continueEvent),
                    onFinish: () => _logEventEntry(EventType.finish),
                  ),
                ),

              // ── Input section (non-step numeric, datetime, text) ──
              if (!_showStepButtons(counter) && !isEvent)
                SliverToBoxAdapter(
                  child: _InputSection(
                    counter: counter,
                    tint: tint,
                    valueController: _valueController,
                    onValueChanged: _onValueChanged,
                    onPickDateTime: _pickDateTime,
                    onLog: _logEntry,
                    l10n: l10n,
                  ),
                ),

              // ── Inline note section ──
              SliverToBoxAdapter(
                child: _buildInlineNoteSection(l10n),
              ),

              // ── Chart ──
              SliverToBoxAdapter(
                child: CounterHistoryChart(
                  entries: entries,
                  counter: counter,
                ),
              ),

              // ── History header ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Text(
                    l10n.counterDetailHistoryHeader.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColors.ink3,
                    ),
                  ),
                ),
              ),

              // ── History entries ──
              SliverList.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final previousEntry =
                      index + 1 < entries.length ? entries[index + 1] : null;
                  return HistoryEntryTile(
                    entry: entry,
                    counter: counter,
                    previousEntry: previousEntry,
                    onTap: () => _onEntryTap(entry),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInlineNoteSection(AppLocalizations l10n) {
    final hasContent =
        _commentController.text.isNotEmpty || _autoSavedEntry != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _noteExpanded = !_noteExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Icon(
                    _noteExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: AppColors.ink3,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _noteExpanded
                        ? l10n.inlineNoteCollapse
                        : l10n.inlineNoteExpand,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.ink2,
                    ),
                  ),
                  if (!_noteExpanded && hasContent) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_noteExpanded) ...[
            const SizedBox(height: 8),
            if (_autoSavedEntry == null) ...[
              TextField(
                controller: _commentController,
                decoration: InputDecoration(labelText: l10n.fieldComment),
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              _InlineAddPhotoButton(
                onGallery: () => _pickInlinePhoto(ImageSource.gallery),
                onCamera: () => _pickInlinePhoto(ImageSource.camera),
                l10n: l10n,
              ),
            ] else ...[
              Text(
                '${l10n.inlineNoteSaved} \u2014 ${_formatRecordedAt(_autoSavedEntry!.recordedAt)}',
                style: const TextStyle(fontSize: 12, color: AppColors.ink3),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final photosAsync =
                      ref.watch(photosForEntryProvider(_autoSavedEntry!.id));
                  final photos = photosAsync.valueOrNull ?? [];
                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(photo.localPath),
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _InlineAddPhotoButton(
                onGallery: () => _pickInlinePhoto(ImageSource.gallery),
                onCamera: () => _pickInlinePhoto(ImageSource.camera),
                l10n: l10n,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(labelText: l10n.fieldComment),
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header band with counter info
// ─────────────────────────────────────────────────────────────

class _HeaderBand extends StatelessWidget {
  const _HeaderBand({
    required this.counter,
    required this.tint,
    required this.lastEntry,
    required this.isEvent,
    required this.isRunning,
    required this.entries,
  });

  final Counter counter;
  final CounterTint tint;
  final CounterEntry? lastEntry;
  final bool isEvent;
  final bool isRunning;
  final List<CounterEntry> entries;

  IconData _dataTypeIcon(DataType type) {
    return switch (type) {
      DataType.numeric => Icons.exposure,
      DataType.datetime => Icons.calendar_today,
      DataType.freeText => Icons.notes,
      DataType.event => Icons.flag,
    };
  }

  String _dataTypeLabel(DataType type) {
    return switch (type) {
      DataType.numeric => 'Numeric counter',
      DataType.datetime => 'Moment counter',
      DataType.freeText => 'Text counter',
      DataType.event => 'Event counter',
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentValue = lastEntry?.value ?? '';

    return Container(
      color: tint.bg,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nav row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavPill(
                    icon: Icons.arrow_back_ios_new,
                    color: tint.ink,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _NavPill(
                    icon: Icons.more_horiz,
                    color: tint.ink,
                    onTap: () => context.push(
                      '/counter/${counter.id}/edit',
                      extra: counter,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type label
                  Row(
                    children: [
                      Icon(
                        _dataTypeIcon(counter.dataType),
                        size: 12,
                        color: tint.ink.withAlpha(191),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _dataTypeLabel(counter.dataType).toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: tint.ink.withAlpha(191),
                        ),
                      ),
                      if (isRunning) ...[
                        Text(
                          ' \u00b7 RUNNING',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: tint.ink.withAlpha(191),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Counter name
                  Text(
                    counter.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      color: tint.ink,
                    ),
                  ),

                  // Description
                  if (counter.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      counter.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: tint.ink.withAlpha(179),
                      ),
                    ),
                  ],

                  // Big value display
                  if (!isEvent && currentValue.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      currentValue,
                      style: TextStyle(
                        fontFamily: 'SF Mono',
                        fontSize: 72,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -3,
                        height: 0.95,
                        color: tint.ink,
                      ),
                    ),
                  ],

                  // Event timer display
                  if (isEvent && isRunning) ...[
                    const SizedBox(height: 18),
                    _LiveTimer(lastEntry: lastEntry!, tint: tint),
                  ],

                  // Tags
                  if (counter.tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
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
                            border: Border.all(
                              color: tint.ink.withAlpha(51),
                            ),
                            color: tint.ink.withAlpha(16),
                          ),
                          child: Text(
                            tag.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: tint.ink,
                              letterSpacing: 0.3,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  const _NavPill({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _LiveTimer extends StatefulWidget {
  const _LiveTimer({required this.lastEntry, required this.tint});
  final CounterEntry lastEntry;
  final CounterTint tint;

  @override
  State<_LiveTimer> createState() => _LiveTimerState();
}

class _LiveTimerState extends State<_LiveTimer> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatElapsed(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(1, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = DateTime.now().difference(widget.lastEntry.recordedAt);
    final startTime =
        '${widget.lastEntry.recordedAt.hour.toString().padLeft(2, '0')}:${widget.lastEntry.recordedAt.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(128),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Breathing dot
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.tint.ink,
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bg,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STARTED $startTime',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: widget.tint.ink.withAlpha(179),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatElapsed(elapsed),
                  style: TextStyle(
                    fontFamily: 'SF Mono',
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1,
                    color: widget.tint.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Log strip (floating over seam, for numeric with step)
// ─────────────────────────────────────────────────────────────

class _LogStrip extends StatefulWidget {
  const _LogStrip({
    required this.counter,
    required this.tint,
    required this.lastEntry,
    required this.valueController,
    required this.onDecrement,
    required this.onIncrement,
    required this.onLogValue,
  });

  final Counter counter;
  final CounterTint tint;
  final CounterEntry? lastEntry;
  final TextEditingController valueController;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onLogValue;

  @override
  State<_LogStrip> createState() => _LogStripState();
}

class _LogStripState extends State<_LogStrip> {
  bool _editing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && mounted) {
        setState(() => _editing = false);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _editing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _submit() {
    if (widget.valueController.text.trim().isNotEmpty) {
      widget.onLogValue();
      setState(() => _editing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepLabel =
        _formatValue(double.parse(widget.counter.changeStep!));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F1A1816),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Decrement button
            _StepButton(
              label: '\u2212$stepLabel',
              tint: widget.tint,
              onTap: widget.onDecrement,
            ),
            // Center area: placeholder or text field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _editing
                    ? TextField(
                        controller: widget.valueController,
                        focusNode: _focusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'SF Mono',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                          letterSpacing: -0.5,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.line),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: widget.tint.dot,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.bg,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: widget.tint.ink,
                              size: 22,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _submit,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      )
                    : GestureDetector(
                        onTap: _startEditing,
                        child: Column(
                          children: const [
                            Text(
                              'LOG NOW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: AppColors.ink3,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'or type\u2026',
                              style: TextStyle(
                                fontFamily: 'SF Mono',
                                fontSize: 15,
                                color: AppColors.ink2,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            // Increment button
            _StepButton(
              label: '+$stepLabel',
              tint: widget.tint,
              primary: true,
              onTap: widget.onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.label,
    required this.tint,
    this.primary = false,
    required this.onTap,
  });

  final String label;
  final CounterTint tint;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 68,
        decoration: BoxDecoration(
          color: primary ? tint.ink : AppColors.bg,
          borderRadius: BorderRadius.circular(14),
          border: primary ? null : Border.all(color: AppColors.line),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'SF Mono',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
              color: primary ? AppColors.bg : tint.ink,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Event action buttons
// ─────────────────────────────────────────────────────────────

class _EventActions extends StatelessWidget {
  const _EventActions({
    required this.tint,
    required this.isRunning,
    required this.onStart,
    required this.onContinue,
    required this.onFinish,
  });

  final CounterTint tint;
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onContinue;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          if (!isRunning)
            Expanded(
              child: _PrimaryBtn(
                tint: tint,
                onTap: onStart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: AppColors.bg),
                    const SizedBox(width: 8),
                    Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isRunning) ...[
            Expanded(
              child: _PrimaryBtn(
                tint: tint,
                onTap: onContinue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: 16, color: AppColors.bg),
                    const SizedBox(width: 8),
                    Text(
                      l10n.buttonReLog,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFinish,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(179),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0x336B3A34),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.stop, size: 14, color: Color(0xFF6B3A34)),
                    SizedBox(width: 6),
                    Text(
                      'Finish',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B3A34),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn({
    required this.tint,
    required this.child,
    required this.onTap,
  });

  final CounterTint tint;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tint.ink,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Input section (non-step numeric, datetime, freeText)
// ─────────────────────────────────────────────────────────────

class _InputSection extends StatelessWidget {
  const _InputSection({
    required this.counter,
    required this.tint,
    required this.valueController,
    required this.onValueChanged,
    required this.onPickDateTime,
    required this.onLog,
    required this.l10n,
  });

  final Counter counter;
  final CounterTint tint;
  final TextEditingController valueController;
  final ValueChanged<String> onValueChanged;
  final VoidCallback onPickDateTime;
  final VoidCallback onLog;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    switch (counter.dataType) {
      case DataType.numeric:
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
      case DataType.datetime:
        keyboardType = TextInputType.datetime;
      case DataType.freeText:
        keyboardType = TextInputType.multiline;
      case DataType.event:
        keyboardType = TextInputType.text;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (counter.dataType == DataType.datetime) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: valueController,
                      decoration:
                          InputDecoration(labelText: l10n.fieldNewValue),
                      keyboardType: keyboardType,
                      maxLines: 1,
                      onChanged: onValueChanged,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onPickDateTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: tint.bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.buttonPickDateTime,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tint.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              TextField(
                controller: valueController,
                decoration: InputDecoration(labelText: l10n.fieldNewValue),
                keyboardType: keyboardType,
                maxLines: counter.dataType == DataType.freeText ? 3 : 1,
                onChanged: onValueChanged,
              ),
            ],
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onLog,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: tint.ink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    l10n.buttonLog,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bg,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Inline add photo button
// ─────────────────────────────────────────────────────────────

class _InlineAddPhotoButton extends StatelessWidget {
  const _InlineAddPhotoButton({
    required this.onGallery,
    required this.onCamera,
    required this.l10n,
  });

  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: onGallery,
          icon: const Icon(Icons.photo_library_outlined, size: 16),
          label: Text(l10n.buttonFromGallery),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onCamera,
          icon: const Icon(Icons.camera_alt_outlined, size: 16),
          label: Text(l10n.buttonCamera),
        ),
      ],
    );
  }
}
