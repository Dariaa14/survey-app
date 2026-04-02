/// This class contains all the string constants used in the app.
class AppStrings {
  /// The title of the app.
  static const String appTitle = "SurveyApp";

  // Authentication page:
  /// The title of the authentication page.
  static const String authTitle = "Autentificare";

  /// The hint text for the email field.
  static const String emailHint = "Email";

  /// The hint text for the password field.
  static const String passwordHint = "Parolă";

  /// The text for the login button.
  static const String loginButton = "Login";

  /// The text for the sign up button.
  static const String noAccountButton = "Nu ai cont? Înregistrează-te";

  // Admin surveys list page:
  /// The title of the admin surveys list page.
  static const String adminSurveysTitle = "Sondaje";

  /// The title of the contacts list page.
  static const String contactsListTitle = "Liste contacte";

  /// The text for the "Create Survey" button.
  static const String createSurveyButton = "+    Sondaj nou";

  /// The text for the create email list button.
  static const String createEmailListButton = "+    Listă nouă";

  /// The title for the "My Surveys" section.
  static const String mySurveysTitle = "Sondajele mele";

  /// The text for the "All" filter button.
  static const String allFilterButton = "Toate";

  /// The text for the "Draft" filter button.
  static const String draftFilterButton = "Draft";

  /// The text for the "Published" filter button.
  static const String publishedFilterButton = "Published";

  /// The text for the "Closed" filter button.
  static const String closedFilterButton = "Closed";

  /// Formats the survey preview metadata line.
  static String surveyPreviewMeta(
    String slug,
    int questionCount,
    DateTime createdAt,
  ) =>
      "slug: $slug · $questionCount întrebări · creat ${_formatShortRoDate(createdAt)}";

  static String _formatShortRoDate(DateTime date) {
    const List<String> shortMonths = <String>[
      'ian',
      'feb',
      'mar',
      'apr',
      'mai',
      'iun',
      'iul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];

    return '${date.day} ${shortMonths[date.month - 1]}';
  }

  /// Formats the published survey info line.
  static String surveyPublishedInfo(int invitations, String submitRate) =>
      "$invitations invitații · rată răspuns $submitRate%";

  /// Info text displayed for draft surveys.
  static const String surveyDraftInfo = "Invitațiile nu pot fi trimise încă";

  /// Action label for viewing survey results.
  static const String surveyResultsButton = "Rezultate";

  /// Action label for closing a published survey.
  static const String surveyCloseButton = "Închide";

  /// Action label for editing a draft survey.
  static const String surveyEditButton = "Editează";

  /// Action label for publishing a draft survey.
  static const String surveyPublishButton = "Publică";

  /// Confirmation message shown before closing a survey.
  static const String surveyCloseConfirmMessage =
      "Ești sigur? Respondenții nu vor mai putea accesa sondajul.";

  /// Confirmation message shown before deleting an email list.
  static const String emailListDeleteConfirmMessage =
      "Ești sigur? Lista de contacte va fi ștearsă definitiv.";

  /// Confirmation option for closing a survey.
  static const String yesOption = "Da";

  /// Cancellation option for closing a survey.
  static const String noOption = "Nu";

  // Create/edit survey page:
  /// The title for the survey details section.
  static const String surveyDetailsTitle = "Detalii sondaj";

  /// The label for the survey title field.
  static const String surveyTitleLabel = "Titlu *";

  /// The label for the survey description field.
  static const String surveyDescriptionLabel = "Descriere";

  /// The label for the survey slug field.
  static const String surveySlugLabel = "Slug *";

  /// The helper text for the survey slug field.
  static const String autoGenerateSlugHelperText =
      "Auto-generat din titlu, editabil";

  /// Placeholder for the survey title field.
  static const String surveyTitlePlaceholder = "Ex: Feedback produs nou";

  /// Placeholder for the survey description field.
  static const String surveyDescriptionPlaceholder =
      "Ex: Te rog să ne dai feedback despre noul produs lansat în ianuarie.";

  /// Placeholder for the survey slug field.
  static const String surveySlugPlaceholder = "Ex: feedback-produs-nou";

  /// The title for the actions section.
  static const String actionsTitle = "Acțiuni";

  /// The text for the "Save" button in the survey builder.
  static const String saveSurveyButton = "Salvează draft";

  /// The text for the "Publish" button in the survey builder.
  static const String publishSurveyButton = "Publică sondaj";

  /// The title prefix for the survey questions section.
  static const String questionsTitle = "Întrebări";

  // Question builder page:
  /// The title shown at the top of the question builder page.
  static const String editQuestionTitle = "Editează întrebare";

  /// Tab label for multi-choice question type.
  static const String multiChoiceTab = "Multi-choice";

  /// Tab label for free-text question type.
  static const String freeTextTab = "Text liber";

  /// The label for the question text field.
  static const String questionTextLabel = "Textul întrebării";

  /// Placeholder for the question text input.
  static const String questionTextPlaceholder =
      "Ex: Ce funcționalitate ai folosit cel mai mult?";

  /// The label for the "Required" checkbox.
  static const String requiredLabel = "Required";

  /// The label for optional question state.
  static const String optionalLabel = "Optional";

  /// The text for the "Add Option" button in the multi-choice question builder.
  static const String addOptionButton = "Adaugă opțiune";

  /// The text for adding a new question from questions preview list.
  static const String addQuestionButton = "Adaugă întrebare";

  /// The text for the "Cancel" button in the question builder.
  static const String cancelButton = "Anulează";

  /// The text for the "Save" button in the question builder.
  static const String saveButton = "Salvează";

  /// The label for edit button in question preview.
  static const String questionPreviewEditButton = "Edit";

  /// Formats the max selections text in question preview.
  static String questionPreviewMaxSelections(int value) =>
      "max $value selecții";

  /// Formats the max characters text in question preview.
  static String questionPreviewMaxCharacters(int value) =>
      "max $value caractere";

  /// Formats the options text in question preview.
  static String questionPreviewOptions(List<String> labels) {
    if (labels.isEmpty) {
      return 'Opțiuni: -';
    }

    return 'Opțiuni: ${labels.join(' · ')}';
  }

  /// The label for the maximum numbers of options field in the multi-choice
  /// question builder.
  static const String maxOptionsLabel = "Selecții maxime";

  /// Placeholder for maximum selections input.
  static const String maxOptionsPlaceholder = "Ex: 2";

  /// The label for max character length in free-text question builder.
  static const String maxCharactersLabel = "Lungime maximă caractere";

  /// Placeholder for max character length input.
  static const String maxCharactersPlaceholder = "Ex: 1000";

  /// The label for the number of options field in the multi-choice question
  /// builder.
  static String numberOfOptionsLabel(int minOptions) =>
      "Opțiuni (minim $minOptions)";

  /// Warning message when trying to save a multi-choice question with less than
  /// the minimum required options.
  static String warningMinimumOptions(int minOptions) =>
      "Trebuie minim $minOptions opțiuni.";

  /// Validation message shown when required question fields are invalid.
  static const String questionBuilderInvalidFieldsMessage =
      "Completează toate câmpurile obligatorii cu valori valide.";

  /// Validation message shown when option labels are empty.
  static const String questionBuilderEmptyOptionsMessage =
      "Toate opțiunile trebuie completate.";

  /// Validation message shown when survey required fields are empty.
  static const String surveyBuilderInvalidFieldsMessage =
      "Completează titlul, descrierea și slug-ul.";

  /// Validation message shown when a survey has no questions.
  static const String surveyBuilderMissingQuestionsMessage =
      "Adaugă cel puțin o întrebare înainte de salvare/publicare.";

  /// Formats the contact list preview metadata line.
  static String contactsListPreviewMeta(int contactsCount, DateTime createdAt) {
    return "$contactsCount contacte · creată ${_formatShortRoDate(createdAt)}";
  }

  /// Action label for visualizing a contact list.
  static const String contactListPreviewViewButton = 'Vizualizează';

  /// Action label for importing contacts from CSV.
  static const String contactListPreviewImportCsvButton = 'Importă CSV';

  /// Title for add contact list modal.
  static const String addContactListTitle = 'Adaugă listă de contacte';

  /// Hint for contact list name field.
  static const String addContactListNameHint = 'Nume listă';

  // CSV import page:
  /// Title for contacts CSV import page.
  static const String csvImportTitle = 'Importă contacte';

  /// Helper prefix text describing required CSV columns.
  static const String csvImportColumnsPrefix =
      'Fișierul CSV trebuie să aibă coloanele';

  /// CSV required email column label.
  static const String csvImportEmailColumn = 'email';

  /// Connector between required CSV columns.
  static const String csvImportColumnsConnector = 'și';

  /// CSV optional name column label.
  static const String csvImportNameColumn = 'name';

  /// Suffix text for optional CSV name column.
  static const String csvImportNameOptionalSuffix = '(name opțional).';

  /// Folder emoji used in CSV dropzone.
  static const String csvImportDropzoneFolderEmoji = '📁';

  /// CSV dropzone drag-and-drop helper text.
  static const String csvImportDropzoneText = 'Trage fișierul CSV aici sau';

  /// CSV dropzone call-to-action text.
  static const String csvImportChooseFileText = 'alege fișier';

  /// Maximum supported CSV rows info.
  static const String csvImportMaxRowsText = 'Max. 10.000 rânduri';

  /// Information emoji used in import notes box.
  static const String csvImportInfoEmoji = 'ℹ️';

  /// Note explaining duplicate and invalid address handling.
  static const String csvImportInfoText =
      'Adresele duplicate (deja existente în listă) vor fi '
      'ignorate automat. Adresele invalide vor fi afișate '
      'pentru review înainte de import.';

  /// Cancel action for CSV import page.
  static const String csvImportCancelButton = 'Anulează';

  /// Confirm action for CSV import page.
  static const String csvImportImportButton = 'Importă';

  /// Button text while CSV is being uploaded.
  static const String csvImportUploadingButton = 'Se importă...';

  /// Label prefix for selected CSV file.
  static const String csvImportSelectedFilePrefix = 'Fișier selectat:';

  /// Message shown when selected file cannot be read.
  static const String csvImportReadFileErrorMessage =
      'Fișierul selectat nu poate fi citit.';

  /// Message shown when authentication token is unavailable.
  static const String csvImportMissingTokenMessage =
      'Nu există token de autentificare disponibil.';

  /// Title for CSV preview results area.
  static const String csvImportPreviewTitle = 'Rezultate fișier CSV';

  /// Formats CSV preview summary counters.
  static String csvImportSummary(int total, int valid, int invalid) =>
      'Total: $total · Valide: $valid · Invalide: $invalid';

  /// Formats title for valid contacts section.
  static String csvImportValidSectionTitle(int count) => 'Valide ($count)';

  /// Formats title for invalid contacts section.
  static String csvImportInvalidSectionTitle(int count) => 'Invalide ($count)';

  /// Empty label when valid list has no entries.
  static const String csvImportNoValidContacts =
      'Nu există contacte valide în preview.';

  /// Empty label when invalid list has no entries.
  static const String csvImportNoInvalidContacts =
      'Nu există contacte invalide în preview.';

  /// Label for email field in CSV results rows.
  static const String csvImportEmailLabel = 'Email';

  /// Label for name field in CSV results rows.
  static const String csvImportNameLabel = 'Nume';

  /// Label for row field in invalid CSV rows.
  static const String csvImportRowLabel = 'Rând';

  /// Label for invalid reason field in invalid CSV rows.
  static const String csvImportInvalidReasonLabel = 'Motiv';

  /// Placeholder when name is not available.
  static const String csvImportNameMissing = 'Nespecificat';

  /// Placeholder when email is not available.
  static const String csvImportEmailMissing = 'Lipsește';

  /// Formats the contact count summary on the email list page.
  static String emailListPageContactsSummary(int count) =>
      '$count contacte în listă';

  /// Empty state message for the email list page.
  static const String emailListPageEmptyState =
      'Nu există contacte în această listă.';

  /// Button label for deleting a contact.
  static const String emailListPageDeleteContactButton = 'Șterge';

  /// Confirmation message for deleting a contact.
  static const String emailListPageDeleteConfirmMessage =
      'Ești sigur? Contactul va fi șters definitiv din listă.';

  /// Placeholder shown when a contact has no name.
  static const String emailListPageNameMissing = 'Nume indisponibil';
}
