import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../settings/app_settings.dart';
import 'article_web_screen.dart';
import 'package:just_audio/just_audio.dart';

class PodcastPanel extends StatefulWidget {
  final List<Map<String, dynamic>> articles;
  final int initialIndex;
  final AudioPlayer player;

  const PodcastPanel({
    super.key,
    required this.articles,
    required this.initialIndex,
    required this.player,
  });

  @override
  State<PodcastPanel> createState() => _PodcastPanelState();
}

class _PodcastPanelState extends State<PodcastPanel> {
  late int currentIndex;
  bool isPlaying = false;
  double speed = 1.0;

  Duration totalDuration = Duration.zero;
  Duration currentPosition = Duration.zero;

  AudioPlayer get _player => widget.player;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    totalDuration = Duration(
      seconds: widget.articles[currentIndex]['duration'] ?? 0,
    );

    _player.positionStream.listen((pos) {
      setState(() => currentPosition = pos);
    });

    _player.playerStateStream.listen((state) {
      setState(() => isPlaying = state.playing);
    });
  }

  Future<void> _loadAudio(int index, {bool autoPlay = true}) async {
    final audioAsset = widget.articles[index]['audioAsset'] ?? '';
    if (audioAsset.isEmpty) return;

    await _player.stop();
    await _player.setAsset(audioAsset);
    await _player.setSpeed(speed);

    setState(() {
      currentIndex = index;
      totalDuration =
          Duration(seconds: widget.articles[currentIndex]['duration'] ?? 0);
      currentPosition = Duration.zero;
    });

    if (autoPlay) await _player.play();
  }

  void _playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _prev() async {
    if (currentIndex > 0) {
      await _loadAudio(currentIndex - 1);
    }
  }

  void _next() async {
    if (currentIndex < widget.articles.length - 1) {
      await _loadAudio(currentIndex + 1);
    }
  }

  void _setSpeed(double val) {
    setState(() => speed = val);
    _player.setSpeed(speed);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.articles[currentIndex];

    return SlidingUpPanel(
      minHeight: 80,
      maxHeight: MediaQuery.of(context).size.height,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      panelBuilder: (_) => _buildPanel(article),
      collapsed: _buildCollapsed(article),
    );
  }

  Widget _buildPanel(Map<String, dynamic> article) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          article['image'] ?? 'assets/images/logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Slider(
                          min: 0,
                          max: totalDuration.inSeconds.toDouble(),
                          value: currentPosition.inSeconds
                              .clamp(0, totalDuration.inSeconds)
                              .toDouble(),
                          onChanged: (value) async {
                            final newPosition =
                                Duration(seconds: value.toInt());
                            await _player.seek(newPosition);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(currentPosition)),
                            Text(_formatDuration(totalDuration)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _prev,
                      ),
                      IconButton(
                        iconSize: 70,
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                        ),
                        onPressed: _playPause,
                      ),
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(Icons.skip_next),
                        onPressed: _next,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Скорость:"),
                      const SizedBox(width: 8),
                      PopupMenuButton<double>(
                        initialValue: speed,
                        onSelected: _setSpeed,
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 1.0, child: Text("1x")),
                          PopupMenuItem(value: 1.25, child: Text("1.25x")),
                          PopupMenuItem(value: 1.5, child: Text("1.5x")),
                          PopupMenuItem(value: 2.0, child: Text("2x")),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text("${speed}x"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsed(Map<String, dynamic> article) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            article['image'] ?? 'assets/images/logo.jpg',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(article['title']!,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
          iconSize: 36,
          onPressed: _playPause,
        ),
      ),
    );
  }
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final AudioPlayer _player = AudioPlayer();

  static final List<Map<String, String>> architectureCards = const [
    {
      'image': 'assets/images/logo.jpg',
      'description':
          'Предлагаем Вам поближе познакомиться с финансовой архитектурой Нижнего Новгорода.',
    },
    {
      'image': 'assets/images/fair_cards.png',
      'description':
          'Нижегородская ярмарка — крупнейший торговый центр России XIX века.',
    },
  ];

  static final List<Map<String, String>> characterCards = const [
    {'image': 'assets/images/alex.png', 'name': 'Александр Бугров', 'description': 'Главный герой истории'},
    {'image': 'assets/images/hero.png', 'name': 'Герой 2', 'description': 'Другой персонаж'},
  ];

  static final List<Map<String, dynamic>> articleCards = [
    {
      'title': 'Строили для истории',
      'url': 'https://museum.cbr.ru/articles/stroili-dlya-istorii/',
      'text': 'first',
      'image': 'assets/images/logo.jpg',
      'audioAsset': 'assets/audio/first_article.mp3',
      'duration': 115,
    },
    {
      'title': 'Банк с привидениями и другие легенды',
      'url': 'https://museum.cbr.ru/articles/bank-s-privideniyami-i-drugie-legendy/',
      'text': 'second',
      'image': 'assets/images/logo.jpg',
      'audioAsset': 'assets/audio/second_article.mp3',
      'duration': 113,
    },
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _openPodcastPanel(int index) {
    final article = articleCards[index];
    final audioAsset = article['audioAsset'] ?? '';

    _player.setAsset(audioAsset).then((_) => _player.play());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PodcastPanel(
        articles: articleCards,
        initialIndex: index,
        player: _player,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  color: settings.backgroundColor,
                  child: TabBar(
                    labelColor: settings.textColor,
                    unselectedLabelColor: settings.textColor.withOpacity(0.6),
                    tabs: const [
                      Tab(text: 'Архитектура'),
                      Tab(text: 'Персонажи'),
                      Tab(text: 'Статьи'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PageView.builder(
                      controller: PageController(viewportFraction: 0.7),
                      itemCount: architectureCards.length,
                      itemBuilder: (context, index) {
                        final card = architectureCards[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: AspectRatio(
                                aspectRatio: 3.5 / 5,
                                child: FlipCard(
                                  direction: FlipDirection.HORIZONTAL,
                                  front: _buildCardFront(card['image']!),
                                  back: _buildCardBackCentered(card['description']!, settings),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: characterCards.length,
                      itemBuilder: (context, index) {
                        final char = characterCards[index];
                        return FlipCard(
                          direction: FlipDirection.HORIZONTAL,
                          front: _buildCharacterFront(char['image']!, char['name']!),
                          back: _buildCardBackCentered(char['description']!, settings),
                        );
                      },
                    ),

                    ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: articleCards.length,
                      itemBuilder: (context, index) {
                        final article = articleCards[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArticleWebScreen(
                                    title: article['title']!,
                                    url: article['url']!,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(article['title']!),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                iconSize: 40,
                                onPressed: () => _openPodcastPanel(index),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterFront(String imagePath, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            width: double.infinity,
            height: 180,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCardBackCentered(String description, AppSettings settings) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD2B48C), width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16 * settings.textScale),
          ),
        ),
      ),
    );
  }
}