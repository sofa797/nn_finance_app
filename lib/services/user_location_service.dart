import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class UserLocationService extends ChangeNotifier {
  Point? currentPoint;

  Point? lastCameraPoint;
  double? lastZoom;

  final StreamController<Point> _controller =
      StreamController<Point>.broadcast();

  Stream<Point> get locationStream => _controller.stream;

  Timer? _timer;

  Future<void> startTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('Разрешения на геолокацию не даны');
        return;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Службы геолокации отключены');
      return;
    }

    _updatePosition();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _updatePosition(),
    );
  }

  Future<void> _updatePosition() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPoint =
          Point(latitude: pos.latitude, longitude: pos.longitude);

      _controller.add(currentPoint!);
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка получения геолокации: $e');
    }
  }

  void saveCameraState(Point point, double zoom) {
    lastCameraPoint = point;
    lastZoom = zoom;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
    super.dispose();
  }
}