import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/story_model.dart';
import '../settings/app_settings.dart';
import '../settings/story_progress.dart';

class ChoiceScreen extends StatelessWidget {
  final String storyId;
  final String sceneId;
  final String question;
  final List<Choice> choices;
  final VoidCallback onComplete;

  const ChoiceScreen({
    super.key,
    required this.storyId,
    required this.sceneId,
    required this.question,
    required this.choices,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final progress = context.watch<StoryProgress>();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: settings.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFD2B48C), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                question,
                style: TextStyle(
                  fontSize: 20 * settings.textScale,
                  fontWeight: FontWeight.bold,
                  color: settings.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...choices.map((choice) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    progress.setChoice(storyId, sceneId, choice.targetSceneId);
                    onComplete();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2B48C),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    choice.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}