import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/deep_talk/deep_talk_screen.dart';
import '../screens/compatibility/input_name_screen.dart';
import '../screens/compatibility/question_screen.dart';
import '../screens/compatibility/result_screen.dart';
import '../screens/compatibility/history_screen.dart';
import '../screens/compatibility/history_detail_screen.dart';
import '../screens/compatibility/comparison_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/deep-talk',
      builder: (context, state) {
        final category = state.uri.queryParameters['category'] ?? 'Pasangan';
        return DeepTalkScreen(category: category);
      },
    ),
    GoRoute(
      path: '/compatibility/input',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return InputNameScreen(
          existingResultId: extra?['existingResultId'],
        );
      },
    ),
    GoRoute(
      path: '/compatibility/question',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return QuestionScreen(
          userName: extra['userName']!,
          partnerName: extra['partnerName']!,
          existingResultId: extra['existingResultId'],
        );
      },
    ),
    GoRoute(
      path: '/compatibility/result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ResultScreen(
          resultId: extra['resultId']!,
          isNewTest: extra['isNewTest'] ?? true,
        );
      },
    ),
    GoRoute(
      path: '/compatibility/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/compatibility/history/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return HistoryDetailScreen(resultId: id);
      },
    ),
    GoRoute(
      path: '/compatibility/comparison',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ComparisonScreen(partnerName: extra['partnerName']!);
      },
    ),
  ],
);