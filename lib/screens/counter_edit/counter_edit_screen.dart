import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/counters_provider.dart';

const _uuid = Uuid();

class CounterEditScreen extends ConsumerStatefulWidget {
  final Counter? initialCounter;

  /// The counter's ID, provided when navigating to the edit route. Used as a
  /// fallback to load the counter from the DB when [initialCounter] is null
  /// (e.g. deep link or hot restart where [GoRouterState.extra] is lost).
  final String? counterId;

  const CounterEditScreen({super.key, this.initialCounter, this.counterId});

  @override
  ConsumerState<CounterEditScreen> createState() => _CounterEditScreenState();
}

class _CounterEditScreenState extends ConsumerState<CounterEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _changeStepController;
  late final TextEditingController _tagInputController;

  late DataType _selectedDataType;
  late List<String> _tags;
  late int? _selectedColor;
  late bool _autoSave;

  // The resolved counter: set immediately from [initialCounter] when available,
  // or populated asynchronously via [counterByIdProvider] when only [counterId]
  // is provided (deep link / hot restart).
  Counter? _counter;
  bool _loadedFromDb = false;

  static const _colorOptions = <int?>[
    null,
    0xFFF44336, // Colors.red
    0xFFFF9800, // Colors.orange
    0xFFFFEB3B, // Colors.yellow
    0xFF4CAF50, // Colors.green
    0xFF009688, // Colors.teal
    0xFF2196F3, // Colors.blue
    0xFF9C27B0, // Colors.purple
    0xFFE91E63, // Colors.pink
    0xFF795548, // Colors.brown
    0xFF9E9E9E, // Colors.grey
  ];

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounter;
    _initFormFields(_counter);
  }

  void _initFormFields(Counter? c) {
    _nameController = TextEditingController(text: c?.name ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
    _changeStepController = TextEditingController(text: c?.changeStep ?? '');
    _tagInputController = TextEditingController();
    _selectedDataType = c?.dataType ?? DataType.numeric;
    _tags = List<String>.from(c?.tags ?? []);
    _selectedColor = c?.backgroundColor;
    _autoSave = c?.autoSave ?? false;
  }

  /// Populates form fields from a counter loaded asynchronously from the DB.
  void _applyCounterFromDb(Counter c) {
    _counter = c;
    _nameController.text = c.name;
    _descriptionController.text = c.description;
    _changeStepController.text = c.changeStep ?? '';
    setState(() {
      _selectedDataType = c.dataType;
      _tags = List<String>.from(c.tags);
      _selectedColor = c.backgroundColor;
      _autoSave = c.autoSave;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _changeStepController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final isCreating = _counter == null;
    final now = DateTime.now();

    final counter = Counter(
      id: isCreating ? _uuid.v4() : _counter!.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      dataType: _selectedDataType,
      tags: _tags,
      changeStep: _changeStepController.text.trim().isEmpty
          ? null
          : _changeStepController.text.trim(),
      backgroundColor: _selectedColor,
      autoSave: _autoSave,
      createdAt: isCreating ? now : _counter!.createdAt,
      updatedAt: now,
    );

    if (isCreating) {
      await ref.read(counterNotifierProvider.notifier).createCounter(counter);
    } else {
      await ref.read(counterNotifierProvider.notifier).updateCounter(counter);
    }

    if (mounted) context.pop();
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCounterDialogTitle),
        content: Text(l10n.deleteCounterDialogBody(_counter!.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.buttonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.buttonDelete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref
          .read(counterNotifierProvider.notifier)
          .deleteCounter(_counter!.id);
      if (mounted) context.go('/');
    }
  }

  void _addTag(String value) {
    final tag = value.trim().replaceAll(',', '').trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
    }
    _tagInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // If extra was null (deep link / hot restart) and counterId is available,
    // watch the provider and populate the form once the counter is loaded.
    if (_counter == null && widget.counterId != null) {
      final async = ref.watch(counterByIdProvider(widget.counterId!));
      async.whenData((c) {
        if (c != null && !_loadedFromDb) {
          _loadedFromDb = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _applyCounterFromDb(c);
          });
        }
      });
    }

    final isCreating = _counter == null;
    final title = isCreating ? l10n.newCounterTitle : l10n.editCounterTitle;
    final showNumericFields = _selectedDataType == DataType.numeric;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!isCreating)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
              tooltip: l10n.buttonDelete,
            ),
          TextButton(
            onPressed: _save,
            child: Text(l10n.buttonSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Name
              TextFormField(
                controller: _nameController,
                autofocus: isCreating,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.fieldName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.fieldNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Description
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.fieldDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // 3. Data type
              Text(
                l10n.labelDataType,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<DataType>(
                segments: [
                  ButtonSegment(
                    value: DataType.numeric,
                    label: Text(l10n.dataTypeNumeric),
                  ),
                  ButtonSegment(
                    value: DataType.datetime,
                    label: Text(l10n.dataTypeDateTime),
                  ),
                  ButtonSegment(
                    value: DataType.freeText,
                    label: Text(l10n.dataTypeFreeText),
                  ),
                  ButtonSegment(
                    value: DataType.event,
                    label: Text(l10n.dataTypeEvent),
                  ),
                ],
                selected: {_selectedDataType},
                onSelectionChanged: (s) =>
                    setState(() => _selectedDataType = s.first),
              ),
              const SizedBox(height: 16),

              // 5. Change step (only for numeric types)
              if (showNumericFields) ...[
                TextFormField(
                  controller: _changeStepController,
                  decoration: InputDecoration(
                    labelText: l10n.fieldChangeStep,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // optional field
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return l10n.fieldChangeStepError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // 6. Auto-save
              SwitchListTile(
                title: Text(l10n.labelAutoSave),
                value: _autoSave,
                onChanged: (v) => setState(() => _autoSave = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // 7. Tags
              Text(
                l10n.fieldTags,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _buildTagInput(l10n),
              const SizedBox(height: 16),

              // 8. Background color
              Text(
                l10n.labelBackgroundColor,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _buildColorPicker(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_tags.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() => _tags.remove(tag));
                    },
                  ),
                )
                .toList(),
          ),
        if (_tags.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: _tagInputController,
          decoration: InputDecoration(
            labelText: l10n.fieldTags,
            border: const OutlineInputBorder(),
          ),
          onFieldSubmitted: _addTag,
          onChanged: (value) {
            if (value.contains(',')) {
              _addTag(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      children: _colorOptions.map((colorValue) {
        final isSelected = _selectedColor == colorValue;
        final color = colorValue != null ? Color(colorValue) : null;

        return GestureDetector(
          onTap: () => setState(() => _selectedColor = colorValue),
          child: Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color ?? Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400,
                width: isSelected ? 2.5 : 1,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 18,
                    color: colorValue != null ? Colors.white : Colors.black54,
                  )
                : colorValue == null
                    ? Icon(Icons.close, size: 16, color: Colors.grey.shade500)
                    : null,
          ),
        );
      }).toList(),
    );
  }
}
