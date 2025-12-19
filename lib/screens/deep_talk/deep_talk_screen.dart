import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../data/questions.dart';

class DeepTalkScreen extends StatefulWidget {
  final String category;
  const DeepTalkScreen({super.key, required this.category});

  @override
  State<DeepTalkScreen> createState() => _DeepTalkScreenState();
}

class _DeepTalkScreenState extends State<DeepTalkScreen> {
  int _currentIndex = 0;
  late List<String> questions;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    questions = DeepTalkQuestions.getQuestions(widget.category);
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragOffset.dx.abs() > 100 || _dragOffset.dy.abs() > 100) {
      if (_currentIndex < questions.length - 1) {
        setState(() {
          _currentIndex++;
          _dragOffset = Offset.zero;
          _isDragging = false;
        });
      } else {
        setState(() {
          _dragOffset = Offset.zero;
          _isDragging = false;
        });
      }
    } else {
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
    }
  }

  Color _getCardColor(int index) {
    const Color startColor = Colors.white;
    const Color endColor = Color(0xFF800000);
    
    if (questions.isEmpty) return startColor;
    
    double t = index / (questions.length > 1 ? questions.length - 1 : 1);
    return Color.lerp(startColor, endColor, t) ?? startColor;
  }

  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 
        ? AppColors.text 
        : Colors.white;
  }

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
        title: Text(
          widget.category,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  '${_currentIndex + 1}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                Text(
                  ' / ${questions.length}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.text.withValues(alpha: 0.4),
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / questions.length,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: _buildSwipeableCards(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentIndex < questions.length - 1
                        ? () {
                            setState(() {
                              _currentIndex++;
                            });
                          }
                        : () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(_currentIndex < questions.length - 1
                        ? 'Kartu Berikutnya'
                        : 'Selesai'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableCards() {
    double dragPercent = 0.0;
    if (_isDragging) {
      dragPercent = (_dragOffset.dx.abs() / 200).clamp(0.0, 1.0);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_currentIndex + 2 < questions.length)
            _buildCard(
              questions[_currentIndex + 2],
              _currentIndex + 2,
              2,
              scale: 0.9 + (0.05 * dragPercent),
              offsetY: -30 + (15 * dragPercent),
            ),
          if (_currentIndex + 1 < questions.length)
            _buildCard(
              questions[_currentIndex + 1],
              _currentIndex + 1,
              1,
              scale: 0.95 + (0.05 * dragPercent),
              offsetY: -15 + (15 * dragPercent),
            ),
          if (_currentIndex < questions.length)
            GestureDetector(
              onPanStart: _onDragStart,
              onPanUpdate: _onDragUpdate,
              onPanEnd: _onDragEnd,
              child: Transform.translate(
                offset: _dragOffset,
                child: Transform.rotate(
                  angle: _dragOffset.dx / 1000,
                  child: _buildCard(
                    questions[_currentIndex],
                    _currentIndex,
                    0,
                    scale: 1.0,
                    offsetY: 0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(
    String question,
    int actualIndex,
    int visualStackIndex, {
    required double scale,
    required double offsetY,
  }) {
    Color cardColor = _getCardColor(actualIndex);
    Color textColor = _getTextColor(cardColor);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: MediaQuery.of(context).size.width - 48,
          height: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: visualStackIndex == 0 ? 0.2 : 0.0,
                ),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
            border: visualStackIndex != 0
                ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1)
                : Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
          ),
          child: Center(
            child: Text(
              question,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    height: 1.5,
                    color: textColor,
                    fontSize: 24,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}