# Event Counter Step Button Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a single quick-action button to event counter cells in the list screen that advances the counter's event state (not-started → start, ongoing → continue, finished → re-start) without opening the detail screen.

**Architecture:** The icon selection logic is extracted as a top-level function `eventStepIcon` in `counter_cell.dart` so it can be unit-tested in isolation. A new `_showEventAction` getter and `_handleEventStep()` method are added to `CounterCell`. A new UI block in `build` renders the single right-aligned `IconButton`. No model, DB, or provider changes needed.

**Tech Stack:** Flutter, Riverpod (`StreamProvider.family`, `FamilyAsyncNotifier`), Drift (read-only for tests), `flutter_test`

---

### Context you need

**`EventType` enum** (in `lib/models/counter_entry.dart`):
```dart
enum EventType { value, start, continueEvent, finish }
```

**State derived from `lastEntry`:**
| `lastEntry` | State |
|---|---|
| `null` | NotStarted |
| `eventType == start \| continueEvent` | Ongoing |
| `eventType == finish` | Finished |

**Button behaviour:**
| State | Action logged | Icon |
|---|---|---|
| NotStarted | `EventType.start` | `Icons.play_arrow` |
| Ongoing | `EventType.continueEvent` | `Icons.fast_forward` |
| Finished | `EventType.start` (new cycle) | `Icons.replay` |

**Only file changed:** `lib/screens/counter_list/counter_cell.dart`

Existing structure to know:
- `CounterCell` is a `ConsumerWidget` — `build(BuildContext context, WidgetRef ref)`
- `_showQuickActions` getter controls numeric step buttons
- `_handleStep(ref, lastEntry, multiplier)` logs a numeric entry — follow the same pattern for `_handleEventStep`
- `final lastEntry = lastEntryAsync.valueOrNull;` is already declared in `build`
- `final l10n = AppLocalizations.of(context)!;` is already declared in `build`
- Existing imports already cover `uuid`, `entries_provider`, `models`

---

### Task 1: Write failing unit tests for `eventStepIcon`

**Files:**
- Create: `test/screens/counter_cell_test.dart`

**Step 1: Create the test file**

```dart
import 'package:counters/models/models.dart';
import 'package:counters/screens/counter_list/counter_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.now();

  group('eventStepIcon', () {
    test('returns play_arrow when lastEntry is null (not started)', () {
      expect(eventStepIcon(null), Icons.play_arrow);
    });

    test('returns fast_forward when lastEntry.eventType is start (ongoing)', () {
      final entry = CounterEntry(
        id: 'e1',
        counterId: 'c1',
        eventType: EventType.start,
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(eventStepIcon(entry), Icons.fast_forward);
    });

    test('returns fast_forward when lastEntry.eventType is continueEvent (ongoing)', () {
      final entry = CounterEntry(
        id: 'e2',
        counterId: 'c1',
        eventType: EventType.continueEvent,
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(eventStepIcon(entry), Icons.fast_forward);
    });

    test('returns replay when lastEntry.eventType is finish (finished)', () {
      final entry = CounterEntry(
        id: 'e3',
        counterId: 'c1',
        eventType: EventType.finish,
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(eventStepIcon(entry), Icons.replay);
    });
  });
}
```

**Step 2: Run tests to verify they fail**

```bash
flutter test test/screens/counter_cell_test.dart
```

Expected: compile error or test failure — `eventStepIcon` does not exist yet.

---

### Task 2: Implement the feature and make tests pass

**Files:**
- Modify: `lib/screens/counter_list/counter_cell.dart`

**Step 1: Add `eventStepIcon` as a top-level function**

Add this immediately after the existing `_formatValue` function (around line 30), before the `CounterCell` class declaration:

```dart
/// Selects the icon for the event step button based on the last entry's state.
/// Exported at library level so it can be unit-tested.
IconData eventStepIcon(CounterEntry? lastEntry) {
  if (lastEntry == null) return Icons.play_arrow;
  if (lastEntry.eventType == EventType.finish) return Icons.replay;
  return Icons.fast_forward; // start or continueEvent → advance
}
```

**Step 2: Add `_showEventAction` getter to `CounterCell`**

Add immediately after the existing `_showQuickActions` getter:

```dart
bool get _showEventAction => counter.dataType == DataType.event;
```

**Step 3: Add `_handleEventStep` method to `CounterCell`**

Add after the existing `_handleTimestamp` method:

```dart
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
```

**Step 4: Add the event action row in `build`**

In the `build` method, after the `if (_showQuickActions) ...[ ... ],` block and before the `if (lastEntry != null) ...[ ... ],` block, add:

```dart
if (_showEventAction) ...[
  const SizedBox(height: 8),
  Row(
    children: [
      const Spacer(),
      IconButton(
        icon: Icon(eventStepIcon(lastEntry)),
        onPressed: () => _handleEventStep(ref, lastEntry),
        tooltip: (lastEntry?.eventType == EventType.start ||
                  lastEntry?.eventType == EventType.continueEvent)
            ? l10n.buttonContinue
            : l10n.buttonStart,
      ),
    ],
  ),
],
```

**Step 5: Run the unit tests**

```bash
flutter test test/screens/counter_cell_test.dart
```

Expected: 4 tests passing.

**Step 6: Run all tests**

```bash
flutter test
```

Expected: all tests passing.

**Step 7: Run static analysis**

```bash
flutter analyze
```

Expected: `No issues found!`

**Step 8: Commit**

```bash
git add lib/screens/counter_list/counter_cell.dart test/screens/counter_cell_test.dart
git commit -m "feat: add event step button to counter cell"
```
