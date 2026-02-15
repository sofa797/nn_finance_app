import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../settings/story_progress.dart';
import '../models/story_location.dart';
import '../services/user_location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _controllerCompleter = Completer();
  bool _isCameraMoved = false;

  final List<StoryLocation> locations = const [
    StoryLocation(title: 'Нижегородская ярмарка', lat: 56.328446, lon: 43.961168, storyIndex: 0),
    StoryLocation(title: 'Спасский собор', lat: 56.331492, lon: 43.953914, storyIndex: 1),
    StoryLocation(title: 'Пакгаузы', lat: 56.33512, lon: 43.97456, storyIndex: 2),
    StoryLocation(title: 'Биржа', lat: 56.3292, lon: 43.9981, storyIndex: 3),
    StoryLocation(title: 'Блиновский пассаж', lat: 56.328333, lon: 43.988333, storyIndex: 4),
    StoryLocation(title: 'Волжско-Камский банк', lat: 56.329444, lon: 43.991944, storyIndex: 5),
    StoryLocation(title: 'Соляная афера', lat: 56.328965, lon: 43.993072, storyIndex: 6),
    StoryLocation(title: 'Ночлежка Бугрова', lat: 56.32948, lon: 43.99743, storyIndex: 7),
    StoryLocation(title: 'Усадьба Руковишникова', lat: 56.329167, lon: 44.016111, storyIndex: 8),
  ];

  @override
  void initState() {
    super.initState();
    context.read<UserLocationService>().startTracking();
  }

  @override
  Widget build(BuildContext context) {
    final locationService = context.watch<UserLocationService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Карта маршрута',
    style: TextStyle(fontSize: 24))),
      body: YandexMap(
        onMapCreated: (controller) async {
          if (!_controllerCompleter.isCompleted) {
            _controllerCompleter.complete(controller);
          }

          if (!_isCameraMoved && locationService.currentPoint != null) {
            _isCameraMoved = true;

            await controller.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: locationService.currentPoint!,
                  zoom: 15,
                ),
              ),
              animation: const MapAnimation(
                type: MapAnimationType.smooth,
                duration: 1.5,
              ),
            );
          }
        },
        mapObjects: [
          ...locations.map(
            (loc) => PlacemarkMapObject(
              mapId: MapObjectId('story_${loc.storyIndex}'),
              point: Point(latitude: loc.lat, longitude: loc.lon),
              opacity: 0.8,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/map_marker.png'),
                  scale: 0.3,
                ),
              ),
              onTap: (mapObject, point) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(loc.title),
                    content: const Text(
                        'Эта точка связана с текущей главой истории.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Закрыть'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (locationService.currentPoint != null)
            PlacemarkMapObject(
              mapId: const MapObjectId('user_position'),
              point: locationService.currentPoint!,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/map_user.png'),
                  scale: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}