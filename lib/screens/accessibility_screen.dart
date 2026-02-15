import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/app_settings.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      appBar: AppBar(
        backgroundColor: settings.backgroundColor,
        foregroundColor: settings.textColor,
        title: Text(
          'Версия для слабовидящих',
          style: TextStyle(
            color: settings.textColor,
            fontSize: 22 * settings.textScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              settings.setColorScheme(ColorSchemeOption.standard);
              settings.toggleImages(true);
            },
            child: Text(
              'Сбросить',
              style: TextStyle(
                color: settings.textColor,
                fontSize: 18 * settings.textScale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цветовая схема:',
              style: TextStyle(
                fontSize: 18 * settings.textScale,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ColorSchemeChip(
                  label: 'A',
                  scheme: ColorSchemeOption.standard,
                  selected: settings.colorScheme == ColorSchemeOption.standard,
                ),
                const SizedBox(width: 8),
                _ColorSchemeChip(
                  label: 'A',
                  scheme: ColorSchemeOption.blackWhite,
                  selected: settings.colorScheme == ColorSchemeOption.blackWhite,
                ),
                const SizedBox(width: 8),
                _ColorSchemeChip(
                  label: 'A',
                  scheme: ColorSchemeOption.dark,
                  selected: settings.colorScheme == ColorSchemeOption.dark,
                ),
                const SizedBox(width: 8),
                _ColorSchemeChip(
                  label: 'A',
                  scheme: ColorSchemeOption.beige,
                  selected: settings.colorScheme == ColorSchemeOption.beige,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Изображения:',
              style: TextStyle(
                fontSize: 18 * settings.textScale,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _ImageRadio(
              selected: settings.imagesEnabled,
              onChanged: (value) => settings.toggleImages(value),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSchemeChip extends StatelessWidget {
  final String label;
  final ColorSchemeOption scheme;
  final bool selected;

  const _ColorSchemeChip({
    required this.label,
    required this.scheme,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.read<AppSettings>();
    final beigeColor = const Color(0xFFAC876D);

    return GestureDetector(
      onTap: () => settings.setColorScheme(scheme),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: _getColor(scheme),
          border: Border.all(
            color: selected ? beigeColor : Colors.grey.shade400,
            width: selected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: _getTextColor(scheme),
              fontSize: 28 * settings.textScale,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(ColorSchemeOption scheme) {
    switch (scheme) {
      case ColorSchemeOption.standard:
      case ColorSchemeOption.blackWhite:
        return Colors.white;
      case ColorSchemeOption.dark:
        return Colors.black;
      case ColorSchemeOption.beige:
        return const Color(0xFFD8C2A0);
    }
  }

  Color _getTextColor(ColorSchemeOption scheme) {
    switch (scheme) {
      case ColorSchemeOption.standard:
      case ColorSchemeOption.blackWhite:
      case ColorSchemeOption.beige:
        return Colors.black87;
      case ColorSchemeOption.dark:
        return Colors.white;
    }
  }
}

class _ImageRadio extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _ImageRadio({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final beigeColor = const Color(0xFFAC876D);

    return Column(
      children: [
        _ImageRadioTile(
          title: 'Обычные',
          value: true,
          groupValue: selected,
          onChanged: onChanged,
          color: beigeColor,
          textColor: settings.textColor,
          textScale: settings.textScale,
        ),
        _ImageRadioTile(
          title: 'Без изображений',
          value: false,
          groupValue: selected,
          onChanged: onChanged,
          color: beigeColor,
          textColor: settings.textColor,
          textScale: settings.textScale,
        ),
      ],
    );
  }
}

class _ImageRadioTile extends StatelessWidget {
  final String title;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool> onChanged;
  final Color color;
  final Color textColor;
  final double textScale;

  const _ImageRadioTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
    required this.textColor,
    required this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : textColor.withOpacity(0.5),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18 * textScale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}