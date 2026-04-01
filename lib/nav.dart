import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/screens/onboarding_screen_1.dart';
import 'package:softlock/screens/onboarding_screen_2.dart';
import 'package:softlock/screens/consent_screen.dart';
import 'package:softlock/screens/home_screen.dart';
import 'package:softlock/screens/lock_screen.dart';
import 'package:softlock/screens/login_screen.dart';
import 'package:softlock/screens/splash_screen.dart';
import 'package:softlock/screens/stats_screen.dart';
import 'package:softlock/screens/settings_main_screen.dart';
import 'package:softlock/screens/apps_limits_screen.dart';
import 'package:softlock/screens/add_app_screen.dart';
import 'package:softlock/screens/edit_app_screen.dart';
import 'package:softlock/screens/partner_screen.dart';
import 'package:softlock/screens/goal_screen.dart';
import 'package:softlock/screens/notifications_screen.dart';
import 'package:softlock/screens/settings_placeholder_screen.dart';
import 'package:softlock/screens/privacy_screen.dart';
import 'package:softlock/screens/delete_confirm_screen.dart';
import 'package:softlock/screens/token_shop_screen.dart';

/// GoRouter configuration for app navigation
///
/// This uses go_router for declarative routing, which provides:
/// - Type-safe navigation
/// - Deep linking support (web URLs, app links)
/// - Easy route parameters
/// - Navigation guards and redirects
///
/// To add a new route:
/// 1. Add a route constant to AppRoutes below
/// 2. Add a GoRoute to the routes list
/// 3. Navigate using context.go() or context.push()
/// 4. Use context.pop() to go back.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.consent,
        name: 'consent',
        pageBuilder: (context, state) => const NoTransitionPage(child: ConsentScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding1,
        name: 'onboarding1',
        pageBuilder: (context, state) => const NoTransitionPage(child: OnboardingScreen1()),
      ),
      GoRoute(
        path: AppRoutes.onboarding2,
        name: 'onboarding2',
        pageBuilder: (context, state) {
          final extra = state.extra;
          String? name;
          List<String>? selectedApps;
          if (extra is Map) {
            final n = extra['name'];
            if (n is String) name = n;
            final apps = extra['selectedApps'];
            if (apps is List) {
              selectedApps = apps.whereType<String>().toList();
            }
          }
          return NoTransitionPage(child: OnboardingScreen2(name: name, selectedApps: selectedApps));
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.lock,
        name: 'lock',
        pageBuilder: (context, state) {
          final extra = state.extra;
          String appName = 'Instagram';
          String goal = 'I want to read more books';
          int unlockedEarlyCount = 2;
          int tokensRemaining = 2;
          String partnerPhoneE164 = '+15551234567';
          if (extra is Map) {
            final a = extra['appName'];
            if (a is String && a.trim().isNotEmpty) appName = a;
            final g = extra['goal'];
            if (g is String && g.trim().isNotEmpty) goal = g;
            final u = extra['unlockedEarlyCount'];
            if (u is int) unlockedEarlyCount = u;
            final t = extra['tokensRemaining'];
            if (t is int) tokensRemaining = t;
            final p = extra['partnerPhoneE164'];
            if (p is String && p.trim().isNotEmpty) partnerPhoneE164 = p;
          }
          return NoTransitionPage(
            child: LockScreen(
              appName: appName,
              goal: goal,
              unlockedEarlyCount: unlockedEarlyCount,
              tokensRemaining: tokensRemaining,
              partnerPhoneE164: partnerPhoneE164,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.stats,
        name: 'stats',
        pageBuilder: (context, state) => const NoTransitionPage(child: StatsScreen()),
      ),

      // Settings
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => const NoTransitionPage(child: SettingsMainScreen()),
      ),
      GoRoute(
        path: AppRoutes.appsLimits,
        name: 'appsLimits',
        pageBuilder: (context, state) => const NoTransitionPage(child: AppsLimitsScreen()),
      ),
      GoRoute(
        path: AppRoutes.addApp,
        name: 'addApp',
        pageBuilder: (context, state) => const NoTransitionPage(child: AddAppScreen()),
      ),
      GoRoute(
        path: '${AppRoutes.editApp}/:id',
        name: 'editApp',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return NoTransitionPage(child: EditAppScreen(appId: id));
        },
      ),
      GoRoute(
        path: AppRoutes.partner,
        name: 'partner',
        pageBuilder: (context, state) => const NoTransitionPage(child: PartnerScreen()),
      ),
      GoRoute(
        path: AppRoutes.goal,
        name: 'goal',
        pageBuilder: (context, state) => const NoTransitionPage(child: GoalScreen()),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => const NoTransitionPage(child: NotificationsScreen()),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: 'privacy',
        pageBuilder: (context, state) => const NoTransitionPage(child: PrivacyScreen()),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        name: 'deleteAccount',
        pageBuilder: (context, state) => const NoTransitionPage(child: DeleteConfirmScreen()),
      ),
      GoRoute(
        path: AppRoutes.tokens,
        name: 'tokens',
        pageBuilder: (context, state) => const NoTransitionPage(child: TokenShopScreen()),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        name: 'subscription',
        pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPlaceholderScreen(title: 'Subscription', icon: Icons.credit_card_rounded)),
      ),
    ],
  );
}

/// Route path constants
/// Use these instead of hard-coding route strings
class AppRoutes {
  static const String splash = '/';
  static const String consent = '/consent';
  static const String login = '/login';
  static const String onboarding1 = '/onboarding/1';
  static const String onboarding2 = '/onboarding/2';

  // Placeholder/home (legacy) route.
  static const String home = '/home';

  static const String lock = '/lock';

  static const String stats = '/stats';

  // Settings
  static const String settings = '/settings';
  static const String appsLimits = '/settings/apps';
  static const String addApp = '/settings/apps/add';
  static const String editApp = '/settings/apps/edit';
  static const String partner = '/settings/partner';
  static const String goal = '/settings/goal';
  static const String notifications = '/settings/notifications';
  static const String privacy = '/settings/privacy';
  static const String deleteAccount = '/settings/delete';
  static const String tokens = '/settings/tokens';
  static const String subscription = '/settings/subscription';
}
