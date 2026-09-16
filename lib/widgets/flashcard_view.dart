import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard.dart';

class FlashcardView extends StatelessWidget {
  const FlashcardView({
    required this.card,
    required this.showAnswer,
    required this.onToggleAnswer,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Flashcard card;
  final bool showAnswer;
  final VoidCallback onToggleAnswer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
      child: _CardSurface(
        key: ValueKey('${card.question}-$showAnswer'),
        card: card,
        showAnswer: showAnswer,
        onToggleAnswer: onToggleAnswer,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.card,
    required this.showAnswer,
    required this.onToggleAnswer,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Flashcard card;
  final bool showAnswer;
  final VoidCallback onToggleAnswer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: showAnswer ? const Color(0xffcde9df) : const Color(0xffffd8c8),
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
                  showAnswer ? 'ANSWER' : 'QUESTION',
                  style: TextStyle(
                    color: showAnswer
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
                      onPressed: onEdit,
                      tooltip: 'Edit card',
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: onDelete,
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
                    showAnswer ? card.answer : card.question,
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
            if (!showAnswer)
              FilledButton(
                onPressed: onToggleAnswer,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xff27231f),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Show answer'),
              )
            else
              TextButton.icon(
                onPressed: onToggleAnswer,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Hide answer'),
              ),
          ],
        ),
      ),
    );
  }
}
