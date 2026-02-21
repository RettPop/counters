import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sv')
  ];

  /// App title shown in the list screen app bar
  ///
  /// In en, this message translates to:
  /// **'Counters'**
  String get appTitle;

  /// No description provided for @counterListEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No counters yet.'**
  String get counterListEmptyTitle;

  /// No description provided for @counterListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add one.'**
  String get counterListEmptySubtitle;

  /// No description provided for @newCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'New Counter'**
  String get newCounterTitle;

  /// No description provided for @editCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Counter'**
  String get editCounterTitle;

  /// No description provided for @counterDetailHistoryHeader.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get counterDetailHistoryHeader;

  /// No description provided for @currentValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Value'**
  String get currentValueLabel;

  /// No description provided for @noValuePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get noValuePlaceholder;

  /// No description provided for @noValueEntry.
  ///
  /// In en, this message translates to:
  /// **'(no value)'**
  String get noValueEntry;

  /// No description provided for @buttonLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get buttonLog;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get buttonStart;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @buttonFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get buttonFinish;

  /// No description provided for @buttonAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get buttonAddPhoto;

  /// No description provided for @buttonFromGallery.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get buttonFromGallery;

  /// No description provided for @buttonCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get buttonCamera;

  /// No description provided for @buttonPickDateTime.
  ///
  /// In en, this message translates to:
  /// **'Pick date & time'**
  String get buttonPickDateTime;

  /// No description provided for @deleteCounterDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Counter'**
  String get deleteCounterDialogTitle;

  /// No description provided for @deleteCounterDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This will permanently delete the counter and all its history.'**
  String deleteCounterDialogBody(String name);

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @fieldChangeStep.
  ///
  /// In en, this message translates to:
  /// **'Change step (optional)'**
  String get fieldChangeStep;

  /// No description provided for @fieldChangeStepError.
  ///
  /// In en, this message translates to:
  /// **'Must be a number'**
  String get fieldChangeStepError;

  /// No description provided for @fieldNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get fieldNameRequired;

  /// No description provided for @fieldComment.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get fieldComment;

  /// No description provided for @fieldNewValue.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get fieldNewValue;

  /// No description provided for @fieldTags.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get fieldTags;

  /// No description provided for @labelAutoSave.
  ///
  /// In en, this message translates to:
  /// **'Auto-save after 2 seconds'**
  String get labelAutoSave;

  /// No description provided for @labelBehaviorType.
  ///
  /// In en, this message translates to:
  /// **'Behavior type'**
  String get labelBehaviorType;

  /// No description provided for @labelDataType.
  ///
  /// In en, this message translates to:
  /// **'Data type'**
  String get labelDataType;

  /// No description provided for @labelBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get labelBackgroundColor;

  /// No description provided for @behaviorTypeValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get behaviorTypeValue;

  /// No description provided for @behaviorTypeEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get behaviorTypeEvent;

  /// No description provided for @dataTypeInteger.
  ///
  /// In en, this message translates to:
  /// **'Integer'**
  String get dataTypeInteger;

  /// No description provided for @dataTypeFloat.
  ///
  /// In en, this message translates to:
  /// **'Float'**
  String get dataTypeFloat;

  /// No description provided for @dataTypeDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get dataTypeDateTime;

  /// No description provided for @dataTypeFreeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get dataTypeFreeText;

  /// No description provided for @eventTypeStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get eventTypeStart;

  /// No description provided for @eventTypeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get eventTypeContinue;

  /// No description provided for @eventTypeFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get eventTypeFinish;

  /// No description provided for @eventTypeLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get eventTypeLog;

  /// No description provided for @sincePreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'since previous'**
  String get sincePreviewLabel;

  /// No description provided for @chartNotEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Add more entries to see the chart'**
  String get chartNotEnoughData;

  /// No description provided for @snackbarSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get snackbarSaved;

  /// No description provided for @snackbarSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String snackbarSaveFailed(String error);

  /// No description provided for @editEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntryTitle;

  /// No description provided for @noColorOption.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noColorOption;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @errorCounterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Counter not found'**
  String get errorCounterNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
