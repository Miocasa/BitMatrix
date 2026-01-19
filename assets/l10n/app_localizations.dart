import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Teck Oqu'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get tabMyCourses;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginEmailError;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginPasswordError;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginForgotPasswordClicked.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password clicked!'**
  String get loginForgotPasswordClicked;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUpLink;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Check your credentials.'**
  String get loginFailed;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us by filling out the form below'**
  String get signUpSubtitle;

  /// No description provided for @signUpNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get signUpNicknameLabel;

  /// No description provided for @signUpNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Your nickname'**
  String get signUpNicknameHint;

  /// No description provided for @signUpNicknameErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get signUpNicknameErrorEmpty;

  /// No description provided for @signUpEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signUpEmailLabel;

  /// No description provided for @signUpEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get signUpEmailHint;

  /// No description provided for @signUpEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get signUpEmailError;

  /// No description provided for @signUpPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPasswordLabel;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get signUpPasswordHint;

  /// No description provided for @signUpPasswordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get signUpPasswordErrorEmpty;

  /// No description provided for @signUpPasswordErrorShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get signUpPasswordErrorShort;

  /// No description provided for @signUpConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPasswordLabel;

  /// No description provided for @signUpConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get signUpConfirmPasswordHint;

  /// No description provided for @signUpConfirmPasswordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get signUpConfirmPasswordErrorEmpty;

  /// No description provided for @signUpConfirmPasswordErrorNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signUpConfirmPasswordErrorNotMatch;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @signUpAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signUpAlreadyHaveAccount;

  /// No description provided for @signUpLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signUpLoginLink;

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed. Please try again or use a different email.'**
  String get signUpFailed;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Please log in.'**
  String get signUpSuccess;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search courses...'**
  String get homeSearchHint;

  /// No description provided for @homeSearchCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close Search'**
  String get homeSearchCloseTooltip;

  /// No description provided for @homeSearchClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get homeSearchClearTooltip;

  /// No description provided for @homeSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search Courses'**
  String get homeSearchTooltip;

  /// No description provided for @homeSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsTooltip;

  /// No description provided for @homeNoCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses available. Try adding sample data.'**
  String get homeNoCourses;

  /// No description provided for @homeNoCoursesForQuery.
  ///
  /// In en, this message translates to:
  /// **'No courses found for \"{query}\".'**
  String homeNoCoursesForQuery(String query);

  /// No description provided for @homeTryDifferentTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get homeTryDifferentTerm;

  /// No description provided for @homeSampleDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample Data'**
  String get homeSampleDataLabel;

  /// No description provided for @homeLearningProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning progress'**
  String get homeLearningProgressTitle;

  /// No description provided for @homeInnerProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{days} days streak'**
  String homeInnerProgressLabel(int days);

  /// No description provided for @homeOuterProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Points: {points}'**
  String homeOuterProgressLabel(int points);

  /// No description provided for @homeTodayPoints.
  ///
  /// In en, this message translates to:
  /// **'Points for today'**
  String get homeTodayPoints;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'Streak days'**
  String get homeStreakDays;

  /// No description provided for @homeStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Congrats, you have completed your study plan!🎉'**
  String get homeStatusDone;

  /// No description provided for @homeStatusAlmost.
  ///
  /// In en, this message translates to:
  /// **'You are almost at your goal 👍'**
  String get homeStatusAlmost;

  /// No description provided for @homeStatusFewLessons.
  ///
  /// In en, this message translates to:
  /// **'Just a few more lessons 👾'**
  String get homeStatusFewLessons;

  /// No description provided for @homeStatusGoodStart.
  ///
  /// In en, this message translates to:
  /// **'Good start 🤠'**
  String get homeStatusGoodStart;

  /// No description provided for @homeStatusStart.
  ///
  /// In en, this message translates to:
  /// **'Time to start 😸'**
  String get homeStatusStart;

  /// No description provided for @myCoursesLoginToSee.
  ///
  /// In en, this message translates to:
  /// **'Please log in to see your courses.'**
  String get myCoursesLoginToSee;

  /// No description provided for @myCoursesErrorWithReason.
  ///
  /// In en, this message translates to:
  /// **'Error: {reason}'**
  String myCoursesErrorWithReason(String reason);

  /// No description provided for @myCoursesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You are not enrolled in any courses yet.'**
  String get myCoursesEmptyTitle;

  /// No description provided for @myCoursesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore available courses and start learning!'**
  String get myCoursesEmptySubtitle;

  /// No description provided for @courseEnrollmentLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to enroll and view lessons.'**
  String get courseEnrollmentLoginRequired;

  /// No description provided for @courseLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get courseLessonsTitle;

  /// No description provided for @courseNoLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons available for this course yet.'**
  String get courseNoLessons;

  /// No description provided for @courseLoginToAccessLessons.
  ///
  /// In en, this message translates to:
  /// **'Log in to enroll and access lessons.'**
  String get courseLoginToAccessLessons;

  /// No description provided for @courseEnrollToViewLessons.
  ///
  /// In en, this message translates to:
  /// **'Enroll in the course to view lessons.'**
  String get courseEnrollToViewLessons;

  /// No description provided for @coursePleaseEnrollToWatchLesson.
  ///
  /// In en, this message translates to:
  /// **'Please enroll to watch this lesson.'**
  String get coursePleaseEnrollToWatchLesson;

  /// No description provided for @coursePleaseEnrollToViewContent.
  ///
  /// In en, this message translates to:
  /// **'Please enroll to view lesson content.'**
  String get coursePleaseEnrollToViewContent;

  /// No description provided for @courseLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get courseLoading;

  /// No description provided for @courseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Course not found or error loading.'**
  String get courseNotFound;

  /// No description provided for @courseInstructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor: {name}'**
  String courseInstructor(String name);

  /// No description provided for @courseConfirmUnenrollTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Unenrollment'**
  String get courseConfirmUnenrollTitle;

  /// No description provided for @courseConfirmUnenrollBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unenroll from \"{title}\"? Your progress will be lost.'**
  String courseConfirmUnenrollBody(String title);

  /// No description provided for @courseDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get courseDialogCancel;

  /// No description provided for @courseDialogUnenroll.
  ///
  /// In en, this message translates to:
  /// **'Unenroll'**
  String get courseDialogUnenroll;

  /// No description provided for @courseUnenrollSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully unenrolled!'**
  String get courseUnenrollSuccess;

  /// No description provided for @courseEnrollSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully enrolled!'**
  String get courseEnrollSuccess;

  /// No description provided for @courseEnrollErrorWithReason.
  ///
  /// In en, this message translates to:
  /// **'Error: {reason}'**
  String courseEnrollErrorWithReason(String reason);

  /// No description provided for @courseButtonUnenroll.
  ///
  /// In en, this message translates to:
  /// **'Unenroll from Course'**
  String get courseButtonUnenroll;

  /// No description provided for @courseButtonEnroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll in Course'**
  String get courseButtonEnroll;

  /// No description provided for @courseCardCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get courseCardCompleted;

  /// No description provided for @courseCardViewCourse.
  ///
  /// In en, this message translates to:
  /// **'View Course'**
  String get courseCardViewCourse;

  /// No description provided for @courseCardTapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get courseCardTapForDetails;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsConfirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get settingsConfirmLogoutTitle;

  /// No description provided for @settingsConfirmLogoutBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get settingsConfirmLogoutBody;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogout;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsLightMode;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsSystemMode.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsSystemMode;

  /// No description provided for @settingsPrimaryColorSection.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get settingsPrimaryColorSection;

  /// No description provided for @settingsPrimaryColorHint.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred app color:'**
  String get settingsPrimaryColorHint;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSection;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsAboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get settingsAboutAppTitle;

  /// No description provided for @settingsAboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get settingsAboutAppSubtitle;

  /// No description provided for @settingsAboutAppName.
  ///
  /// In en, this message translates to:
  /// **'Course App'**
  String get settingsAboutAppName;

  /// No description provided for @settingsAboutAppVersion.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get settingsAboutAppVersion;

  /// No description provided for @settingsAboutAppLegalese.
  ///
  /// In en, this message translates to:
  /// **'© {year} Your Company Name'**
  String settingsAboutAppLegalese(int year);

  /// No description provided for @settingsAboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a great course application built with Flutter and Firebase.'**
  String get settingsAboutAppDescription;

  /// No description provided for @settingsLogoutFailedWithReason.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {reason}'**
  String settingsLogoutFailedWithReason(String reason);

  /// No description provided for @profileLoginToSee.
  ///
  /// In en, this message translates to:
  /// **'Please log in to see your profile.'**
  String get profileLoginToSee;

  /// No description provided for @profileLoadErrorWithReason.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {reason}'**
  String profileLoadErrorWithReason(String reason);

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found.'**
  String get profileNotFound;

  /// No description provided for @profileNameNotSet.
  ///
  /// In en, this message translates to:
  /// **'Name not set'**
  String get profileNameNotSet;

  /// No description provided for @profileStreakChip.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one {# day streak} other {# days streak}}'**
  String profileStreakChip(int days);

  /// No description provided for @profileEditSoon.
  ///
  /// In en, this message translates to:
  /// **'Profile editing will be available soon'**
  String get profileEditSoon;

  /// No description provided for @markdownLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load document'**
  String get markdownLoadError;

  /// No description provided for @markdownTocUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Table of contents is not available'**
  String get markdownTocUnavailable;

  /// No description provided for @videoErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading video: {reason}'**
  String videoErrorLoading(String reason);

  /// No description provided for @videoUrlNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Video URL is not set or not supported.'**
  String get videoUrlNotSupported;

  /// No description provided for @videoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video.'**
  String get videoLoadFailed;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please restart.'**
  String get authErrorGeneric;
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
