// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Räknare';

  @override
  String get counterListEmptyTitle => 'Inga räknare ännu.';

  @override
  String get counterListEmptySubtitle => 'Tryck + för att lägga till.';

  @override
  String get newCounterTitle => 'Ny räknare';

  @override
  String get editCounterTitle => 'Redigera räknare';

  @override
  String get counterDetailHistoryHeader => 'Historik';

  @override
  String get currentValueLabel => 'Aktuellt värde';

  @override
  String get noValuePlaceholder => '—';

  @override
  String get noValueEntry => '(inget värde)';

  @override
  String get buttonLog => 'Logga';

  @override
  String get buttonSave => 'Spara';

  @override
  String get buttonDelete => 'Ta bort';

  @override
  String get buttonCancel => 'Avbryt';

  @override
  String get buttonStart => 'Starta';

  @override
  String get buttonContinue => 'Fortsätt';

  @override
  String get buttonFinish => 'Avsluta';

  @override
  String get buttonAddPhoto => 'Lägg till foto';

  @override
  String get buttonFromGallery => 'Från galleri';

  @override
  String get buttonCamera => 'Kamera';

  @override
  String get buttonPickDateTime => 'Välj datum och tid';

  @override
  String get deleteCounterDialogTitle => 'Ta bort räknare';

  @override
  String deleteCounterDialogBody(String name) {
    return 'Ta bort \"$name\"? Detta tar permanent bort räknaren och all dess historik.';
  }

  @override
  String get fieldName => 'Namn';

  @override
  String get fieldDescription => 'Beskrivning';

  @override
  String get fieldChangeStep => 'Förändringssteg (valfritt)';

  @override
  String get fieldChangeStepError => 'Måste vara ett tal';

  @override
  String get fieldNameRequired => 'Namn krävs';

  @override
  String get fieldComment => 'Kommentar (valfritt)';

  @override
  String get fieldNewValue => 'Nytt värde';

  @override
  String get fieldTags => 'Lägg till tagg';

  @override
  String get labelAutoSave => 'Autospara efter 2 sekunder';

  @override
  String get labelBehaviorType => 'Beteendetyp';

  @override
  String get labelDataType => 'Datatyp';

  @override
  String get labelBackgroundColor => 'Bakgrundsfärg';

  @override
  String get behaviorTypeValue => 'Värde';

  @override
  String get behaviorTypeEvent => 'Händelse';

  @override
  String get dataTypeInteger => 'Heltal';

  @override
  String get dataTypeFloat => 'Decimaltal';

  @override
  String get dataTypeDateTime => 'Datum/tid';

  @override
  String get dataTypeFreeText => 'Text';

  @override
  String get eventTypeStart => 'Start';

  @override
  String get eventTypeContinue => 'Fortsätt';

  @override
  String get eventTypeFinish => 'Avsluta';

  @override
  String get eventTypeLog => 'Logg';

  @override
  String get sincePreviewLabel => 'sedan föregående';

  @override
  String get chartNotEnoughData =>
      'Lägg till fler poster för att se diagrammet';

  @override
  String get snackbarSaved => 'Sparat';

  @override
  String snackbarSaveFailed(String error) {
    return 'Kunde inte spara: $error';
  }

  @override
  String get editEntryTitle => 'Redigera post';

  @override
  String get noColorOption => 'Ingen';

  @override
  String errorGeneric(String message) {
    return 'Fel: $message';
  }

  @override
  String get errorCounterNotFound => 'Räknare hittades inte';

  @override
  String get inlineNoteExpand => 'Lägg till anteckning';

  @override
  String get inlineNoteCollapse => 'Dölj anteckning';

  @override
  String get inlineNoteSaved => 'Inlägg sparat';
}
