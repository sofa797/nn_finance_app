import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Тёмная тема'),
              value: settings.darkTheme,
              onChanged: settings.toggleTheme,
            ),

            SwitchListTile(
              title: const Text('Звук'),
              value: settings.soundEnabled,
              onChanged: settings.toggleSound,
            ),

            const SizedBox(height: 24),
            const Text(
              'Размер текста',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0.8,
              max: 1.5,
              divisions: 7,
              value: settings.textScale,
              label: '${(settings.textScale * 100).round()}%',
              onChanged: settings.setTextScale,
            ),
          ],
        ),
      ),
    );
  }
}