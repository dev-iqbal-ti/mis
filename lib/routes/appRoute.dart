import 'package:dronees/features/unauthorized/bindings/loginBinding.dart';
import 'package:dronees/features/unauthorized/screens/login_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String INTRO = '/intro';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String REGISTERFORM = '/registerForm';
  static const String HOME = '/home';
  static const String MESSAGE = '/message';
  static const String JOBS = '/job';
  static const String PROFILE = '/profile';
  static const String APPLIEDJOB = '/jobList';
  static const String SEARCHJOB = '/searchList';
  static const String JOBDETAILS = '/jobDetails';

  static final routes = [
    // GetPage(name: INTRO, page: () => IntroScreen()),
    GetPage(name: LOGIN, page: () => LoginScreen(), binding: LoginBinding()),
    // GetPage(name: REGISTER, page: () => RegisterScreen(), binding: RegisterBinding()),
    // GetPage(name: REGISTERFORM, page: () => RegisterFormScreen(), binding: RegisterFormBinding()),
    // GetPage(name: HOME, page: () => MainHomeScreen(), binding: HomeBinding()),
    // GetPage(name: MESSAGE, page: () => MessageScreen(), binding: MessageBinding()),
    // GetPage(name: PROFILE, page: () => ProfileScreen(), binding: ProfileBinding()),
    // GetPage(name: JOBS, page: () => JobScreen(), binding: JobBinding()),
    // GetPage(name: APPLIEDJOB, page: () => JobAppliedList(), binding: JobBinding()),
    // GetPage(name: SEARCHJOB, page: () => JobSearchList(), binding: JobBinding()),
    // GetPage(name: JOBDETAILS, page: () => JobDetails(), binding: JobBinding())
  ];
}
