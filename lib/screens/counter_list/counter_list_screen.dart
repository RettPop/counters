import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/counter.dart';
import '../../providers/counters_provider.dart';
import '../../theme/app_theme.dart';
import 'counter_cell.dart';

class CounterListScreen extends ConsumerStatefulWidget {
  const CounterListScreen({super.key});

  @override
  ConsumerState<CounterListScreen> createState() => _CounterListScreenState();
}

class _CounterListScreenState extends ConsumerState<CounterListScreen> {
  bool _searching = false;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searching = true);
  }

  void _closeSearch() {
    _searchController.clear();
    setState(() {
      _searching = false;
      _query = '';
    });
  }

  List<Counter> _filter(List<Counter> counters) {
    if (_query.isEmpty) return counters;
    final q = _query.toLowerCase();
    return counters.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countersAsync = ref.watch(countersProvider);

    return Scaffold(
      body: SafeArea(
        child: countersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (allCounters) {
            if (allCounters.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_chart, size: 64, color: AppColors.ink4),
                    const SizedBox(height: 16),
                    Text(
                      l10n.counterListEmptyTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.ink2),
                    ),
                    Text(
                      l10n.counterListEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.ink3),
                    ),
                  ],
                ),
              );
            }

            final counters = _filter(allCounters);

            return ListView.builder(
              padding: const EdgeInsets.only(
                left: 16, right: 16, top: 8, bottom: 100,
              ),
              itemCount: counters.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _searching
                      ? _SearchBar(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          onClose: _closeSearch,
                        )
                      : _Header(
                          onSearch: _openSearch,
                          onSettings: () => context.push('/settings'),
                        );
                }
                final counter = counters[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Dismissible(
                    key: ValueKey(counter.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B3A34),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (_) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.deleteCounterDialogTitle),
                          content: Text(
                            l10n.deleteCounterDialogBody(counter.name),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(l10n.buttonCancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6B3A34),
                              ),
                              child: Text(l10n.buttonDelete),
                            ),
                          ],
                        ),
                      ) ??
                          false;
                    },
                    onDismissed: (_) {
                      ref
                          .read(counterNotifierProvider.notifier)
                          .deleteCounter(counter.id);
                    },
                    child: CounterCell(counter: counter),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () => context.push('/counter/new'),
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSearch, required this.onSettings});
  final VoidCallback onSearch;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _IconPill(icon: Icons.search, onTap: onSearch),
          const SizedBox(width: 8),
          _IconPill(icon: Icons.settings_outlined, onTap: onSettings),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClose,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 6),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, size: 18, color: AppColors.ink3),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                onChanged: onChanged,
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
                decoration: const InputDecoration(
                  hintText: 'Search counters\u2026',
                  hintStyle: TextStyle(color: AppColors.ink3, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.close, size: 18, color: AppColors.ink3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  const _IconPill({required this.icon, required this.onTap});
  final IconData icon;
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
        child: Icon(icon, size: 18, color: AppColors.ink2),
      ),
    );
  }
}
