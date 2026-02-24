import '../models/story_model.dart';
import '../data/stories.dart';

class StoryRepository {
  static final List<Story> allStories = stories;

  static Story? getById(String id) =>
      allStories.firstWhere((s) => s.id == id, orElse: () => allStories.first);
}