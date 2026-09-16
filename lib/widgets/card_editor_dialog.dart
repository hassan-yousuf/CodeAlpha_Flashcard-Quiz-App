import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class CardEditorResult {
  const CardEditorResult({required this.question, required this.answer});

  final String question;
  final String answer;
}

class CardEditorDialog extends StatefulWidget {
  const CardEditorDialog({this.card, super.key});

  final Flashcard? card;

  @override
  State<CardEditorDialog> createState() => _CardEditorDialogState();
}

class _CardEditorDialogState extends State<CardEditorDialog> {
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
          onPressed: _submit,
          child: Text(widget.card == null ? 'Add card' : 'Save changes'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      CardEditorResult(
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      ),
    );
  }
}
