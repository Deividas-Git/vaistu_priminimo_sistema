import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/review.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({super.key});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _reviewController = TextEditingController();

  int _score = 5;

  void _onSend(BuildContext context) {
    final Review review = Review(score: _score, review: _reviewController.text);
    Navigator.pop(context, review);
  }

  void _onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  void _onScoreChange(int newScore) {
    setState(() {
      _score = newScore + 1;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Center(child: Text("Atsiliepimas")),
      content: SizedBox(
        width: 250,
        height: 220,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (int i) => IconButton(
                  onPressed: () => _onScoreChange(i),
                  icon: Icon(
                    i + 1 <= _score ? Icons.star : Icons.star_border_outlined,
                    color: i + 1 <= _score
                        ? Colors.amber
                        : Colors.amber.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorScheme.of(
                    context,
                  ).onSurfaceVariant.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                maxLength: 500,
                controller: _reviewController,
                maxLines: 4,
                minLines: 2,
                decoration: const InputDecoration(
                  hintText: "Pasidalinkite savo patirtimi",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _onCancel(context),
          child: Text("Atšaukti"),
        ),
        ElevatedButton(
          onPressed: () => _onSend(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: Text(
            "Siųsti",
            style: TextStyle(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}
