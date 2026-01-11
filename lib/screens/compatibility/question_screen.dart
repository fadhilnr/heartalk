import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../data/questions.dart';
import '../../models/compatibility_result.dart';
import '../../providers/compatibility_provider.dart';

class QuestionScreen extends StatefulWidget {
  final String userName;
  final String partnerName;
  final String? existingResultId;

  const QuestionScreen({
    super.key,
    required this.userName,
    required this.partnerName,
    this.existingResultId,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;
  final List<bool?> _userAnswers = List.filled(
    CompatibilityQuestions.questions.length,
    null,
  );
  final List<bool?> _partnerAnswers = List.filled(
    CompatibilityQuestions.questions.length,
    null,
  );

  @override
  void initState() {
    super.initState();
    _loadExistingAnswers();
  }

  void _loadExistingAnswers() {
    if (widget.existingResultId != null) {
      final provider = context.read<CompatibilityProvider>();
      final existingResult = provider.getResultById(widget.existingResultId!);
      
      if (existingResult != null) {
        setState(() {
          for (int i = 0; i < existingResult.userAnswers.length; i++) {
            _userAnswers[i] = existingResult.userAnswers[i];
            _partnerAnswers[i] = existingResult.partnerAnswers[i];
          }
        });
      }
    }
  }

  void _answerQuestion(bool isUser, bool answer) {
    setState(() {
      if (isUser) {
        _userAnswers[_currentIndex] = answer;
      } else {
        _partnerAnswers[_currentIndex] = answer;
      }
    });
  }

  bool get _canProceed {
    return _userAnswers[_currentIndex] != null &&
        _partnerAnswers[_currentIndex] != null;
  }

  void _nextQuestion() {
    if (_canProceed) {
      if (_currentIndex < CompatibilityQuestions.questions.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _calculateAndSaveResult();
      }
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  Future<void> _calculateAndSaveResult() async {
    int matches = 0;
    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i] == _partnerAnswers[i]) {
        matches++;
      }
    }
    double percentage = (matches / _userAnswers.length) * 100;

    final provider = context.read<CompatibilityProvider>();
    
    final result = CompatibilityResult(
      id: widget.existingResultId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userName: widget.userName,
      partnerName: widget.partnerName,
      percentage: percentage,
      testDate: DateTime.now(),
      userAnswers: _userAnswers.cast<bool>(),
      partnerAnswers: _partnerAnswers.cast<bool>(),
    );

    if (widget.existingResultId != null) {
      await provider.updateResult(widget.existingResultId!, result);
    } else {
      await provider.addResult(result);
    }

    if (mounted) {
      context.push(
        '/compatibility/result',
        extra: {
          'resultId': result.id,
          'isNewTest': widget.existingResultId == null,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = CompatibilityQuestions.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: widget.existingResultId != null
            ? const Text('Tes Ulang', style: TextStyle(color: AppColors.text))
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${_currentIndex + 1}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    Text(
                      ' / ${CompatibilityQuestions.questions.length}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.text.withValues(alpha: 0.4),
                          ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) /
                            CompatibilityQuestions.questions.length,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey(_currentIndex),
                  children: [
                    Container(
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
                      child: Text(
                        question,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildAnswerSection(
                      widget.userName,
                      _userAnswers[_currentIndex],
                      true,
                    ),
                    const SizedBox(height: 24),
                    _buildAnswerSection(
                      widget.partnerName,
                      _partnerAnswers[_currentIndex],
                      false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Kembali'),
                    ),
                  ),
                if (_currentIndex > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(_currentIndex <
                            CompatibilityQuestions.questions.length - 1
                        ? 'Lanjut'
                        : 'Lihat Hasil'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(String name, bool? answer, bool isUser) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnswerButton(
                  'Ya',
                  true,
                  answer == true,
                  () => _answerQuestion(isUser, true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnswerButton(
                  'Tidak',
                  false,
                  answer == false,
                  () => _answerQuestion(isUser, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(
    String label,
    bool value,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}