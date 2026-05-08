// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Counters';

  @override
  String get counterListEmptyTitle => 'No counters yet.';

  @override
  String get counterListEmptySubtitle => 'Tap + to add one.';

  @override
  String get newCounterTitle => 'New Counter';

  @override
  String get editCounterTitle => 'Edit Counter';

  @override
  String get counterDetailHistoryHeader => 'History';

  @override
  String get currentValueLabel => 'Current Value';

  @override
  String get noValuePlaceholder => '—';

  @override
  String get noValueEntry => '(no value)';

  @override
  String get buttonLog => 'Log';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonStart => 'Start';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get buttonFinish => 'Finish';

  @override
  String get buttonReLog => 'Re-Log';

  @override
  String get buttonAddPhoto => 'Add photo';

  @override
  String get buttonFromGallery => 'From gallery';

  @override
  String get buttonCamera => 'Camera';

  @override
  String get buttonPickDateTime => 'Pick date & time';

  @override
  String get deleteCounterDialogTitle => 'Delete Counter';

  @override
  String deleteCounterDialogBody(String name) {
    return 'Delete \"$name\"? This will permanently delete the counter and all its history.';
  }

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldChangeStep => 'Change step (optional)';

  @override
  String get fieldChangeStepError => 'Must be a number';

  @override
  String get fieldNameRequired => 'Name is required';

  @override
  String get fieldComment => 'Comment (optional)';

  @override
  String get fieldNewValue => 'New value';

  @override
  String get fieldTags => 'Add tag';

  @override
  String get labelAutoSave => 'Auto-save after 2 seconds';

  @override
  String get labelDataType => 'Data type';

  @override
  String get labelBackgroundColor => 'Background color';

  @override
  String get dataTypeNumeric => 'Numeric';

  @override
  String get dataTypeDateTime => 'Date/Time';

  @override
  String get dataTypeFreeText => 'Text';

  @override
  String get eventTypeStart => 'Start';

  @override
  String get eventTypeContinue => 'Continue';

  @override
  String get eventTypeFinish => 'Finish';

  @override
  String get eventTypeLog => 'Log';

  @override
  String get sincePreviewLabel => 'since previous';

  @override
  String get chartNotEnoughData => 'Add more entries to see the chart';

  @override
  String get snackbarSaved => 'Saved';

  @override
  String snackbarSaveFailed(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get editEntryTitle => 'Edit Entry';

  @override
  String get noColorOption => 'None';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get errorCounterNotFound => 'Counter not found';

  @override
  String get inlineNoteExpand => 'Add note';

  @override
  String get inlineNoteCollapse => 'Hide note';

  @override
  String get inlineNoteSaved => 'Entry saved';

  @override
  String get dataTypeEvent => 'Event';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSyncTitle => 'Synchronize';

  @override
  String get settingsSyncDescription => 'Synchronize between your devices';
}
