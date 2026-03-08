class Story {
  final String id;
  final String title;
  final String? coverImage;
  final List<StoryLine> lines;

  final String description;
  final int routePoints;     
  final int routeTime;
  final String status;

  Story({
    required this.id,
    required this.title,
    this.coverImage,
    required this.lines,
    required this.description,
    required this.routePoints,
    required this.routeTime,
    required this.status,
  });
}

class StoryLine {
  final String text;
  final String? character;
  final String? image;
  final bool isMainHero;
  final bool isNarration;
  final String? backgroundImage;
  final InteractiveTask? task;

  final bool isInfoCard;
  final String? infoTitle;
  final String? infoDescription;
  final String? infoImage;

  StoryLine({
    required this.text,
    this.character,
    this.image,
    this.isMainHero = false,
    this.isNarration = false,
    this.backgroundImage,
    this.task,
    this.isInfoCard = false,
    this.infoTitle,
    this.infoDescription,
    this.infoImage,
  });
}

class InteractiveTask {
  final String question;
  final List<InteractiveOption> options;
  final int requiredCorrect;
  final bool isOnline;

  InteractiveTask({
    required this.question,
    required this.options,
    required this.requiredCorrect,
    this.isOnline = true,
  });
}

class InteractiveOption {
  final String text;
  final bool isCorrect;

  InteractiveOption({required this.text, required this.isCorrect});
}