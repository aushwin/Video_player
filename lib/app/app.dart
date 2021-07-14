import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_playerio/app/auth_service/auth_service.dart';
import 'package:video_playerio/app/services/error.service.dart';
import 'package:video_playerio/app/services/profile.service.dart';
import 'package:video_playerio/app/services/theme.service.dart';
import 'package:video_playerio/ui/login/login_view.dart';
import 'package:video_playerio/ui/main/main_view.dart';
import 'package:video_playerio/ui/onboarding/onboarding_view.dart';
import 'package:video_playerio/ui/profile/profile_view.dart';
import 'package:video_playerio/ui/registration/registration_view.dart';

@StackedApp(routes: [
  MaterialRoute(page: OnBoardingView, initial: true),
  MaterialRoute(page: LoginView),
  MaterialRoute(page: RegistrationView),
  MaterialRoute(page: MainView),
  MaterialRoute(page: ProfileView)
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: AuthService),
  LazySingleton(classType: ErrorService),
  LazySingleton(classType: ProfileService),
  LazySingleton(classType: ThemeService)
])
class AppSetup {}
