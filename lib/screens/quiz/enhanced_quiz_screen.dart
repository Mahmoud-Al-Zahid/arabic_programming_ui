import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:async';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../results/enhanced_results_screen.dart';

class EnhancedQuizScreen extends StatefulWidget {
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedQuizScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedQuizScreen> createState() => _EnhancedQuizScreenState();
}

class _EnhancedQuizScreenState extends State<EnhancedQuizScreen>
    with TickerProviderStateMixin {
  late AnimationController _questionAnimationController;
  late Animation<double> _questionAnimation;
  late AnimationController _timerAnimationController;

  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;
  Timer? _timer;
  int _secondsRemaining = 30; // Time limit per question

  final List<Map<String, dynamic>> _quizQuestions = MockData.quizQuestions; // Corrected access

  @override
  void initState() {
    super.initState();
    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _questionAnimation = CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeOutCubic,
    );

    _timerAnimationController = AnimationController(
      duration: Duration(seconds: _secondsRemaining),
      vsync: this,
    );

    _startQuestionAnimation();
    _startTimer();
  }

  void _startQuestionAnimation() {
    _questionAnimationController.reset();
    _questionAnimationController.forward();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 30; // Reset timer for each question
    _timerAnimationController.duration = Duration(seconds: _secondsRemaining);
    _timerAnimationController.reset();
    _timerAnimationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _handleAnswer(null); // Time's up
      }
    });
  }

  void _handleAnswer(int? selectedIndex) {
    if (_isAnswered) return;

    _timer?.cancel();
    setState(() {
      _isAnswered = true;
      _selectedOption = selectedIndex != null
          ? _quizQuestions[_currentQuestionIndex]['options'][selectedIndex]
          : null;

      if (selectedIndex == _quizQuestions[_currentQuestionIndex]['correctAnswer']) {
        _score += _quizQuestions[_currentQuestionIndex]['points'] as int;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedOption = null;
      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex < _quizQuestions.length) {
      _startQuestionAnimation();
      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EnhancedResultsScreen(
            score: _score,
            totalQuestions: _quizQuestions.length,
            currentTheme: widget.currentTheme,
            onThemeChange: widget.onThemeChange,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _questionAnimationController.dispose();
    _timerAnimationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;
    final currentQuestion = _quizQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الاختبار'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppThemes.getGradient(widget.currentTheme).colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${_currentQuestionIndex + 1}/${_quizQuestions.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer Progress Bar
          LinearProgressIndicator(
            value: _secondsRemaining / 30,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              _secondsRemaining > 10 ? Colors.green : Colors.red,
            ),
            minHeight: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question Card
                  AnimationLimiter(
                    child: FadeTransition(
                      opacity: _questionAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_questionAnimation),
                        child: Card(
                          elevation: AppConstants.cardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
                            child: Column(
                              children: [
                                Text(
                                  currentQuestion['question'],
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: themeConfig['primary'],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Timer Display
                                AnimatedBuilder(
                                  animation: _timerAnimationController,
                                  builder: (context, child) {
                                    return Text(
                                      'الوقت المتبقي: $_secondsRemaining ثانية',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: _secondsRemaining <= 10 ? Colors.red : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Options
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: currentQuestion['options'].length,
                        itemBuilder: (context, index) {
                          final option = currentQuestion['options'][index];
                          final isCorrect = index == currentQuestion['correctAnswer'];
                          final isSelected = option == _selectedOption;

                          Color? optionColor;
                          if (_isAnswered) {
                            if (isCorrect) {
                              optionColor = Colors.green.withOpacity(0.8);
                            } else if (isSelected) {
                              optionColor = Colors.red.withOpacity(0.8);
                            }
                          }

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: ElevatedButton(
                                    onPressed: _isAnswered ? null : () => _handleAnswer(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: optionColor ?? Theme.of(context).colorScheme.surface,
                                      foregroundColor: _isAnswered && isCorrect ? Colors.white : Theme.of(context).colorScheme.onSurface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                                        side: BorderSide(
                                          color: _isAnswered && isSelected && !isCorrect
                                              ? Colors.red
                                              : (isSelected && !_isAnswered ? themeConfig['primary'] : Colors.transparent),
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                      elevation: _isAnswered ? 0 : AppConstants.cardElevation,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        option,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: _isAnswered && isCorrect ? Colors.white : null,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
}
