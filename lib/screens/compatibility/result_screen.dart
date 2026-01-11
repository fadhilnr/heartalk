import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/compatibility_provider.dart';

class ResultScreen extends StatefulWidget {
  final String resultId;
  final bool isNewTest;

  const ResultScreen({
    super.key,
    required this.resultId,
    this.isNewTest = true,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    final provider = context.read<CompatibilityProvider>();
    final result = provider.getResultById(widget.resultId);
    
    _animation = Tween<double>(begin: 0, end: result?.percentage ?? 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getAdvice(double percentage) {
    if (percentage >= 80) {
      return 'Luar biasa! Kalian memiliki kecocokan yang sangat tinggi. Teruslah membangun komunikasi dan saling mendukung.';
    } else if (percentage >= 60) {
      return 'Kecocokan yang baik! Ada beberapa perbedaan, tapi itu justru bisa membuat hubungan lebih berwarna. Teruslah saling memahami.';
    } else if (percentage >= 40) {
      return 'Kalian memiliki beberapa kesamaan, namun juga perbedaan yang cukup. Komunikasi terbuka adalah kunci untuk saling memahami.';
    } else {
      return 'Perbedaan bukan penghalang. Justru dari perbedaan, kalian bisa saling melengkapi dan belajar bersama.';
    }
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return AppColors.secondary;
    } else if (percentage >= 40) {
      return Colors.orange;
    } else {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompatibilityProvider>(
      builder: (context, provider, child) {
        final result = provider.getResultById(widget.resultId);
        
        if (result == null) {
          return Scaffold(
            body: Center(
              child: Text('Hasil tidak ditemukan'),
            ),
          );
        }

        final hasOtherTests = provider.getResultsByPartner(result.partnerName).length > 1;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.scale(
                                  scale: 0.8 + (0.2 * value),
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              Icons.favorite,
                              size: 80,
                              color: _getPercentageColor(result.percentage),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            widget.isNewTest ? 'Tingkat Kecocokan' : 'Hasil Tes Ulang',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.text.withValues(alpha: 0.6)),
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Text(
                                '${_animation.value.toInt()}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: _getPercentageColor(result.percentage),
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      result.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  size: 32,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      result.partnerName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: child,
                              );
                            },
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.lightbulb_outline,
                                        color: AppColors.secondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Saran',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(color: AppColors.secondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _getAdvice(result.percentage),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          height: 1.6,
                                          color: AppColors.text.withValues(alpha: 0.8),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (hasOtherTests) ...[
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                context.push(
                                  '/compatibility/comparison',
                                  extra: {'partnerName': result.partnerName},
                                );
                              },
                              icon: const Icon(Icons.analytics_outlined),
                              label: const Text('Lihat Perbandingan'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/compatibility/history'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Lihat Riwayat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Ke Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}