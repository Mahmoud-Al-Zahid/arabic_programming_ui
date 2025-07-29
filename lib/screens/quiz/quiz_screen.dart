import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../results/results_screen.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late List<Map<String, dynamic>> _questions;
  final Map<int, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _questions = List<Map<String, dynamic>>.from(widget.quiz['questions']);
  }

  void _answerQuestion(int selectedOptionIndex) {
    if (selectedOptionIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      _answers[_currentQuestionIndex] = selectedOptionIndex;
    });

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            score: _score,
            totalQuestions: _questions.length,
          ),
        ),
      );
    }
  }

  Widget _buildMultipleChoiceQuestion(Map<String, dynamic> question) {
    final options = List<String>.from(question['options']);
    final selectedAnswer = _answers[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _answerQuestion(index),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFillBlankQuestion(Map<String, dynamic> question) {
    final controller = TextEditingController();
    if (_answers[_currentQuestionIndex] != null) {
      controller.text = _answers[_currentQuestionIndex].toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            question['code'],
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'اكتب إجابتك هنا',
            border: OutlineInputBorder(),
            hintText: 'أكمل الكود المفقود',
          ),
          onChanged: (value) => setState(() {
            _answers[_currentQuestionIndex] = value;
          }),
        ),
      ],
    );
  }

  Widget _buildDragDropQuestion(Map<String, dynamic> question) {
    final codeBlocks = List<String>.from(question['codeBlocks']);
    final userOrder = _answers[_currentQuestionIndex] as List<int>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'اسحب الكتل لترتيبها بالشكل الصحيح:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        
        // Drop Zone
        Container(
          width: double.infinity,
          min: 120,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: userOrder.map((index) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Text(
                  codeBlocks[index],
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        
        // Available Blocks
        Text(
          'الكتل المتاحة:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        ...codeBlocks.asMap().entries.map((entry) {
          final index = entry.key;
          final block = entry.value;
          final isUsed = userOrder.contains(index);

          if (isUsed) return const SizedBox.shrink();

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  final newOrder = List<int>.from(userOrder);
                  newOrder.add(index);
                  _answers[_currentQuestionIndex] = newOrder;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  block,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        
        // Reset Button
        if (userOrder.isNotEmpty)
          TextButton(
            onPressed: () => setState(() {
              _answers[_currentQuestionIndex] = <int>[];
            }),
            child: const Text('إعادة تعيين'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final hasAnswer = _answers.containsKey(_currentQuestionIndex);
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz['title']),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Header
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السؤال ${_currentQuestionIndex + 1} من ${_questions.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '05:00', // Mock timer
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Question Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: () {
                  switch (currentQuestion['type']) {
                    case 'multiple_choice':
                      return _buildMultipleChoiceQuestion(currentQuestion);
                    case 'fill_blank':
                      return _buildFillBlankQuestion(currentQuestion);
                    case 'drag_drop':
                      return _buildDragDropQuestion(currentQuestion);
                    default:
                      return const Text('نوع سؤال غير مدعوم');
                  }
                }(),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  // Previous Button
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() {
                          _currentQuestionIndex--;
                        }),
                        child: const Text('السابق'),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                  // Next/Finish Button
                  Expanded(
                    flex: _currentQuestionIndex == 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: hasAnswer ? (isLastQuestion ? () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResultsScreen(score: _score, totalQuestions: _questions.length))) : () => setState(() { _currentQuestionIndex++; }) ) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        isLastQuestion ? 'إنهاء الاختبار' : 'التالي',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
