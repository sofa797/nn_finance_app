import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../settings/story_progress.dart';
import '../settings/app_settings.dart';
import '../models/story_model.dart';

class StoryScreen extends StatefulWidget {
  final Story story;

  const StoryScreen({super.key, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late FlutterTts _tts;
  bool _isAudioMode = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _tts.awaitSpeakCompletion(true);

    _tts.setCompletionHandler(() {
      if (_isAudioMode && !_isDisposed) {
        _playNextLine();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tts.stop();
    //_tts.dispose();
    super.dispose();
  }

  void _playNextLine() async {
    final progress = context.read<StoryProgress>();
    final lines = widget.story.lines;
    final currentIndex = progress.getIndex(widget.story.id);

    if (currentIndex < lines.length) {
      progress.next(widget.story.id, lines.length);
      if (progress.getIndex(widget.story.id) < lines.length) {
        final current = lines[progress.getIndex(widget.story.id)];
        await _tts.stop();
        await _tts.speak(current.text);
      }
    }
  }

  void _toggleAudioMode(StoryProgress progress) {
    setState(() {
      _isAudioMode = !_isAudioMode;
    });

    final lines = widget.story.lines;
    final index = progress.getIndex(widget.story.id);

    if (_isAudioMode && index < lines.length) {
      _tts.stop();
      _tts.speak(lines[index].text);
    } else {
      _tts.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<StoryProgress>();
    final settings = context.watch<AppSettings>();
    final lines = widget.story.lines;
    final isEnd = progress.isCompleted(widget.story.id, lines.length);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: settings.backgroundColor,
        foregroundColor: settings.textColor,
        title: null,
        actions: [
          IconButton(
            icon: Icon(
              _isAudioMode ? Icons.headphones : Icons.menu_book,
              color: settings.textColor,
            ),
            tooltip: _isAudioMode ? 'Режим слушать' : 'Режим читать',
            onPressed: () => _toggleAudioMode(progress),
          ),
        ],
      ),
      body: isEnd
          ? _buildEndStory(context, settings, progress)
          : _buildStoryContent(
              context,
              lines[progress.getIndex(widget.story.id)],
              settings,
              progress,
            ),
    );
  }

  Widget _buildStoryContent(BuildContext context, StoryLine current,
      AppSettings settings, StoryProgress progress) {
    if (_isAudioMode && !current.isNarration) {
      _tts.speak(current.text);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!_isAudioMode) {
          _tts.stop();
          progress.next(widget.story.id, widget.story.lines.length);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: current.backgroundImage != null && settings.imagesEnabled
                  ? SizedBox.expand(
                      key: ValueKey(current.backgroundImage),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        child: Image.asset(current.backgroundImage!),
                      ),
                    )
                  : settings.imagesEnabled && widget.story.coverImage != null
                      ? SizedBox.expand(
                          key: const ValueKey('story_cover'),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            child: Image.asset(widget.story.coverImage!),
                          ),
                        )
                      : Container(color: settings.backgroundColor),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: settings.darkTheme
                  ? Colors.black.withOpacity(0.55)
                  : Colors.black.withOpacity(0.35),
            ),
          ),
          if (settings.imagesEnabled && current.image != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Transform.translate(
                  key: ValueKey(current.image),
                  offset: current.isMainHero
                      ? const Offset(60, 0)
                      : const Offset(-60, 0),
                  child: Image.asset(
                    current.image!,
                    fit: BoxFit.contain,
                    alignment: current.isMainHero
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
          if (current.isNarration)
            Center(child: _buildNarrationBubble(context, current, settings)),
          if (!current.isNarration)
            _buildCharacterBubble(context, current, settings),
        ],
      ),
    );
  }

  Widget _buildNarrationBubble(
      BuildContext context, StoryLine current, AppSettings settings) {
    final textScale = MediaQuery.of(context).textScaleFactor * settings.textScale;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD2B48C), width: 2),
        ),
        child: Text(
          current.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20 * textScale,
            color: settings.textColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterBubble(
      BuildContext context, StoryLine current, AppSettings settings) {
    final textScale = MediaQuery.of(context).textScaleFactor * settings.textScale;
    final screenWidth = MediaQuery.of(context).size.width;
    final alignment = current.isMainHero ? Alignment.bottomRight : Alignment.bottomLeft;
    final marginLeft = current.isMainHero ? screenWidth * 0.2 : 20.0;
    final marginRight = current.isMainHero ? 20.0 : screenWidth * 0.2;

    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(left: marginLeft, right: marginRight, bottom: 80),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.65),
          child: IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD2B48C), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (current.character != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2B48C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        current.character!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Text(
                    current.text,
                    style: TextStyle(
                      fontSize: 18 * textScale,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndStory(
      BuildContext context, AppSettings settings, StoryProgress progress) {
    return Stack(
      children: [
        Positioned.fill(
          child: settings.imagesEnabled && widget.story.coverImage != null
              ? Image.asset(
                  widget.story.coverImage!,
                  fit: BoxFit.cover,
                )
              : Container(color: settings.backgroundColor),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.65)),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Конец истории',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28 * settings.textScale,
                    fontWeight: FontWeight.bold,
                    color: settings.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Вы можете пройти историю заново или вернуться в меню',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18 * settings.textScale,
                    color: settings.textColor.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2B48C),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Безопасный сброс прогресса после построения кадра
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      progress.reset(widget.story.id);

                      if (_isAudioMode && widget.story.lines.isNotEmpty) {
                        _playNextLine();
                      }
                    });
                  },
                  child: Text(
                    'Начать заново',
                    style: TextStyle(
                      fontSize: 18 * settings.textScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}