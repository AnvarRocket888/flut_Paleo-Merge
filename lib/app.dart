import 'package:flutter/cupertino.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'utils/constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PaleoMergeApp extends StatelessWidget {
  const PaleoMergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: AppStrings.appName,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        barBackgroundColor: AppColors.surface,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.textPrimary,
        ),
      ),
      home: _AppRoot(),
    );
  }
}

/// Handles splash → main navigation at app startup.
class _AppRoot extends StatefulWidget {
  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _splashDone = false;

  void _onSplashComplete() {
    if (mounted) {
      setState(() => _splashDone = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return SplashScreen(onComplete: _onSplashComplete);
    }
    return const MainScreen();
  }
}
