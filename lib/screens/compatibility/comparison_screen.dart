import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/compatibility_provider.dart';

class ComparisonScreen extends StatelessWidget {
  final String partnerName;

  const ComparisonScreen({
    super.key,
    required this.partnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Perbandingan Hasil',
          style: TextStyle(color: AppColors.text),
        ),
        centerTitle: true,
      ),
      body: Consumer<CompatibilityProvider>(
        builder: (context, provider, child) {
          final results = provider.getComparisonData(partnerName);

          if (results.isEmpty) {
            return const Center(
              child: Text('Tidak ada data untuk dibandingkan'),
            );
          }

          final average = provider.getAveragePercentage(partnerName);
          final highest = results.reduce(
            (a, b) => a.percentage > b.percentage ? a : b,
          );
          final lowest = results.reduce(
            (a, b) => a.percentage < b.percentage ? a : b,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Text(
                  'Ringkasan Kecocokan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Rata-rata',
                        '${average.toInt()}%',
                        Icons.analytics_outlined,
                        AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total Tes',
                        '${results.length}',
                        Icons.fact_check_outlined,
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Tertinggi',
                        '${highest.percentage.toInt()}%',
                        Icons.arrow_upward,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Terendah',
                        '${lowest.percentage.toInt()}%',
                        Icons.arrow_downward,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Progress Insight
                if (results.length >= 2) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.secondary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timeline,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Insight',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getInsight(results),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Timeline
                Text(
                  'Timeline Tes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...results.map((result) => _buildTimelineItem(
                      context,
                      result,
                      results.indexOf(result) == 0,
                      results.indexOf(result) == results.length - 1,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.text.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    result,
    bool isFirst,
    bool isLast,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getPercentageColor(result.percentage),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getPercentageColor(result.percentage)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${result.percentage.toInt()}%',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: _getPercentageColor(result.percentage),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getPercentageColor(result.percentage)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getLabel(result.percentage),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getPercentageColor(result.percentage),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.text.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateFormat.format(result.testDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.text.withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.text.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeFormat.format(result.testDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.text.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.push('/compatibility/history/${result.id}');
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Lihat Detail'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInsight(List results) {
    if (results.length < 2) return '';

    final latest = results.last.percentage;
    final previous = results[results.length - 2].percentage;
    final difference = latest - previous;

    if (difference > 10) {
      return '🎉 Kecocokan meningkat ${difference.toInt()}%! Hubungan kalian semakin harmonis.';
    } else if (difference > 0) {
      return '😊 Ada peningkatan ${difference.toInt()}% dari tes sebelumnya. Terus pertahankan komunikasi yang baik!';
    } else if (difference < -10) {
      return '💭 Kecocokan menurun ${difference.abs().toInt()}%. Mungkin perlu lebih banyak komunikasi terbuka.';
    } else if (difference < 0) {
      return '📊 Sedikit penurunan ${difference.abs().toInt()}%. Ini normal, yang penting terus berusaha memahami satu sama lain.';
    } else {
      return '✨ Kecocokan tetap stabil! Konsistensi adalah kunci hubungan yang sehat.';
    }
  }

  String _getLabel(double percentage) {
    if (percentage >= 80) return 'Sangat Cocok';
    if (percentage >= 60) return 'Cocok';
    if (percentage >= 40) return 'Cukup';
    return 'Perlu Usaha';
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return AppColors.secondary;
    if (percentage >= 40) return Colors.orange;
    return AppColors.primary;
  }
}