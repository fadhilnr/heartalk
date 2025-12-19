import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../widgets/category_selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FloatingHeartsAnimation(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Heartalk',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Percakapan yang lebih dalam,\nhubungan yang lebih dekat',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.text.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 60),
                  _buildFeatureCard(
                    context,
                    title: 'Deep Talk',
                    subtitle: 'Pertanyaan mendalam untuk percakapan bermakna',
                    icon: Icons.chat_bubble_outline,
                    onTap: () => _showCategorySelector(context),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    title: 'Tes Kecocokan',
                    subtitle: 'Ukur kecocokan dengan pasanganmu',
                    icon: Icons.favorite_border,
                    onTap: () => context.push('/compatibility/input'),
                  ),
                  const Spacer(),
                  _buildBottomSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.text.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategorySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategorySelector(),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.secondary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tips_and_updates_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Tips Hari Ini',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '"Komunikasi yang baik dimulai dengan mendengarkan, bukan hanya menunggu giliran berbicara."',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text.withValues(alpha: 0.7),
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingHeartsAnimation extends StatefulWidget {
  const FloatingHeartsAnimation({super.key});

  @override
  State<FloatingHeartsAnimation> createState() =>
      _FloatingHeartsAnimationState();
}

class _FloatingHeartsAnimationState extends State<FloatingHeartsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Heart> _hearts = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 25; i++) {
      _hearts.add(_generateHeart(true));
    }
  }

  _Heart _generateHeart(bool randomStart) {
    return _Heart(
      x: _random.nextDouble(),
      y: randomStart ? 0.5 + _random.nextDouble() * 0.7 : 1.2,
      size: _random.nextDouble() * 20 + 15,
      speed: _random.nextDouble() * 0.0015 + 0.0005,
      baseOpacity: _random.nextDouble() * 0.4 + 0.2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _HeartsPainter(_hearts, _random, (index) {
            _hearts[index] = _generateHeart(false);
          }),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Heart {
  double x;
  double y;
  double size;
  double speed;
  double baseOpacity;

  _Heart({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.baseOpacity,
  });
}

class _HeartsPainter extends CustomPainter {
  final List<_Heart> hearts;
  final math.Random random;
  final Function(int) onReset;

  _HeartsPainter(this.hearts, this.random, this.onReset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    const double stopThreshold = 0.45;

    for (int i = 0; i < hearts.length; i++) {
      final heart = hearts[i];
      heart.y -= heart.speed;

      if (heart.y > stopThreshold) {
        double fadeFactor = (heart.y - stopThreshold) * 1.8;
        double currentOpacity = fadeFactor.clamp(0.0, 1.0) * heart.baseOpacity;

        paint.color = AppColors.primary.withValues(alpha: currentOpacity);

        final double x = heart.x * size.width;
        final double y = heart.y * size.height;

        Path path = Path();
        path.moveTo(x, y + heart.size / 4);
        path.cubicTo(x, y, x - heart.size / 2, y, x - heart.size / 2,
            y + heart.size / 4);
        path.cubicTo(x - heart.size / 2, y + heart.size / 2, x,
            y + heart.size * 0.8, x, y + heart.size);
        path.cubicTo(x, y + heart.size * 0.8, x + heart.size / 2,
            y + heart.size / 2, x + heart.size / 2, y + heart.size / 4);
        path.cubicTo(x + heart.size / 2, y, x, y, x, y + heart.size / 4);

        canvas.drawPath(path, paint);
      } else {
        onReset(i);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}