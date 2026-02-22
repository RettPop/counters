# Event Counter Step Button Design

## Goal

Add a single quick-action button to event counter cells in the counter list, allowing the user to advance an event counter's state without opening the detail screen.

## State Model

Event counter state is derived from the last entry's `EventType`:

| Condition | State |
|---|---|
| `lastEntry == null` | NotStarted |
| `lastEntry.eventType == start \| continueEvent` | Ongoing |
| `lastEntry.eventType == finish` | Finished |

## Button Behaviour

| Current State | Action Logged | Icon | Tooltip |
|---|---|---|---|
| NotStarted | `EventType.start` | `Icons.play_arrow` | buttonStart l10n |
| Ongoing | `EventType.continueEvent` | `Icons.fast_forward` | buttonContinue l10n |
| Finished | `EventType.start` (new cycle) | `Icons.replay` | buttonStart l10n |

## Layout

A new action row is added below tags, shown only for event counters. Single `IconButton` right-aligned via `Spacer`:

```
Row: [Spacer]  [▶ / ⏩ / ↺]
```

This mirrors the position of the increment button in the numeric step row.

## Constraints

- The "Finish" transition remains only accessible from the detail screen (Start/Continue/Finish buttons).
- Existing detail-screen event buttons are unchanged.
- No new l10n strings — reuses `buttonStart` and `buttonContinue`.
- No DB, provider, or model changes.

## Files Changed

| File | Change |
|---|---|
| `lib/screens/counter_list/counter_cell.dart` | Add `_showEventAction` getter, `_handleEventStep()` method, new `if (_showEventAction)` UI block |
