import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../providers/counters_provider.dart';

const _uuid = Uuid();

class CounterEditScreen extends ConsumerStatefulWidget {
  final Counter? initialCounter;

  const CounterEditScreen({super.key, this.initialCounter});

  @override
  ConsumerState<CounterEditScreen> createState() => _CounterEditScreenState();
}

class _CounterEditScreenState extends ConsumerState<CounterEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _changeStepController;
  late final TextEditingController _tagInputController;

  late BehaviorType _selectedBehaviorType;
  late DataType _selectedDataType;
  late List<String> _tags;
  late int? _selectedColor;
  late bool _autoSave;

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
    final c = widget.initialCounter;
    _nameController = TextEditingController(text: c?.name ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
    _changeStepController = TextEditingController(text: c?.changeStep ?? '');
    _tagInputController = TextEditingController();
    _selectedBehaviorType = c?.behaviorType ?? BehaviorType.value;
    _selectedDataType = c?.dataType ?? DataType.integer;
    _tags = List<String>.from(c?.tags ?? []);
    _selectedColor = c?.backgroundColor;
    _autoSave = c?.autoSave ?? false;
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

    final isCreating = widget.initialCounter == null;
    final now = DateTime.now();

    final counter = Counter(
      id: isCreating ? _uuid.v4() : widget.initialCounter!.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      behaviorType: _selectedBehaviorType,
      dataType: _selectedDataType,
      tags: _tags,
      changeStep: _changeStepController.text.trim().isEmpty
          ? null
          : _changeStepController.text.trim(),
      backgroundColor: _selectedColor,
      autoSave: _autoSave,
      createdAt: isCreating ? now : widget.initialCounter!.createdAt,
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Counter'),
        content: Text(
          'Delete "${widget.initialCounter!.name}"? This will permanently delete the counter and all its history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref
          .read(counterNotifierProvider.notifier)
          .deleteCounter(widget.initialCounter!.id);
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
    final isCreating = widget.initialCounter == null;
    final title = isCreating ? 'New Counter' : 'Edit ${widget.initialCounter!.name}';
    final showNumericFields = _selectedDataType == DataType.integer ||
        _selectedDataType == DataType.float;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!isCreating)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
              tooltip: 'Delete counter',
            ),
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
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
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // 3. Behavior type
              Text(
                'Behavior',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<BehaviorType>(
                segments: const [
                  ButtonSegment(
                    value: BehaviorType.value,
                    label: Text('Value'),
                  ),
                  ButtonSegment(
                    value: BehaviorType.event,
                    label: Text('Event'),
                  ),
                ],
                selected: {_selectedBehaviorType},
                onSelectionChanged: (s) =>
                    setState(() => _selectedBehaviorType = s.first),
              ),
              const SizedBox(height: 16),

              // 4. Data type
              Text(
                'Data Type',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<DataType>(
                segments: const [
                  ButtonSegment(
                    value: DataType.integer,
                    label: Text('Integer'),
                  ),
                  ButtonSegment(
                    value: DataType.float,
                    label: Text('Float'),
                  ),
                  ButtonSegment(
                    value: DataType.datetime,
                    label: Text('Date/Time'),
                  ),
                  ButtonSegment(
                    value: DataType.freeText,
                    label: Text('Text'),
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
                  decoration: const InputDecoration(
                    labelText: 'Change step (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 6. Auto-save
              SwitchListTile(
                title: const Text('Auto-save after 2 seconds'),
                value: _autoSave,
                onChanged: (v) => setState(() => _autoSave = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // 7. Tags
              Text(
                'Tags',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _buildTagInput(),
              const SizedBox(height: 16),

              // 8. Background color
              Text(
                'Background Color',
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

  Widget _buildTagInput() {
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
          decoration: const InputDecoration(
            labelText: 'Add tag (press Enter or use comma)',
            border: OutlineInputBorder(),
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
