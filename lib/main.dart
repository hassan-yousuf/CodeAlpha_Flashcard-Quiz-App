import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const FlashcardApp());

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Cards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffe4764d),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfffffbf5),
        textTheme: GoogleFonts.manropeTextTheme(),
        useMaterial3: true,
      ),
      home: const StudyCardsPage(),
    );
  }
}

class Flashcard {
  Flashcard({required this.question, required this.answer});

  String question;
  String answer;
}

class StudyCardsPage extends StatefulWidget {
  const StudyCardsPage({super.key});

  @override
  State<StudyCardsPage> createState() => _StudyCardsPageState();
}

class _CardEditorResult {
  const _CardEditorResult({required this.question, required this.answer});

  final String question;
  final String answer;
}

class _CardEditorDialog extends StatefulWidget {
  const _CardEditorDialog({this.card});

  final Flashcard? card;

  @override
  State<_CardEditorDialog> createState() => _CardEditorDialogState();
}

class _CardEditorDialogState extends State<_CardEditorDialog> {
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.card?.question);
    _answerController = TextEditingController(text: widget.card?.answer);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.card == null ? 'New card' : 'Edit card'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _questionController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Question'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Add a question'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Add an answer'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                _CardEditorResult(
                  question: _questionController.text.trim(),
                  answer: _answerController.text.trim(),
                ),
              );
            }
          },
          child: Text(widget.card == null ? 'Add card' : 'Save changes'),
        ),
      ],
    );
  }
}

class _StudyCardsPageState extends State<StudyCardsPage> {
  final List<Flashcard> _cards = [
    Flashcard(question: 'What is the capital of Japan?', answer: 'Tokyo'),
    Flashcard(
      question: 'What does HTTP stand for?',
      answer: 'Hypertext Transfer Protocol',
    ),
    Flashcard(
      question: 'Which planet is known as the Red Planet?',
      answer: 'Mars',
    ),
  ];

  int _currentIndex = 0;
  bool _showAnswer = false;

  Flashcard get _currentCard => _cards[_currentIndex];

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cards.length;
      _showAnswer = false;
    });
  }

  void _previousCard() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
      _showAnswer = false;
    });
  }

  Future<void> _openCardEditor({Flashcard? card}) async {
    final result = await showDialog<_CardEditorResult>(
      context: context,
      builder: (context) => _CardEditorDialog(card: card),
    );

    if (result != null && mounted) {
      setState(() {
        if (card == null) {
          _cards.add(
            Flashcard(question: result.question, answer: result.answer),
          );
          _currentIndex = _cards.length - 1;
        } else {
          card.question = result.question;
          card.answer = result.answer;
        }
        _showAnswer = false;
      });
    }
  }

  Future<void> _deleteCurrentCard() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this card?'),
        content: const Text('This card will be removed from your study set.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      setState(() {
        _cards.removeAt(_currentIndex);
        if (_cards.isEmpty) {
          _currentIndex = 0;
        } else {
          _currentIndex = _currentIndex.clamp(0, _cards.length - 1);
        }
        _showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Study Cards',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            onPressed: () => _openCardEditor(),
            tooltip: 'Add card',
            icon: const Icon(Icons.add_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              child: _cards.isEmpty ? _buildEmptyState() : _buildStudyView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'KEEP LEARNING',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Your study set!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff27231f),
                ),
              ),
            ),
            Text(
              '${_currentIndex + 1} / ${_cards.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildCard()),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousCard,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _nextCard,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard() {
    final card = _currentCard;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.center,
        children: <Widget>[...previousChildren, ?currentChild],
      ),
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );
        return AnimatedBuilder(
          animation: curved,
          child: child,
          builder: (context, child) {
            final angle = (1 - curved.value) * 3.14159265359;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: child,
            );
          },
        );
      },
      child: Card(
        key: ValueKey('${card.question}-$_showAnswer'),
        elevation: 0,
        color: _showAnswer ? const Color(0xffcde9df) : const Color(0xffffd8c8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showAnswer ? 'ANSWER' : 'QUESTION',
                    style: TextStyle(
                      color: _showAnswer
                          ? const Color(0xff17705f)
                          : const Color(0xffb75232),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _openCardEditor(card: card),
                        tooltip: 'Edit card',
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: _deleteCurrentCard,
                        tooltip: 'Delete card',
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      _showAnswer ? card.answer : card.question,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSerifDisplay(
                        color: const Color(0xff27231f),
                        fontSize: 32,
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_showAnswer)
                FilledButton(
                  onPressed: () => setState(() => _showAnswer = true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xff27231f),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Show answer'),
                )
              else
                TextButton.icon(
                  onPressed: () => setState(() => _showAnswer = false),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Hide answer'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_stories_outlined, size: 52),
        const SizedBox(height: 18),
        Text(
          'Your study set is empty',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add a card to start learning.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => _openCardEditor(),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add your first card'),
        ),
      ],
    );
  }
}
