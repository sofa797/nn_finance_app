import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../settings/app_settings.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final List<Map<String, String>> architectureCards = const [
    { 'image': 'assets/images/logo.jpg', 'description': 'Предлагаем Вам поближе познакомиться с финансовой архитектурой Нижнего Новгорода. Листайте карточки и узнайте, почему город называли «карманом России» — центром торговли и капитала XIX века.', },
    { 'image': 'assets/images/fair_cards.png', 'description': 'Нижегородская ярмарка — крупнейший торговый центр России XIX века. После переноса из Макарьева в 1817 году она стала главным местом встречи купцов Европы и Азии. Здесь заключались многомиллионные сделки, формировались цены на зерно, чай и ткани. Ярмарка сыграла ключевую роль в развитии банковского дела, торговли и превращении Нижнего Новгорода в финансовую столицу страны.', },
    { 'image': 'assets/images/old_fair_spassky_cathedral.jpg', 'description': 'Староярмарочный Спасский собор построен в 1822 году как главный храм Нижегородской ярмарки. Он стал духовным центром крупнейшего торгового пространства России, объединяя купцов со всей страны. Собор символизировал связь торговли, веры и деловой этики, подчёркивая значение ярмарки не только как экономического, но и культурного центра города.', },
    { 'image': 'assets/images/warehouse.png', 'description': 'Пакгауз — складское здание ярмарки XIX века, где купцы хранили товары для продажи и транспортировки. Он обеспечивал надёжное хранение зерна, тканей и других ценных грузов, упрощал логистику и ускорял торговлю. Пакгауз символизировал организованность и профессионализм купеческого сообщества Нижнего Новгорода.', },
    { 'image': 'assets/images/nizny_novgorod_stock_exchange.jpg', 'description': 'Нижегородская биржа, построенная в 1896 году, была центром торговли ценными бумагами, зерном и промтоварами. Здесь купцы и банкиры заключали сделки, формировали курсы и кредиты. Биржа символизировала финансовую зрелость города и способствовала превращению Нижнего Новгорода в «карман России».', },
    { 'image': 'assets/images/salt_exchange.png', 'description': 'Соляная биржа, образованная в середине XIX века, служила местом оборота и контроля поставок соли — важнейшего товара для России. Здесь регулировались цены, заключались оптовые сделки и хранились сведения о поставках. Биржа подчёркивала стратегическую роль Нижнего Новгорода в снабжении страны ключевыми товарами и поддержке торговли.', },
    { 'image': 'assets/images/blinovsky_passage.png', 'description': 'Блиновский пассаж, построенный в 1910-х годах, был коммерческим зданием с магазинами и офисами для купцов. Здесь сосредоточились торговля, банки и склады, обеспечивая комфорт и безопасность бизнеса. Пассаж стал символом модернизации городской торговли.', },
    ];

  final List<Map<String, String>> characterCards = const [
    { 'image': 'assets/images/alex.png', 'name': 'Александр Бугров', 'description': 'Главный герой истории' },
    { 'image': 'assets/images/hero.png', 'name': 'Герой 2', 'description': 'Другой персонаж' },
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: settings.backgroundColor,
          foregroundColor: settings.textColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Архитектура'),
              Tab(text: 'Персонажи'),
            ],
          ),
          title: const Text('Справка'),
        ),
        body: TabBarView(
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