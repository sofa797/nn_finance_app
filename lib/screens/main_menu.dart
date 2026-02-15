import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/app_settings.dart';
import 'settings_screen.dart';
import 'accessibility_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final GlobalKey _visibilityKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _cardsKey = GlobalKey();

  final List<Map<String, String>> cards = const [
    { 'image': 'assets/images/logo.jpg', 'description': 'Предлагаем Вам поближе познакомиться с финансовой архитектурой Нижнего Новгорода. Листайте карточки и узнайте, почему город называли «карманом России» — центром торговли и капитала XIX века.', },
    { 'image': 'assets/images/fair_cards.png', 'description': 'Нижегородская ярмарка — крупнейший торговый центр России XIX века. После переноса из Макарьева в 1817 году она стала главным местом встречи купцов Европы и Азии. Здесь заключались многомиллионные сделки, формировались цены на зерно, чай и ткани. Ярмарка сыграла ключевую роль в развитии банковского дела, торговли и превращении Нижнего Новгорода в финансовую столицу страны.', },
    { 'image': 'assets/images/old_fair_spassky_cathedral.jpg', 'description': 'Староярмарочный Спасский собор построен в 1822 году как главный храм Нижегородской ярмарки. Он стал духовным центром крупнейшего торгового пространства России, объединяя купцов со всей страны. Собор символизировал связь торговли, веры и деловой этики, подчёркивая значение ярмарки не только как экономического, но и культурного центра города.', },
    { 'image': 'assets/images/warehouse.png', 'description': 'Пакгауз — складское здание ярмарки XIX века, где купцы хранили товары для продажи и транспортировки. Он обеспечивал надёжное хранение зерна, тканей и других ценных грузов, упрощал логистику и ускорял торговлю. Пакгауз символизировал организованность и профессионализм купеческого сообщества Нижнего Новгорода.', },
    { 'image': 'assets/images/nizny_novgorod_stock_exchange.jpg', 'description': 'Нижегородская биржа, построенная в 1896 году, была центром торговли ценными бумагами, зерном и промтоварами. Здесь купцы и банкиры заключали сделки, формировали курсы и кредиты. Биржа символизировала финансовую зрелость города и способствовала превращению Нижнего Новгорода в «карман России».', },
    { 'image': 'assets/images/salt_exchange.png', 'description': 'Соляная биржа, образованная в середине XIX века, служила местом оборота и контроля поставок соли — важнейшего товара для России. Здесь регулировались цены, заключались оптовые сделки и хранились сведения о поставках. Биржа подчёркивала стратегическую роль Нижнего Новгорода в снабжении страны ключевыми товарами и поддержке торговли.', },
    { 'image': 'assets/images/blinovsky_passage.png', 'description': 'Блиновский пассаж, построенный в 1910-х годах, был коммерческим зданием с магазинами и офисами для купцов. Здесь сосредоточились торговля, банки и склады, обеспечивая комфорт и безопасность бизнеса. Пассаж стал символом модернизации городской торговли.', },
    ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenTutorial') ?? false;

    if (!seen) {
      _showTutorial();
      await prefs.setBool('seenTutorial', true);
    }
  }

  void _showTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "visibility",
          keyTarget: _visibilityKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Text(
                "Здесь можно включить режим для слабовидящих",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "settings",
          keyTarget: _settingsKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Text(
                "Здесь находятся общие настройки приложения",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "cards",
          keyTarget: _cardsKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Листайте карточки и нажимайте на них, чтобы узнать больше",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black,
      textSkip: "Пропустить",
      paddingFocus: 10,
      opacityShadow: 0.8,
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      appBar: AppBar(
        title: const Text('Главное меню'),
        actions: [
          IconButton(
            key: _visibilityKey,
            icon: const Icon(Icons.visibility),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AccessibilityScreen()),
              );
            },
          ),
          IconButton(
            key: _settingsKey,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: const Text(
                'Исследуйте финансовую архитектуру Нижнего Новгорода',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              key: _cardsKey,
              height: 350,
              child: PageView.builder(
                itemCount: cards.length,
                controller: PageController(viewportFraction: 0.8),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildCardFront(card['image']!),
                      back: _buildCardBack(
                          card['description']!, settings),
                    ),
                  );
                },
              ),
            ),
          ],
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
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(String description, AppSettings settings) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD2B48C), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 18 * settings.textScale,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}