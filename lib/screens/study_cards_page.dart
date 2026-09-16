import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../widgets/card_editor_dialog.dart';
import '../widgets/flashcard_view.dart';

class StudyCardsPage extends StatefulWidget {
  const StudyCardsPage({super.key});

  @override
  State<StudyCardsPage> createState() => _StudyCardsPageState();
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
            onPressed: _addCard,
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
        Expanded(
          child: FlashcardView(
            card: _currentCard,
            showAnswer: _showAnswer,
            onToggleAnswer: _toggleAnswer,
            onEdit: () => _editCard(_currentCard),
            onDelete: _deleteCurrentCard,
          ),
        ),
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
          onPressed: _addCard,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add your first card'),
        ),
      ],
    );
  }

  void _toggleAnswer() {
    setState(() => _showAnswer = !_showAnswer);
  }

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

  Future<void> _addCard() async {
    final result = await _openCardEditor();
    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _cards.add(Flashcard(question: result.question, answer: result.answer));
      _currentIndex = _cards.length - 1;
      _showAnswer = false;
    });
  }

  Future<void> _editCard(Flashcard card) async {
    final result = await _openCardEditor(card: card);
    if (result == null || !mounted) {
      return;
    }

    setState(() {
      card.question = result.question;
      card.answer = result.answer;
      _showAnswer = false;
    });
  }

  Future<CardEditorResult?> _openCardEditor({Flashcard? card}) {
    return showDialog<CardEditorResult>(
      context: context,
      builder: (context) => CardEditorDialog(card: card),
    );
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

    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() {
      _cards.removeAt(_currentIndex);
      _currentIndex = _cards.isEmpty
          ? 0
          : _currentIndex.clamp(0, _cards.length - 1);
      _showAnswer = false;
    });
  }
}
