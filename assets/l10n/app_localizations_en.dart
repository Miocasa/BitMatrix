// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Teck Oqu';

  @override
  String get tabHome => 'Home';

  @override
  String get tabMyCourses => 'My Courses';

  @override
  String get tabProfile => 'Profile';

  @override
  String get loginTitle => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Please sign in to continue';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'you@example.com';

  @override
  String get loginEmailError => 'Please enter a valid email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginPasswordError => 'Please enter your password';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginForgotPasswordClicked => 'Forgot Password clicked!';

  @override
  String get loginButton => 'Login';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginSignUpLink => 'Sign Up';

  @override
  String get loginFailed => 'Login failed. Check your credentials.';

  @override
  String get signUpTitle => 'Create Account';

  @override
  String get signUpSubtitle => 'Join us by filling out the form below';

  @override
  String get signUpNicknameLabel => 'Nickname';

  @override
  String get signUpNicknameHint => 'Your nickname';

  @override
  String get signUpNicknameErrorEmpty => 'Please enter a valid name';

  @override
  String get signUpEmailLabel => 'Email';

  @override
  String get signUpEmailHint => 'you@example.com';

  @override
  String get signUpEmailError => 'Please enter a valid email';

  @override
  String get signUpPasswordLabel => 'Password';

  @override
  String get signUpPasswordHint => 'Create a strong password';

  @override
  String get signUpPasswordErrorEmpty => 'Please enter a password';

  @override
  String get signUpPasswordErrorShort =>
      'Password must be at least 6 characters';

  @override
  String get signUpConfirmPasswordLabel => 'Confirm Password';

  @override
  String get signUpConfirmPasswordHint => 'Re-enter your password';

  @override
  String get signUpConfirmPasswordErrorEmpty => 'Please confirm your password';

  @override
  String get signUpConfirmPasswordErrorNotMatch => 'Passwords do not match';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get signUpAlreadyHaveAccount => 'Already have an account?';

  @override
  String get signUpLoginLink => 'Login';

  @override
  String get signUpFailed =>
      'Sign up failed. Please try again or use a different email.';

  @override
  String get signUpSuccess => 'Account created successfully! Please log in.';

  @override
  String get homeSearchHint => 'Search courses...';

  @override
  String get homeSearchCloseTooltip => 'Close Search';

  @override
  String get homeSearchClearTooltip => 'Clear Search';

  @override
  String get homeSearchTooltip => 'Search Courses';

  @override
  String get homeSettingsTooltip => 'Settings';

  @override
  String get homeNoCourses => 'No courses available. Try adding sample data.';

  @override
  String homeNoCoursesForQuery(String query) {
    return 'No courses found for \"$query\".';
  }

  @override
  String get homeTryDifferentTerm => 'Try a different search term.';

  @override
  String get homeSampleDataLabel => 'Sample Data';

  @override
  String get homeLearningProgressTitle => 'Learning progress';

  @override
  String homeInnerProgressLabel(int days) {
    return '$days days streak';
  }

  @override
  String homeOuterProgressLabel(int points) {
    return 'Points: $points';
  }

  @override
  String get homeTodayPoints => 'Points for today';

  @override
  String get homeStreakDays => 'Streak days';

  @override
  String get homeStatusDone =>
      'Congrats, you have completed your study plan!🎉';

  @override
  String get homeStatusAlmost => 'You are almost at your goal 👍';

  @override
  String get homeStatusFewLessons => 'Just a few more lessons 👾';

  @override
  String get homeStatusGoodStart => 'Good start 🤠';

  @override
  String get homeStatusStart => 'Time to start 😸';

  @override
  String get myCoursesLoginToSee => 'Please log in to see your courses.';

  @override
  String myCoursesErrorWithReason(String reason) {
    return 'Error: $reason';
  }

  @override
  String get myCoursesEmptyTitle => 'You are not enrolled in any courses yet.';

  @override
  String get myCoursesEmptySubtitle =>
      'Explore available courses and start learning!';

  @override
  String get courseEnrollmentLoginRequired =>
      'Please log in to enroll and view lessons.';

  @override
  String get courseLessonsTitle => 'Lessons';

  @override
  String get courseNoLessons => 'No lessons available for this course yet.';

  @override
  String get courseLoginToAccessLessons =>
      'Log in to enroll and access lessons.';

  @override
  String get courseEnrollToViewLessons =>
      'Enroll in the course to view lessons.';

  @override
  String get coursePleaseEnrollToWatchLesson =>
      'Please enroll to watch this lesson.';

  @override
  String get coursePleaseEnrollToViewContent =>
      'Please enroll to view lesson content.';

  @override
  String get courseLoading => 'Loading...';

  @override
  String get courseNotFound => 'Course not found or error loading.';

  @override
  String courseInstructor(String name) {
    return 'Instructor: $name';
  }

  @override
  String get courseConfirmUnenrollTitle => 'Confirm Unenrollment';

  @override
  String courseConfirmUnenrollBody(String title) {
    return 'Are you sure you want to unenroll from \"$title\"? Your progress will be lost.';
  }

  @override
  String get courseDialogCancel => 'Cancel';

  @override
  String get courseDialogUnenroll => 'Unenroll';

  @override
  String get courseUnenrollSuccess => 'Successfully unenrolled!';

  @override
  String get courseEnrollSuccess => 'Successfully enrolled!';

  @override
  String courseEnrollErrorWithReason(String reason) {
    return 'Error: $reason';
  }

  @override
  String get courseButtonUnenroll => 'Unenroll from Course';

  @override
  String get courseButtonEnroll => 'Enroll in Course';

  @override
  String get courseCardCompleted => 'Completed';

  @override
  String get courseCardViewCourse => 'View Course';

  @override
  String get courseCardTapForDetails => 'Tap to view details';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsConfirmLogoutTitle => 'Confirm Logout';

  @override
  String get settingsConfirmLogoutBody => 'Are you sure you want to log out?';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsLightMode => 'Light Mode';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsSystemMode => 'System Default';

  @override
  String get settingsPrimaryColorSection => 'Primary Color';

  @override
  String get settingsPrimaryColorHint => 'Select your preferred app color:';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsAboutAppTitle => 'About App';

  @override
  String get settingsAboutAppSubtitle => 'Version 1.0.0';

  @override
  String get settingsAboutAppName => 'Course App';

  @override
  String get settingsAboutAppVersion => '1.0.0';

  @override
  String settingsAboutAppLegalese(int year) {
    return '© $year Your Company Name';
  }

  @override
  String get settingsAboutAppDescription =>
      'This is a great course application built with Flutter and Firebase.';

  @override
  String settingsLogoutFailedWithReason(String reason) {
    return 'Logout failed: $reason';
  }

  @override
  String get profileLoginToSee => 'Please log in to see your profile.';

  @override
  String profileLoadErrorWithReason(String reason) {
    return 'Error loading profile: $reason';
  }

  @override
  String get profileNotFound => 'Profile not found.';

  @override
  String get profileNameNotSet => 'Name not set';

  @override
  String profileStreakChip(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# days streak',
      one: '# day streak',
    );
    return '$_temp0';
  }

  @override
  String get profileEditSoon => 'Profile editing will be available soon';

  @override
  String get markdownLoadError => 'Failed to load document';

  @override
  String get markdownTocUnavailable => 'Table of contents is not available';

  @override
  String videoErrorLoading(String reason) {
    return 'Error loading video: $reason';
  }

  @override
  String get videoUrlNotSupported => 'Video URL is not set or not supported.';

  @override
  String get videoLoadFailed => 'Failed to load video.';

  @override
  String get authErrorGeneric => 'Authentication error. Please restart.';
}
