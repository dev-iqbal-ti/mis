import 'package:dronees/bindings/general_binding.dart';
import 'package:dronees/bottom_navigator.dart';
import 'package:dronees/data/repositories/auth_repository.dart';
import 'package:dronees/features/unauthorized/screens/onboarding_screen.dart';
// import 'package:dronees/features/authorized/attendance/screens/attendance_mark_screen.dart';
// import 'package:dronees/features/authorized/attendance/screens/attendance_screen.dart';
// import 'package:dronees/features/authorized/travel_allowance/screens/submit_travel_allowance.dart';
// import 'package:dronees/features/authorized/travel_allowance/screens/travel_allowance_summary.dart';
// import 'package:dronees/features/unauthorized/screens/login_screen.dart';
// import 'package:dronees/features/unauthorized/screens/onboarding_screen.dart';
// import 'package:dronees/routes/appRoute.dart';
// import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );

  //* GetX local Storage
  await GetStorage.init();

  //*  preserve Splash until item Load...
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Get.put(AuthRepository());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //* This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) => GetMaterialApp(
        title: 'Dronees',
        themeMode: ThemeMode.light,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.lightTheme,

        debugShowCheckedModeBanner: false,
        initialBinding: GeneralBindings(),
        // home: Scaffold(
        //   backgroundColor: TColors.primary,
        //   body: Center(child: CircularProgressIndicator(color: Colors.white)),
        // ),
        home: OnboardingScreen(),
      ),
    );
    // home: const VideoListingScreen()),
  }
}
