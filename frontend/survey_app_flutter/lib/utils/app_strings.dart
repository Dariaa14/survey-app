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

  /// The title of the registration page.
  static const String registrationTitle = "Creați un cont nou";

  /// Snackbar message shown after successful registration.
  static const String registrationSuccessMessage =
      "Înregistrarea a fost finalizată cu succes.";

  /// Button text to return from registration to authentication page.
  static const String registrationBackButton = "Înapoi la autentificare";

  /// Button text for registration action.
  static const String registrationButton = "Înregistrare";

  /// Button text shown while registration request is in progress.
  static const String registrationLoadingButton = "Încărcare...";

  /// Generic fallback shown for authentication errors.
  static const String authFallbackError = "Autentificarea a eșuat.";

  /// Validation message when email or password are missing.
  static const String authEmailPasswordRequired =
      "Email și parolă sunt obligatorii.";

  /// Message shown when provided login credentials are invalid.
  static const String authInvalidCredentials = "Email sau parolă invalidă.";

  /// Message shown when the user is logged out manually.
  static const String authLoggedOut = "Te-ai deconectat.";

  /// Message shown when JWT/session has expired.
  static const String authSessionExpired =
      "Sesiunea a expirat. Te rugăm să te autentifici din nou.";

  /// Formats login-step failures with backend or runtime details.
  static String authLoginStepFailed(String details) =>
      "Pasul de autentificare a eșuat: $details";

  /// Formats registration failures with backend or runtime details.
  static String authRegistrationFailed(String details) =>
      "Înregistrarea a eșuat: $details";

  // Admin surveys list page:
  /// The title of the admin surveys list page.
  static const String adminSurveysTitle = "Sondaje";

  /// The title of the contacts list page.
  static const String contactsListTitle = "Liste contacte";

  /// The text for the "Create Survey" button.
  static const String createSurveyButton = "+    Sondaj nou";

  /// The text for the create email list button.
  static const String createEmailListButton = "+    Listă nouă";

  /// The text for the logout button in admin area.
  static const String logoutButton = "Logout";

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
      "slug: $slug · $questionCount întrebări · creat ${formatShortRoDate(createdAt)}";

  /// Formats a date in short Romanian format (e.g. "15 ian").
  static String formatShortRoDate(DateTime date) {
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

  /// The text for the "Manage Invitations" button.
  static const String manageInvitationsButton = "Vizualizează invitații";

  /// Title line for the survey invitations page.
  static String surveyInvitationsTitle(String surveyTitle) =>
      "Invitații - $surveyTitle";

  /// Metadata line with survey slug for invitations page.
  static String surveyInvitationsSlug(String slug) => " ·  slug: $slug";

  /// Section title for invitation sending card.
  static const String sendInvitationsTitle = "Trimite invitații";

  /// Label for contact list selector.
  static const String selectContactListLabel = "Selectează lista de contacte";

  /// Placeholder for contact list dropdown.
  static const String chooseContactListPlaceholder = "- alege o listă -";

  /// Label for contacts count in contact list dropdown.
  static const String contactsLabel = 'contacte';

  /// Action label for preview send button.
  static const String previewSendingButton = "Preview trimitere";

  /// Warning emoji used in invitation preview banner.
  static const String previewWarningEmoji = "⚠️";

  /// Preview summary line for invitation sending.
  static String invitationsPreviewText(int newEmails, int alreadyInvited) =>
      "Preview: $newEmails emailuri noi vor fi trimise · $alreadyInvited contacte au primit deja invitația (skip)";

  /// Helper text shown before a preview has been loaded.
  static const String previewInvitationsHint =
      "Apasă Preview trimitere pentru a vedea estimarea";

  /// Action label for final invitation send button.
  static String sendInvitationsButton(int count) => "Trimite $count invitații";

  /// Title for sent invitations section with total count.
  static String sentInvitationsTitle(int count) => "INVITAȚII TRIMISE ($count)";

  /// Placeholder for searching invitations by email.
  static const String searchByEmailPlaceholder = "Caută după email...";

  /// Empty state message for the sent invitations table.
  static const String sentInvitationsEmptyState =
      'Nu există invitații trimise pentru această listă.';

  /// Status label for a bounced invitation.
  static const String invitationStatusBounced = 'Bounced';

  /// Status label for a submitted invitation.
  static const String invitationStatusSubmitted = 'Submitted';

  /// Status label for an invitation where the email was opened.
  static const String invitationStatusEmailOpened = 'Email opened';

  /// Status label for a sent invitation that has not been opened.
  static const String invitationStatusSent = 'Sent';

  /// Header title for invitation table email column.
  static const String invitationsHeaderEmail = "Email";

  /// Header title for invitation table email open column.
  static const String invitationsHeaderEmailOpen = "Email open";

  /// Header title for invitation table survey open column.
  static const String invitationsHeaderSurveyOpen = "Survey open";

  /// Header title for invitation table status column.
  static const String invitationsHeaderStatus = "Status";

  /// Header title for invitation table date column.
  static const String invitationsHeaderDate = "Data";

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

  /// The title shown when a survey link is invalid.
  static const String invalidSurveyTitle = '🔗\nLink invalid';

  /// Message shown when a survey invitation link is invalid or expired.
  static const String invalidSurveyMessage =
      'Linkul de invitație nu este valid sau a expirat.';

  // Results page:
  /// Formats results page title with survey title.
  static String resultsPageTitle(String surveyTitle) =>
      'Rezultate - $surveyTitle';

  /// Subtitle shown on results page.
  static const String resultsPageSubtitle = 'Date actualizate în timp real';

  /// Action label for exporting survey results as CSV.
  static const String resultsExportCsvButton = '📥 Export CSV';

  /// Status text while exporting CSV.
  static const String resultsExporting = 'Exporting...';

  /// Funnel section title on results page.
  static const String resultsFunnelTitle = 'FUNNEL INVITAȚI → SUBMIT';

  /// Formats bounce and completion-rate info in results summary.
  static String resultsBounceAndCompletion(
    int bounced,
    double completionRate,
  ) =>
      'Bounce: $bounced · Completion rate (survey open → submit): ${completionRate.toStringAsFixed(1)}%';

  /// Label for Questions results tab.
  static const String resultsQuestionsTab = 'Intrebari';

  /// Label for Comments results tab.
  static const String resultsCommentsTab = 'Comentarii';

  /// Placeholder content for comments tab.
  static const String resultsCommentsMockContent = 'Conținut Comentarii (mock)';

  /// Hint text for comments search input.
  static const String resultsCommentsSearchHint = 'Caută în comentarii...';

  /// Placeholder text for comments question dropdown.
  static const String resultsCommentsQuestionDropdownPlaceholder =
      'Alege întrebare text liber';

  /// Formats comments section summary line with pagination.
  static String resultsCommentsSummary(
    int responses,
    int currentPage,
    int totalPages,
  ) => '$responses RĂSPUNSURI · pagina $currentPage din $totalPages';

  /// Formats comments card metadata line with email and date.
  static String resultsCommentMeta(String email, String dateLabel) =>
      '$email · $dateLabel';

  /// Previous-page button label in comments pagination.
  static const String resultsCommentsPrevButton = 'Prev';

  /// Next-page button label in comments pagination.
  static const String resultsCommentsNextButton = 'Next';

  /// Empty state for comments when there are no text questions.
  static const String resultsCommentsNoTextQuestions =
      'Nu există întrebări de tip text liber.';

  /// Empty state for comments when no results match filters.
  static const String resultsCommentsNoMatches =
      'Nu există răspunsuri care să corespundă filtrului.';

  /// Empty-state text for results questions section.
  static const String resultsNoQuestions =
      'Nu există întrebări pentru acest sondaj.';

  /// Horizontal stats label for invited count.
  static const String resultsInvitedLabel = 'Invitati';

  /// Horizontal stats label for sent count.
  static const String resultsSentLabel = 'Trimisi';

  /// Horizontal stats label for opened-email count.
  static const String resultsEmailOpenLabel = 'Email Open';

  /// Horizontal stats label for opened-survey count.
  static const String resultsSurveyOpenLabel = 'Survey Open';

  /// Horizontal stats label for submitted responses.
  static const String resultsSubmittedLabel = 'Submituri';

  /// Formats a percentage value for results UI.
  static String resultsPercent(double value) => '${value.toStringAsFixed(1)}%';

  /// Formats multiple-choice question metadata line.
  static String resultsMultiChoiceMeta(
    int maxSelections,
    int respondents,
    int invited,
  ) =>
      'multi-choice · max $maxSelections · $respondents răspunsuri din $invited';

  /// Warning message shown for multi-choice percentage interpretation.
  static String resultsMultiChoicePercentageWarning(int respondents) =>
      '⚠ La multi-choice suma procentelor poate depăși 100%. Procentele sunt calculate din numărul de respondenți la această întrebare ($respondents).';

  /// Formats option count text for results rows.
  static String resultsOptionCount(int count) => '($count)';

  /// Formats free-text question metadata line.
  static String resultsTextMeta(int respondents, int invited) =>
      'text liber · $respondents răspunsuri din $invited';

  /// Action label for viewing all text answers.
  static const String resultsViewAllTextAnswersButton = 'Vezi toate →';

  /// Placeholder text for text-question answers preview.
  static const String resultsTextAnswersPreviewMock =
      'Preview pentru întrebările text va fi afișat aici.';

  /// The label for edit button in question preview.
  static const String questionPreviewEditButton = "Edit";

  /// Formats the max selections text in question preview.
  static String questionPreviewMaxSelections(int value) =>
      "max $value selecții";

  /// Formats the max characters text in question preview.
  static String questionPreviewMaxCharacters(int value) =>
      "max $value caractere";

  /// Formats the public question title line with order and title.
  static String publicQuestionTitle(int order, String title) =>
      '$order. $title';

  /// Helper text for single-selection multiple choice questions.
  static String publicSelectSingleOption(int count) =>
      'Selecteaza $count optiune';

  /// Helper text for multi-selection multiple choice questions.
  static String publicSelectMaxOptions(int maxSelections) =>
      'Selecteaza maxim $maxSelections optiuni';

  /// Counter text showing used selections for a multiple choice question.
  static String publicSelectionsUsed(int selected, int maxSelections) =>
      '$selected/$maxSelections selectii utilizate';

  /// Placeholder for public free-text question input.
  static const String publicTextQuestionHint = 'Scrie raspunsul tau...';

  /// Counter text showing used characters for a text question.
  static String publicTextQuestionCharacters(int written, int maxCharacters) =>
      '$written/$maxCharacters';

  /// Message shown when a public survey cannot be found.
  static const String publicSurveyNotFound = 'Survey not found.';

  /// Placeholder text for unsupported public question types.
  static const String publicUnsupportedQuestionMock = 'Intrebare text (mock)';

  /// Submit button label on public survey page.
  static const String publicSubmitAnswersButton = 'Trimite raspunsurile →';

  /// The title shown when a survey is closed.
  static const String closedSurveyTitle = '🔒\nSondaj închis';

  /// Message shown when a survey no longer accepts responses.
  static const String closedSurveyMessage =
      'Acest sondaj nu mai acceptă răspunsuri.';

  /// The title shown when a user has already answered the survey.
  static const String alreadyAnsweredSurveyTitle = '☑\nDeja completat';

  /// Message shown when the survey has already been answered.
  static const String alreadyAnsweredSurveyMessage =
      'Ai trimis deja răspunsul pentru acest sondaj.';

  /// The title shown after a survey response is submitted successfully.
  static const String registeredAnswerTitle =
      '✅\nRăspunsurile tale au fost înregistrate';

  /// Message shown after a survey response is submitted successfully.
  static const String registeredAnswerMessage =
      'Mulțumim pentru participare! Poți închide această fereastră.';

  /// Required warning text for unanswered multiple-choice questions.
  static String publicRequiredSelectWarning(int order) =>
      'Întrebarea $order este obligatorie — selectează cel puțin o opțiune.';

  /// Required warning text for unanswered text questions.
  static String publicRequiredTextWarning(int order) =>
      'Întrebarea $order este obligatorie — scrie cel puțin un caracter.';

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
    return "$contactsCount contacte · creată ${formatShortRoDate(createdAt)}";
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

  /// CSV dropzone helper text while dragging a file over the dropzone.
  static const String csvImportDropzoneActiveText =
      'Eliberează fișierul pentru a porni preview-ul';

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

  /// Message shown when a non-CSV file is dropped in the dropzone.
  static const String csvImportOnlyCsvMessage =
      'Poți încărca doar fișiere .csv.';

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
