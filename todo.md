# Counters App — Implementation Checklist

---

## Step 1 — Project Setup

- [ ] Add `drift` to `pubspec.yaml`
- [ ] Add `drift_flutter` to `pubspec.yaml`
- [ ] Add `sqlite3_flutter_libs` to `pubspec.yaml`
- [ ] Add `riverpod` to `pubspec.yaml`
- [ ] Add `flutter_riverpod` to `pubspec.yaml`
- [ ] Add `riverpod_annotation` to `pubspec.yaml`
- [ ] Add `go_router` to `pubspec.yaml`
- [ ] Add `fl_chart` to `pubspec.yaml`
- [ ] Add `image_picker` to `pubspec.yaml`
- [ ] Add `uuid` to `pubspec.yaml`
- [ ] Add `intl` to `pubspec.yaml`
- [ ] Add `flutter_localizations` (sdk: flutter) to `pubspec.yaml`
- [ ] Add `build_runner` to dev dependencies
- [ ] Add `drift_dev` to dev dependencies
- [ ] Add `riverpod_generator` to dev dependencies
- [ ] Run `flutter pub get` — no errors
- [ ] Replace `lib/main.dart` with `ProviderScope` + `MaterialApp.router`
- [ ] Set up `GoRouter` with placeholder route `/`
- [ ] Add stub routes `/counter/new` and `/counter/:id`
- [ ] Apply Material 3 theme (`useMaterial3: true`) with neutral seed color
- [ ] Delete `test/widget_test.dart`
- [ ] Run `flutter run` — placeholder screen visible, no errors

---

## Step 2 — Domain Model Classes

- [ ] Create `lib/models/` directory
- [ ] Define `BehaviorType` enum (`value`, `event`) in `lib/models/counter.dart`
- [ ] Define `DataType` enum (`integer`, `float`, `datetime`, `freeText`) in `lib/models/counter.dart`
- [ ] Define `Counter` class with all fields: `id`, `name`, `description`, `behaviorType`, `dataType`, `tags`, `changeStep`, `backgroundColor`, `autoSaveDelay`, `createdAt`, `updatedAt`, `deletedAt`
- [ ] Add `copyWith` method to `Counter`
- [ ] Define `EventType` enum (`value`, `start`, `continueEvent`, `finish`) in `lib/models/counter_entry.dart`
- [ ] Define `CounterEntry` class with all fields: `id`, `counterId`, `eventType`, `value`, `comment`, `recordedAt`, `createdAt`, `updatedAt`, `deletedAt`
- [ ] Add `copyWith` method to `CounterEntry`
- [ ] Add `numericValue` getter to `CounterEntry` (returns `double?`)
- [ ] Define `EntryPhoto` class with fields: `id`, `entryId`, `localPath`, `createdAt`, `deletedAt`
- [ ] Create `lib/models/models.dart` barrel file exporting all three models
- [ ] Run `flutter analyze` — zero issues

---

## Step 3 — Database: Counters Table

- [ ] Create `lib/db/` directory
- [ ] Create `lib/db/database.dart` with `AppDatabase` class annotated `@DriftDatabase`
- [ ] Configure drift to use `driftDatabase(name: 'counters.db')`
- [ ] Define `Counters` drift table:
  - [ ] `id` TEXT primary key
  - [ ] `name` TEXT
  - [ ] `description` TEXT with default `''`
  - [ ] `behavior_type` TEXT (enum as string)
  - [ ] `data_type` TEXT (enum as string)
  - [ ] `tags` TEXT (JSON array, default `'[]'`)
  - [ ] `change_step` TEXT nullable
  - [ ] `background_color` INTEGER nullable (ARGB)
  - [ ] `auto_save_delay` BOOLEAN with default `false`
  - [ ] `created_at` DateTimeColumn
  - [ ] `updated_at` DateTimeColumn
  - [ ] `deleted_at` DateTimeColumn nullable
- [ ] Create `lib/db/daos/counters_dao.dart` with `@DriftAccessor`
- [ ] Implement `watchAllCounters()` — stream excluding soft-deleted
- [ ] Implement `getCounterById(String id)`
- [ ] Implement `insertCounter(Counter c)`
- [ ] Implement `updateCounter(Counter c)` — sets `updated_at`
- [ ] Implement `softDeleteCounter(String id)` — sets `deleted_at`
- [ ] Each DAO method maps drift rows ↔ `Counter` domain model
- [ ] Create `lib/db/app_database_provider.dart` exposing singleton `AppDatabase`
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs` — no errors
- [ ] Run `flutter analyze` — zero issues

---

## Step 4 — Database: Entries + Photos Tables

- [ ] Add `CounterEntries` drift table to `lib/db/database.dart`:
  - [ ] `id` TEXT primary key
  - [ ] `counter_id` TEXT (FK to Counters)
  - [ ] `event_type` TEXT (enum as string)
  - [ ] `value` TEXT nullable
  - [ ] `comment` TEXT nullable
  - [ ] `recorded_at` DateTimeColumn
  - [ ] `created_at`, `updated_at`, `deleted_at` DateTimeColumns
- [ ] Add `EntryPhotos` drift table to `lib/db/database.dart`:
  - [ ] `id` TEXT primary key
  - [ ] `entry_id` TEXT (FK to CounterEntries)
  - [ ] `local_path` TEXT
  - [ ] `created_at` DateTimeColumn
  - [ ] `deleted_at` DateTimeColumn nullable
- [ ] Add both tables to `@DriftDatabase` tables list
- [ ] Create `lib/db/daos/entries_dao.dart`:
  - [ ] `watchEntriesForCounter(String counterId)` — newest-first, excludes soft-deleted
  - [ ] `getLastEntryForCounter(String counterId)`
  - [ ] `insertEntry(CounterEntry e)`
  - [ ] `updateEntry(CounterEntry e)` — sets `updated_at`
  - [ ] `softDeleteEntry(String id)`
- [ ] Create `lib/db/daos/photos_dao.dart`:
  - [ ] `watchPhotosForEntry(String entryId)` — excludes soft-deleted
  - [ ] `insertPhoto(EntryPhoto p)`
  - [ ] `softDeletePhoto(String id)`
- [ ] Run `build_runner` again — no errors
- [ ] Run `flutter analyze` — zero issues

---

## Step 5 — Riverpod Providers

- [ ] Create `lib/providers/` directory
- [ ] Create `lib/providers/database_provider.dart` — `Provider<AppDatabase>` singleton
- [ ] Create `lib/providers/counters_provider.dart`:
  - [ ] `countersProvider` — `StreamProvider<List<Counter>>` watching `CountersDao.watchAllCounters()`
  - [ ] `CounterNotifier` with `createCounter(Counter c)`
  - [ ] `CounterNotifier` with `updateCounter(Counter c)`
  - [ ] `CounterNotifier` with `deleteCounter(String id)`
- [ ] Create `lib/providers/entries_provider.dart`:
  - [ ] `entriesForCounterProvider(String counterId)` — `StreamProvider<List<CounterEntry>>`
  - [ ] `lastEntryProvider(String counterId)` — `FutureProvider<CounterEntry?>`
  - [ ] `EntryNotifier(String counterId)` with `addEntry(CounterEntry e)`
  - [ ] `EntryNotifier` with `updateEntry(CounterEntry e)`
- [ ] Create `lib/providers/photos_provider.dart`:
  - [ ] `photosForEntryProvider(String entryId)` — `StreamProvider<List<EntryPhoto>>`
  - [ ] `PhotoNotifier(String entryId)` with `addPhoto(EntryPhoto p)`
  - [ ] `PhotoNotifier` with `deletePhoto(String id)`
- [ ] Run `build_runner` if using code generation
- [ ] Run `flutter analyze` — zero issues

---

## Step 6 — Main List Screen

- [ ] Create `lib/screens/counter_list/` directory
- [ ] Create `lib/screens/counter_list/counter_list_screen.dart` as `ConsumerWidget`
- [ ] Show `CircularProgressIndicator` while `countersProvider` is loading
- [ ] Show empty state (icon + message) when list is empty
- [ ] Show `ListView.builder` of counter cells when list has items
- [ ] Add `FloatingActionButton` (+ icon) navigating to `/counter/new`
- [ ] Create `lib/screens/counter_list/counter_cell.dart`:
  - [ ] Display counter `name` as title
  - [ ] Display `'—'` as placeholder current value
  - [ ] Display tags as small chips in footer row
  - [ ] Apply `counter.backgroundColor` as card background (fallback to default)
  - [ ] Entire card tappable → navigates to `/counter/:id`
- [ ] Wire `/` route to `CounterListScreen`
- [ ] Keep `/counter/new` and `/counter/:id` as stubs (`Text('Coming soon')`)
- [ ] Run the app — empty state visible, FAB navigates to stub

---

## Step 7 — Counter Cell Quick Actions

- [ ] Add `lastEntryProvider` watch to `CounterCell`
- [ ] Replace `'—'` placeholder with `lastEntry?.value ?? '—'` in cell
- [ ] Conditionally show quick-action row when `changeStep != null` and dataType is `integer` or `float`
- [ ] Implement **−** button:
  - [ ] Computes `lastNumericValue − changeStep`
  - [ ] Falls back to `−changeStep` if no previous numeric value
  - [ ] Creates `CounterEntry` with `EventType.value`, calls `EntryNotifier.addEntry`
- [ ] Implement **+** button:
  - [ ] Computes `lastNumericValue + changeStep`
  - [ ] Falls back to `+changeStep` if no previous numeric value
  - [ ] Creates `CounterEntry` with `EventType.value`, calls `EntryNotifier.addEntry`
- [ ] Implement **⏺** button:
  - [ ] Copies last entry's value (no value change)
  - [ ] Creates `CounterEntry` with new timestamp only, calls `EntryNotifier.addEntry`
- [ ] Format result values correctly (0 decimals for integer, ≤2 for float, trim trailing zeros)
- [ ] Verify buttons appear only for qualifying counters

---

## Step 8 — Edit/Create Screen: Form UI

- [ ] Create `lib/screens/counter_edit/` directory
- [ ] Create `lib/screens/counter_edit/counter_edit_screen.dart`
- [ ] Accept optional `Counter? initialCounter` parameter
- [ ] AppBar title: "New Counter" (create) or "Edit Counter" (edit)
- [ ] Build `SingleChildScrollView` form with:
  - [ ] **Name** — `TextFormField`, required, autofocuses on create
  - [ ] **Description** — `TextFormField`, optional, multiline
  - [ ] **Behavior type** — `SegmentedButton<BehaviorType>` (Value / Event)
  - [ ] **Data type** — `SegmentedButton<DataType>` (Integer / Float / Date/Time / Text)
  - [ ] **Change step** — `TextFormField`, numeric keyboard, shown only for Integer/Float
  - [ ] **Auto-save** — `SwitchListTile`
  - [ ] **Tags** — `TagInputField` widget showing chips + text input for adding
  - [ ] **Background color** — row of 8–10 preset color swatches + "none" option
- [ ] Hold all form state in `StatefulWidget` or local `StateProvider`
- [ ] Wire `/counter/new` route to this screen (`initialCounter: null`)
- [ ] Wire `/counter/:id/edit` route to this screen (pass matching counter)
- [ ] Run the app — navigate to New Counter, all fields render and respond

---

## Step 9 — Edit/Create Screen: Persistence

- [ ] Add **Save** button to AppBar actions (or bottom CTA)
- [ ] Validate form — name must be non-empty, show error if blank
- [ ] On save (create path):
  - [ ] Generate UUID for `id`
  - [ ] Set `createdAt = updatedAt = DateTime.now()`
  - [ ] Call `CounterNotifier.createCounter(newCounter)`
  - [ ] Navigate to `/`
- [ ] On save (edit path):
  - [ ] `copyWith` from `initialCounter` with updated fields + new `updatedAt`
  - [ ] Call `CounterNotifier.updateCounter(updatedCounter)`
  - [ ] Pop navigation
- [ ] Add **Delete** button to AppBar actions (edit mode only, trash icon)
- [ ] Show `AlertDialog` on delete tap with counter name, confirm/cancel actions
- [ ] On confirm delete:
  - [ ] Call `CounterNotifier.deleteCounter(id)`
  - [ ] Navigate to `/`
- [ ] Update counter cell tap to navigate to `/counter/:id/edit`
- [ ] End-to-end test: create → appears in list; edit → changes reflected; delete → removed

---

## Step 10 — Detail Screen: Value Display + Input

- [ ] Create `lib/screens/counter_detail/` directory
- [ ] Create `lib/screens/counter_detail/counter_detail_screen.dart`
- [ ] Wire `/counter/:id` route to this screen (replace stub)
- [ ] AppBar: counter name as title, edit icon navigating to `/counter/:id/edit`
- [ ] **Current value card**: watches `lastEntryProvider(counterId)`, shows `entry.value ?? '—'` prominently
- [ ] **Value input field**:
  - [ ] Keyboard type adapts: Integer → number, Float → decimal, DateTime → text, Free text → multiline
  - [ ] For DateTime: button opens `showDatePicker` + `showTimePicker`, formats as ISO 8601
- [ ] **Log button** (`ElevatedButton`)
- [ ] On Log tap:
  - [ ] Validate text field is non-empty
  - [ ] Create `CounterEntry` with new UUID, `EventType.value`, trimmed value, `recordedAt = now`
  - [ ] Call `EntryNotifier.addEntry(entry)`
  - [ ] Clear text field
  - [ ] Current value card updates reactively
- [ ] Add placeholder `Text('History coming in next step')` below input
- [ ] Run the app — log values, current value card updates correctly

---

## Step 11 — Detail Screen: Step Buttons and Event Buttons

- [ ] **Step buttons** (Integer/Float + `changeStep != null`):
  - [ ] Row of two `OutlinedButton`s above text field
  - [ ] **−** button: computes `lastNumericValue − changeStep`, creates entry
  - [ ] **+** button: computes `lastNumericValue + changeStep`, creates entry
  - [ ] Fallback to `±changeStep` if no previous numeric value
  - [ ] Format precision correctly (0 decimals integer, ≤2 float)
- [ ] **Event buttons** (`behaviorType == BehaviorType.event`):
  - [ ] Row of three `FilledButton.tonal` buttons
  - [ ] **Start** → entry with `EventType.start`
  - [ ] **Continue** → entry with `EventType.continueEvent`
  - [ ] **Finish** → entry with `EventType.finish`
  - [ ] All three always visible, regardless of cycle state
  - [ ] Each uses current text field value (may be empty)
- [ ] **Log** button remains for plain value entries on event counters
- [ ] Verify: integer counter with step shows ± buttons; event counter shows 3 event buttons

---

## Step 12 — Detail Screen: Auto-Save Timer

- [ ] Add `Timer? _autoSaveTimer` field to screen state
- [ ] In text field `onChanged`:
  - [ ] If `counter.autoSaveDelay == true`: cancel existing timer, start new 2-second timer
  - [ ] If false: no timer action
- [ ] Implement `_saveEntry()`:
  - [ ] Read current text field value
  - [ ] If non-empty: create and save `CounterEntry`
  - [ ] Clear text field
  - [ ] Show `SnackBar('Saved')` briefly
- [ ] Cancel timer in `dispose()` to prevent callbacks after widget removal
- [ ] Log button remains functional even when auto-save is on
- [ ] Test: enable auto-save counter, type value, wait 2 seconds — entry saved without tapping Log

---

## Step 13 — Detail Screen: History List

- [ ] Watch `entriesForCounterProvider(counterId)` in detail screen
- [ ] Create `lib/screens/counter_detail/history_entry_tile.dart`
  - [ ] Accepts `CounterEntry entry` and `Counter counter`
  - [ ] Shows value in bold (`entry.value ?? '(no value)'`)
  - [ ] For event counters: shows colored chip/badge per event type:
    - [ ] `start` → green "Start"
    - [ ] `continueEvent` → blue "Continue"
    - [ ] `finish` → orange "Finish"
    - [ ] `value` → grey "Log"
  - [ ] Shows formatted timestamp (`dd MMM yyyy, HH:mm` via `DateFormat`)
  - [ ] Shows comment preview (grey, italic) if comment is non-null/non-empty
- [ ] Convert detail screen layout to `CustomScrollView` with:
  - [ ] `SliverAppBar`
  - [ ] `SliverToBoxAdapter` for input section
  - [ ] `SliverList` for history entries
- [ ] History list ordered newest-first
- [ ] Test: log 4–5 entries of mixed types — all appear with correct labels and timestamps

---

## Step 14 — History: Duration and Value Diff

- [ ] Pass `previousEntry` (adjacent older entry) into each `HistoryEntryTile`
- [ ] **Duration display**:
  - [ ] Compute `duration = entry.recordedAt.difference(previousEntry.recordedAt).abs()`
  - [ ] Implement duration formatter helper:
    - [ ] < 60s → "Xs"
    - [ ] < 3600s → "Xm Xs"
    - [ ] < 86400s → "Xh Xm"
    - [ ] else → "Xd Xh"
  - [ ] Show "⏱ Xh Xm since previous" below timestamp in small grey font
  - [ ] No duration row for the oldest entry (no previous)
- [ ] **Value diff display**:
  - [ ] Attempt `double.tryParse` on both current and previous values
  - [ ] If both succeed: compute diff = current − previous
  - [ ] Show with sign: "+3.5" (green) or "−1" (red)
  - [ ] If either parse fails: show nothing silently
- [ ] Test: log 4 numeric entries — durations and diffs correct; insert a text entry — diff absent for its neighbors only

---

## Step 15 — History Entry Editing: Comment

- [ ] Make `HistoryEntryTile` tappable (`InkWell`) with `onTap` callback
- [ ] In detail screen, implement `_onEntryTap(CounterEntry entry)`:
  - [ ] Show `showModalBottomSheet`
  - [ ] Sheet contains `TextFormField` pre-populated with `entry.comment ?? ''`
  - [ ] "Save" button and "Cancel" option (dismiss via drag)
- [ ] On save:
  - [ ] Call `EntryNotifier.updateEntry(entry.copyWith(comment: newComment, updatedAt: now))`
  - [ ] Dismiss sheet
  - [ ] Tile updates reactively
- [ ] Add comment icon (`Icons.comment_outlined`) in tile trailing area when comment exists
- [ ] Test: add comment, close screen, reopen — comment persists from DB

---

## Step 16 — Photos

- [ ] Add `path_provider` to `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Extend modal bottom sheet from Step 15:
  - [ ] Watch `photosForEntryProvider(entry.id)` inside sheet
  - [ ] Show existing photos as horizontal `ListView` of 72×72 thumbnails (`Image.file`)
  - [ ] Each thumbnail has a delete (×) icon overlay
  - [ ] "Add photo" row with "From gallery" and "Camera" `OutlinedButton`s
- [ ] On "From gallery": `ImagePicker().pickImage(source: ImageSource.gallery)`
- [ ] On "Camera": `ImagePicker().pickImage(source: ImageSource.camera)`
- [ ] Copy picked file to `{appDocDir}/photos/{uuid}{ext}`
- [ ] Create `EntryPhoto` and call `PhotoNotifier.addPhoto(photo)`
- [ ] On delete (×):
  - [ ] Call `PhotoNotifier.deletePhoto(photo.id)`
  - [ ] Delete file from disk: `File(photo.localPath).deleteSync()`
- [ ] In `HistoryEntryTile`: watch `photosForEntryProvider(entry.id)`, show 48×48 thumbnail strip if photos exist
- [ ] Add iOS permissions to `ios/Runner/Info.plist`:
  - [ ] `NSCameraUsageDescription`
  - [ ] `NSPhotoLibraryUsageDescription`
- [ ] Add Android permissions to `android/app/src/main/AndroidManifest.xml`:
  - [ ] `READ_MEDIA_IMAGES`
  - [ ] `CAMERA`
- [ ] Test on device/simulator: attach photo from gallery → thumbnail in sheet and tile

---

## Step 17 — Graph

- [ ] Create `lib/screens/counter_detail/counter_history_chart.dart`
- [ ] Accept `List<CounterEntry> entries` and `Counter counter`
- [ ] Return `SizedBox.shrink()` if dataType is not `integer` or `float`
- [ ] Filter entries to those where `numericValue != null`
- [ ] If fewer than 2 valid entries: show centered message in fixed-height container (160px)
- [ ] Build `LineChart` from `fl_chart`:
  - [ ] X axis: entry index or `recordedAt` milliseconds
  - [ ] Y axis: numeric value
  - [ ] Minimal clean look (no heavy grid lines)
  - [ ] Single line with dots at data points
  - [ ] Wrap in `SizedBox(height: 160)` with horizontal padding
- [ ] Insert `CounterHistoryChart` in `SliverToBoxAdapter` between input area and history list
- [ ] Chart updates reactively (uses same stream data as history list)
- [ ] Test: log 5–6 numeric values — chart renders and updates; log a text value — it is skipped silently

---

## Step 18 — Localisation

- [ ] Add `generate: true` under `flutter:` in `pubspec.yaml`
- [ ] Create `l10n.yaml` at project root with arb-dir, template file, and output file settings
- [ ] Create `lib/l10n/` directory
- [ ] Create `lib/l10n/intl_en.arb` with all English strings:
  - [ ] App title
  - [ ] Screen titles (Counters, New Counter, Edit Counter)
  - [ ] Empty state message
  - [ ] Button labels: Log, Save, Delete, Cancel, Start, Continue, Finish
  - [ ] Button labels: Add photo, From gallery, Camera
  - [ ] Delete confirmation dialog title and body
  - [ ] Field labels: Name, Description, Behavior type, Data type, Tags, Change step, Auto-save, Background color
  - [ ] Segment labels: Value, Event, Integer, Float, Date/Time, Text
  - [ ] History metadata: duration format strings, "since previous"
  - [ ] Value diff labels (positive/negative indicators)
  - [ ] Snackbar message: "Saved"
  - [ ] Validation error: name required
  - [ ] Chart placeholder message
  - [ ] "(no value)" entry placeholder
- [ ] Create `lib/l10n/intl_sv.arb` with Swedish translation for every key
- [ ] Add `localizationsDelegates` and `supportedLocales` to `MaterialApp.router` in `main.dart`
- [ ] Replace every hardcoded UI string across all screens and widgets with `AppLocalizations.of(context)!.keyName`
- [ ] Run `flutter gen-l10n` — no errors
- [ ] Run `flutter analyze` — zero issues
- [ ] Test English: all strings in English
- [ ] Test Swedish: change system language to Swedish, relaunch — all strings in Swedish
