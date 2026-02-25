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
    if (_autoSavedEntry != null) return true; // already saved
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
      _commentController.clear(); // comment was saved with the entry
    });
    return true;
  }

  Future<void> _pickInlinePhoto(ImageSource source) async {
    // Auto-save entry first (transitions to Mode B)
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

  Future<void> _handleStep(Counter counter, CounterEntry? lastEntry,
      double multiplier) async {
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
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
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

  Widget _buildInputSection(
      AppLocalizations l10n, Counter counter, CounterEntry? lastEntry) {
    final currentValue = lastEntry?.value ?? l10n.noValuePlaceholder;

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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current value card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    l10n.currentValueLabel,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    currentValue,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Value input field
          if (counter.dataType == DataType.datetime) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _valueController,
                    decoration:
                        InputDecoration(labelText: l10n.fieldNewValue),
                    keyboardType: keyboardType,
                    maxLines: 1,
                    onChanged: _onValueChanged,
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: Text(l10n.buttonPickDateTime),
                ),
              ],
            ),
          ] else ...[
            TextField(
              controller: _valueController,
              decoration: InputDecoration(labelText: l10n.fieldNewValue),
              keyboardType: keyboardType,
              maxLines: counter.dataType == DataType.freeText ? 3 : 1,
              onChanged: _onValueChanged,
            ),
          ],
          const SizedBox(height: 16),

          // Step buttons (numeric types with changeStep)
          if (_showStepButtons(counter)) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.remove),
                    label: Text('−${counter.changeStep}'),
                    onPressed: () => _handleStep(counter, lastEntry, -1.0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text('+${counter.changeStep}'),
                    onPressed: () => _handleStep(counter, lastEntry, 1.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Event buttons (event behavior type)
          if (counter.dataType == DataType.event) ...[
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _logEventEntry(EventType.start),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow),
                        Text(l10n.buttonStart),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _logEventEntry(EventType.continueEvent),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fast_forward),
                        Text(l10n.buttonContinue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _logEventEntry(EventType.finish),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stop),
                        Text(l10n.buttonFinish),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Log button (not shown for event counters — they use Start/Continue/Finish)
          if (counter.dataType != DataType.event) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logEntry,
                child: Text(l10n.buttonLog),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInlineNoteSection(AppLocalizations l10n) {
    final hasContent =
        _commentController.text.isNotEmpty || _autoSavedEntry != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle row
          InkWell(
            onTap: () => setState(() => _noteExpanded = !_noteExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Icon(
                    _noteExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _noteExpanded ? l10n.inlineNoteCollapse : l10n.inlineNoteExpand,
                    style: Theme.of(context).textTheme.bodyMedium,
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

          // Expanded body
          if (_noteExpanded) ...[
            const SizedBox(height: 8),
            if (_autoSavedEntry == null) ...[
              // Mode A: pre-save
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
              // Mode B: post-auto-save
              Text(
                '${l10n.inlineNoteSaved} — ${_formatRecordedAt(_autoSavedEntry!.recordedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              // Photo strip
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
              // Comment field for next log
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

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // 1. SliverAppBar
              SliverAppBar(
                title: Text(counter.name),
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit counter',
                    onPressed: () => context.push(
                      '/counter/${widget.counterId}/edit',
                      extra: counter,
                    ),
                  ),
                ],
              ),

              // 2. Top input section
              SliverToBoxAdapter(
                child: _buildInputSection(l10n, counter, lastEntry),
              ),

              // 3. Inline note section
              SliverToBoxAdapter(
                child: _buildInlineNoteSection(l10n),
              ),

              // 4. Chart
              SliverToBoxAdapter(
                child: CounterHistoryChart(
                  entries: entries,
                  counter: counter,
                ),
              ),

              // 5. History header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.counterDetailHistoryHeader,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),

              // 6. History entries
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
            ],
          ),
        );
      },
    );
  }
}

/// Compact add-photo button for the inline note section.
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
