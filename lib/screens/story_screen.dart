import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/story_progress.dart';
import '../settings/app_settings.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StoryLine {
  final String text;
  final String? character;
  final String? image;
  final bool isMainHero;
  final bool isNarration;
  final String? backgroundImage;

  const StoryLine({
    required this.text,
    this.character,
    this.image,
    this.isMainHero = false,
    this.isNarration = false,
    this.backgroundImage,
  });
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();

  final List<StoryLine> story = const [
    StoryLine(
      text: 'Приветствуем Вас в нашем приложении! Эта история о том, как развивалась финансовая жизнь Нижнего Новгорода. Вы сможете прочитать данную историю как в удобном Вам месте, так и прогуляться по финансовому маршруту Нижнего Новгорода.',
      isNarration: true,
    ),
    StoryLine(
      text: 'Предлагаем Вам познакомиться с главным героем, в роли которого вы проживете эту историю. Приятного прочтения!',
      isNarration: true,
    ),
    StoryLine(
      text: 'Меня зовут Александр Бугров, мне 24 года.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Работаю стажером-аналитиком в Волго-Вятском главном управлении Центрального Банка.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Родился и вырос здесь, в Нижнем Новгороде — отец инженер, мама учительница истории.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Бабушка всегда рассказывала, что мы потомки тех самых Бугровых, знаменитых купцов, через младшую ветвь семьи, которая обеднела после революции.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Я никогда особо не верил — ну Бугровых в России тысячи, какие мы родственники миллионеров?',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Но дома до сих пор хранится потёртая фотография 1908 года, на обороте надпись:',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: '"Николай Александрович с племянником Сашей". Странное совпадение, не более.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Окончил Вышку, защитил диплом о банковской системе Российской империи — всегда нравилось копаться в истории финансов.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'После магистратуры решил вернуться в родной город, не хотел оставаться в Москве.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Четыре месяца назад устроился в ЦБ стажером, снимаю квартиру в центре, в старом купеческом квартале.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Коллеги говорят, что я перфекционист и слишком принципиальный — может, и так. Верю, что финансы должны служить людям, а не наоборот.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'По утрам бегаю вдоль Волги, коллекционирую старинные монеты, веду небольшой блог об истории денег в России.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Иногда волонтерю в городском приюте — сам не понимаю, откуда эта потребность помогать чужим людям, просто чувствую, что должен.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Странная вещь: когда прохожу мимо зданий, которые построил Николай Бугров — ночлежка на Рождественской, здание Думы — всегда накрывает какое-то дежавю.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),
    StoryLine(
      text: 'Будто эти стены меня помнят. Бред, конечно.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
    ),

    //ПРОЛОГ: МОНЕТА ВРЕМЕНИ
    //СЦЕНА 1: СОН (затемнение, голоса)
    StoryLine(
      text: '[Темнота. Звуки ярмарки XIX века: гул голосов, конские копыта, скрип телег. Постепенно проступает силуэт мужчины в купеческом кафтане]',
      isNarration: true,
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),
    StoryLine(
      text: '''(эхом, встревоженно)
Александр...Племянник.... Слышишь меня?''',
      character: 'Голос Бугрова',
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),
    StoryLine(
      text: '''(сонно, неразборчиво)
Кто... кто вы?''',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),
    StoryLine(
      text: '''(настойчивее)
Времени мало. Заговор... мука... к вечеру все потеряет. Только ты можешь помочь. Ищи монету. Она приведет тебя.''',
      character: 'Голос Бугрова',
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),
    StoryLine(
      text: 'Какую монету? Я вас не понимаю!',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),
    StoryLine(
      text: '''(затихая)
Монета 1885 года... Главный дом... Помни — ты Бугров. Кровь помнит...''',
      character: 'Голос Громова',
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),
    StoryLine(
      text: '[Резкий звук — Саша просыпается]',
      isNarration: true,
      backgroundImage: 'assets/images/bedroom_alex.png',
    ),

    //СЦЕНА 2: УТРО В КВАРТИРЕ
    StoryLine(
      text: '[Саша сидит на кровати, тяжело дышит]',
      isNarration: true,
      backgroundImage: 'assets/images/bedroom_alex_morning.png',
    ),
    StoryLine(
      text: '''(сам себе, устало)
Опять этот сон... Уже третью ночь подряд.''',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
      backgroundImage: 'assets/images/bedroom_alex_morning.png',
    ),
    StoryLine(
      text: '[Смотрит на часы — 8:47]',
      isNarration: true,
      backgroundImage: 'assets/images/bedroom_alex_morning.png',
    ),
    StoryLine(
      text: 'Черт, опять проспал пробежку.',
      character: 'Александр Бугров',
      image: 'assets/images/alex.png',
      isMainHero: true,
      backgroundImage: 'assets/images/bedroom_alex_morning.png',
    ),
  ];
}

class _StoryScreenState extends State<StoryScreen> {
  late FlutterTts _tts;
  bool _isAudioMode = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.setSpeechRate(0.5);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
    _tts.awaitSpeakCompletion(true);

    _tts.setCompletionHandler(() {
      if (_isAudioMode) _playNextLine();
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _playNextLine() async {
    final progress = context.read<StoryProgress>();
    final story = widget.story;

    if (progress.index < story.length - 1) {
      progress.next(story.length);
      final current = story[progress.index];
      await _tts.stop();
      await _tts.speak(current.text);
    }
  }

  void _toggleAudioMode(StoryProgress progress) {
    setState(() {
      _isAudioMode = !_isAudioMode;
    });
    if (_isAudioMode && progress.index < widget.story.length) {
      final current = widget.story[progress.index];
      _tts.stop();
      _tts.speak(current.text);
    } else {
      _tts.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<StoryProgress>();
    final settings = context.watch<AppSettings>();
    final story = widget.story;
    final bool isEnd = progress.index >= story.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: settings.backgroundColor,
        foregroundColor: settings.textColor,
        title: Text(
          'История',
          style: TextStyle(
            color: settings.textColor,
            fontSize: 24 * settings.textScale,
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: settings.textColor),
        //   onPressed: () => Navigator.pop(context),
        // ),
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
              context, story[progress.index], settings, progress),
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
          progress.next(widget.story.length);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: current.backgroundImage != null && settings.imagesEnabled
                  ? SizedBox.expand(
                      key: ValueKey(current.backgroundImage),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        child: Image.asset(current.backgroundImage!),
                      ),
                    )
                  : settings.imagesEnabled
                      ? SizedBox.expand(
                          key: const ValueKey('story_theme'),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/story_theme.png'),
                          ),
                        )
                      : Container(
                          key: const ValueKey('bg_container'),
                          color: settings.backgroundColor,
                        ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: settings.darkTheme
                  ? Colors.black.withOpacity(0.55)
                  : Colors.black.withOpacity(0.35),
            ),
          ),
          if (current.isNarration)
            Center(child: _buildNarrationBubble(context, current, settings)),
          if (settings.imagesEnabled)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: current.image != null
                    ? Transform.translate(
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
                      )
                    : const SizedBox.shrink(),
              ),
            ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        if (settings.imagesEnabled)
          Positioned.fill(
            child: Image.asset(
              'assets/images/story_theme.png',
              fit: BoxFit.cover,
            ),
          )
        else
          Positioned.fill(
            child: Container(color: settings.backgroundColor),
          ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.65),
          ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    progress.reset();
                    if (_isAudioMode && widget.story.isNotEmpty) {
                      _playNextLine();
                    }
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