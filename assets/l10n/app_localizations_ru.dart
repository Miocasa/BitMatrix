// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'E-Learn';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabMyCourses => 'Мои курсы';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get loginTitle => 'С возвращением!';

  @override
  String get loginSubtitle => 'Пожалуйста, войдите, чтобы продолжить';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'you@example.com';

  @override
  String get loginEmailError => 'Пожалуйста, введите корректный email';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginPasswordHint => 'Введите пароль';

  @override
  String get loginPasswordError => 'Пожалуйста, введите пароль';

  @override
  String get loginForgotPassword => 'Забыли пароль?';

  @override
  String get loginForgotPasswordClicked =>
      'Кнопка восстановления пароля нажата!';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginNoAccount => 'Нет аккаунта?';

  @override
  String get loginSignUpLink => 'Зарегистрироваться';

  @override
  String get loginFailed => 'Не удалось войти. Проверьте логин и пароль.';

  @override
  String get signUpTitle => 'Создать аккаунт';

  @override
  String get signUpSubtitle => 'Присоединяйтесь, заполнив форму ниже';

  @override
  String get signUpNicknameLabel => 'Никнейм';

  @override
  String get signUpNicknameHint => 'Ваш никнейм';

  @override
  String get signUpNicknameErrorEmpty => 'Пожалуйста, введите корректное имя';

  @override
  String get signUpEmailLabel => 'Email';

  @override
  String get signUpEmailHint => 'you@example.com';

  @override
  String get signUpEmailError => 'Пожалуйста, введите корректный email';

  @override
  String get signUpPasswordLabel => 'Пароль';

  @override
  String get signUpPasswordHint => 'Создайте надёжный пароль';

  @override
  String get signUpPasswordErrorEmpty => 'Пожалуйста, введите пароль';

  @override
  String get signUpPasswordErrorShort =>
      'Пароль должен быть не менее 6 символов';

  @override
  String get signUpConfirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get signUpConfirmPasswordHint => 'Повторно введите пароль';

  @override
  String get signUpConfirmPasswordErrorEmpty =>
      'Пожалуйста, подтвердите пароль';

  @override
  String get signUpConfirmPasswordErrorNotMatch => 'Пароли не совпадают';

  @override
  String get signUpButton => 'Зарегистрироваться';

  @override
  String get signUpAlreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signUpLoginLink => 'Войти';

  @override
  String get signUpFailed =>
      'Не удалось создать аккаунт. Попробуйте ещё раз или используйте другой email.';

  @override
  String get signUpSuccess => 'Аккаунт успешно создан! Пожалуйста, войдите.';

  @override
  String get homeSearchHint => 'Поиск курсов...';

  @override
  String get homeSearchCloseTooltip => 'Закрыть поиск';

  @override
  String get homeSearchClearTooltip => 'Очистить поиск';

  @override
  String get homeSearchTooltip => 'Поиск курсов';

  @override
  String get homeSettingsTooltip => 'Настройки';

  @override
  String get homeNoCourses =>
      'Нет доступных курсов. Попробуйте добавить тестовые данные.';

  @override
  String homeNoCoursesForQuery(String query) {
    return 'По запросу \"$query\" курсов не найдено.';
  }

  @override
  String get homeTryDifferentTerm => 'Попробуйте изменить поисковый запрос.';

  @override
  String get homeSampleDataLabel => 'Тестовые данные';

  @override
  String get homeLearningProgressTitle => 'Прогресс обучения';

  @override
  String homeInnerProgressLabel(int days) {
    return '$days дн. стрика';
  }

  @override
  String homeOuterProgressLabel(int points) {
    return 'Очки: $points';
  }

  @override
  String get homeTodayPoints => 'Очки за сегодня';

  @override
  String get homeStreakDays => 'Дни стрика';

  @override
  String get homeStatusDone => 'Поздравляем, ты выполнил план учёбы!🎉';

  @override
  String get homeStatusAlmost => 'Вы почти достигли цели 👍';

  @override
  String get homeStatusFewLessons => 'Ещё пару уроков 👾';

  @override
  String get homeStatusGoodStart => 'Хорошее начало 🤠';

  @override
  String get homeStatusStart => 'Пора начать 😸';

  @override
  String get myCoursesLoginToSee =>
      'Пожалуйста, войдите, чтобы увидеть ваши курсы.';

  @override
  String myCoursesErrorWithReason(String reason) {
    return 'Ошибка: $reason';
  }

  @override
  String get myCoursesEmptyTitle => 'Вы ещё не записаны ни на один курс.';

  @override
  String get myCoursesEmptySubtitle =>
      'Изучите доступные курсы и начните обучение!';

  @override
  String get courseEnrollmentLoginRequired =>
      'Пожалуйста, войдите, чтобы записаться и просматривать уроки.';

  @override
  String get courseLessonsTitle => 'Уроки';

  @override
  String get courseNoLessons => 'Для этого курса ещё нет уроков.';

  @override
  String get courseLoginToAccessLessons =>
      'Войдите, чтобы записаться и получить доступ к урокам.';

  @override
  String get courseEnrollToViewLessons =>
      'Запишитесь на курс, чтобы просматривать уроки.';

  @override
  String get coursePleaseEnrollToWatchLesson =>
      'Пожалуйста, запишитесь на курс, чтобы посмотреть этот урок.';

  @override
  String get coursePleaseEnrollToViewContent =>
      'Пожалуйста, запишитесь на курс, чтобы просматривать содержание урока.';

  @override
  String get courseLoading => 'Загрузка...';

  @override
  String get courseNotFound =>
      'Курс не найден или произошла ошибка при загрузке.';

  @override
  String courseInstructor(String name) {
    return 'Инструктор: $name';
  }

  @override
  String get courseConfirmUnenrollTitle => 'Подтвердите отписку';

  @override
  String courseConfirmUnenrollBody(String title) {
    return 'Вы уверены, что хотите отписаться от курса \"$title\"? Ваш прогресс будет потерян.';
  }

  @override
  String get courseDialogCancel => 'Отмена';

  @override
  String get courseDialogUnenroll => 'Отписаться';

  @override
  String get courseUnenrollSuccess => 'Вы успешно отписались!';

  @override
  String get courseEnrollSuccess => 'Вы успешно записались!';

  @override
  String courseEnrollErrorWithReason(String reason) {
    return 'Ошибка: $reason';
  }

  @override
  String get courseButtonUnenroll => 'Отписаться от курса';

  @override
  String get courseButtonEnroll => 'Записаться на курс';

  @override
  String get courseCardCompleted => 'Завершён';

  @override
  String get courseCardViewCourse => 'К курсу';

  @override
  String get courseCardTapForDetails => 'Нажмите, чтобы посмотреть детали';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsConfirmLogoutTitle => 'Подтвердите выход';

  @override
  String get settingsConfirmLogoutBody => 'Вы уверены, что хотите выйти?';

  @override
  String get settingsCancel => 'Отмена';

  @override
  String get settingsLogout => 'Выйти';

  @override
  String get settingsAppearanceSection => 'Оформление';

  @override
  String get settingsLightMode => 'Светлая тема';

  @override
  String get settingsDarkMode => 'Тёмная тема';

  @override
  String get settingsSystemMode => 'Системная тема';

  @override
  String get settingsPrimaryColorSection => 'Основной цвет';

  @override
  String get settingsPrimaryColorHint =>
      'Выберите предпочитаемый цвет приложения:';

  @override
  String get settingsAccountSection => 'Аккаунт';

  @override
  String get settingsAboutSection => 'О приложении';

  @override
  String get settingsAboutAppTitle => 'О приложении';

  @override
  String get settingsAboutAppSubtitle => 'Версия 1.0.0';

  @override
  String get settingsAboutAppName => 'Course App';

  @override
  String get settingsAboutAppVersion => '1.0.0';

  @override
  String settingsAboutAppLegalese(int year) {
    return '© $year Ваша компания';
  }

  @override
  String get settingsAboutAppDescription =>
      'Это отличное приложение для курсов, созданное на Flutter и Firebase.';

  @override
  String settingsLogoutFailedWithReason(String reason) {
    return 'Не удалось выйти: $reason';
  }

  @override
  String get profileLoginToSee => 'Пожалуйста, войдите, чтобы увидеть профиль.';

  @override
  String profileLoadErrorWithReason(String reason) {
    return 'Ошибка загрузки профиля: $reason';
  }

  @override
  String get profileNotFound => 'Профиль не найден.';

  @override
  String get profileNameNotSet => 'Имя не задано';

  @override
  String profileStreakChip(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# дней стрика',
      many: '# дней стрика',
      few: '# дня стрика',
      one: '# день стрика',
    );
    return '$_temp0';
  }

  @override
  String get profileEditSoon => 'Редактирование профиля скоро будет доступно';

  @override
  String get markdownLoadError => 'Не удалось загрузить документ';

  @override
  String get markdownTocUnavailable => 'Оглавление недоступно';

  @override
  String videoErrorLoading(String reason) {
    return 'Ошибка загрузки видео: $reason';
  }

  @override
  String get videoUrlNotSupported =>
      'Видео URL не задан или не поддерживается.';

  @override
  String get videoLoadFailed => 'Не удалось загрузить видео.';

  @override
  String get authErrorGeneric =>
      'Ошибка авторизации. Пожалуйста, перезапустите приложение.';
}
