# Swipe-to-Delete Counter Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add swipe-left-to-delete with confirmation dialog to the counter list screen.

**Architecture:** Wrap each `CounterCell` in Flutter's `Dismissible` widget inside the `ListView.builder` in `counter_list_screen.dart`. Use `confirmDismiss` to show the dialog before any deletion — if the user cancels, the cell slides back; if confirmed, `deleteCounter` is called in `onDismissed`.

**Tech Stack:** Flutter `Dismissible`, existing `counterNotifierProvider.deleteCounter`, existing l10n strings (`deleteCounterDialogTitle`, `deleteCounterDialogBody`, `buttonDelete`, `buttonCancel`) — no new strings needed.

---

### Task 1: Wrap CounterCell in Dismissible

**Files:**
- Modify: `lib/screens/counter_list/counter_list_screen.dart`

The `CounterListScreen` is already a `ConsumerWidget` with access to `ref` and `l10n`. No changes to `counter_cell.dart` or any provider needed.

**Step 1: Replace the bare `CounterCell(...)` in `itemBuilder` with a `Dismissible`**

In `counter_list_screen.dart`, find the `itemBuilder` (line 45-46):

```dart
itemBuilder: (context, index) =>
    CounterCell(counter: counters[index]),
```

Replace with:

```dart
itemBuilder: (context, index) {
  final counter = counters[index];
  return Dismissible(
    key: ValueKey(counter.id),
    direction: DismissDirection.endToStart,
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Theme.of(context).colorScheme.error,
      child: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.onError,
      ),
    ),
    confirmDismiss: (_) async {
      return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.deleteCounterDialogTitle),
          content: Text(l10n.deleteCounterDialogBody(counter.name)),
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
      ) ??
          false;
    },
    onDismissed: (_) {
      ref
          .read(counterNotifierProvider.notifier)
          .deleteCounter(counter.id);
    },
    child: CounterCell(counter: counter),
  );
},
```

**Step 2: Run the app and verify**

```bash
flutter run -d <emulator>
```

- Swipe a counter cell to the left → red background with delete icon appears
- Release → confirmation dialog appears
- Tap **Cancel** → cell slides back, counter still in list
- Swipe again, tap **Delete** → counter removed from list

**Step 3: Run static analysis**

```bash
flutter analyze
```

Expected: no new issues.

**Step 4: Commit**

```bash
git add lib/screens/counter_list/counter_list_screen.dart
git commit -m "feat: swipe-to-delete counter with confirmation dialog"
```
