import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../data/questions.dart';
import '../../providers/compatibility_provider.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String resultId;

  const HistoryDetailScreen({
    super.key,
    required this.resultId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CompatibilityProvider>(
      builder: (context, provider, child) {
        final result = provider.getResultById(resultId);

        if (result == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text('Hasil tidak ditemukan'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            ),
          );
        }

        final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
        final hasMultipleTests =
            provider.getResultsByPartner(result.partnerName).length > 1;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.text),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Detail Hasil',
              style: TextStyle(color: AppColors.text),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.text),
                onSelected: (value) {
                  if (value == 'retake') {
                    context.push(
                      '/compatibility/input',
                      extra: {'existingResultId': result.id},
                    );
                  } else if (value == 'delete') {
                    _showDeleteDialog(context, provider, result.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'retake',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Tes Ulang'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getPercentageColor(result.percentage),
                        _getPercentageColor(result.percentage).withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _getPercentageColor(result.percentage)
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            result.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Text(
                            result.partnerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${result.percentage.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tingkat Kecocokan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dateFormat.format(result.testDate),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Comparison Button
                if (hasMultipleTests)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.push(
                          '/compatibility/comparison',
                          extra: {'partnerName': result.partnerName},
                        );
                      },
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('Lihat Perbandingan dengan Tes Lain'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                if (hasMultipleTests) const SizedBox(height: 24),

                // Answers Detail
                Text(
                  'Detail Jawaban',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  result.userAnswers.length,
                  (index) => _buildAnswerItem(
                    context,
                    index,
                    CompatibilityQuestions.questions[index],
                    result.userName,
                    result.userAnswers[index],
                    result.partnerName,
                    result.partnerAnswers[index],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerItem(
    BuildContext context,
    int index,
    String question,
    String userName,
    bool userAnswer,
    String partnerName,
    bool partnerAnswer,
  ) {
    final isMatch = userAnswer == partnerAnswer;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMatch
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
          width: 2,
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
                  color: isMatch
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMatch ? Icons.check : Icons.close,
                  color: isMatch ? Colors.green : Colors.red,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pertanyaan ${index + 1}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isMatch ? Colors.green : Colors.red,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnswerBadge(
                  context,
                  userName,
                  userAnswer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnswerBadge(
                  context,
                  partnerName,
                  partnerAnswer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerBadge(BuildContext context, String name, bool answer) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            answer ? 'Ya' : 'Tidak',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return AppColors.secondary;
    if (percentage >= 40) return Colors.orange;
    return AppColors.primary;
  }

  void _showDeleteDialog(
    BuildContext context,
    CompatibilityProvider provider,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Hasil Tes?'),
        content: const Text(
          'Anda yakin ingin menghapus hasil tes ini? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteResult(id);
              Navigator.pop(context);
              context.go('/compatibility/history');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hasil tes berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}