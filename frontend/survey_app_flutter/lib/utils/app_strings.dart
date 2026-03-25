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

  /// The label for the "Required" checkbox.
  static const String requiredLabel = "Required";

  /// The text for the "Add Option" button in the multi-choice question builder.
  static const String addOptionButton = "Adaugă opțiune";

  /// The text for the "Cancel" button in the question builder.
  static const String cancelButton = "Anulează";

  /// The text for the "Save" button in the question builder.
  static const String saveButton = "Salvează";

  /// The label for the maximum numbers of options field in the multi-choice
  /// question builder.
  static const String maxOptionsLabel = "Selecții maxime";

  /// The label for the number of options field in the multi-choice question
  /// builder.
  static String numberOfOptionsLabel(int minOptions) =>
      "Opțiuni (minim $minOptions)";
}
