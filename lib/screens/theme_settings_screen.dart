import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: const Text('Tema Ayarları'),
        backgroundColor: themeProvider.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tema Modu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.textColor,
              ),
            ),
            RadioListTile<ThemeMode>(
              title: Text(
                'Açık Tema',
                style: TextStyle(color: themeProvider.textColor),
              ),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                // Açık tema seçildiğinde varsayılan renkleri ayarla
                themeProvider.setBackgroundColor(Colors.white);
                themeProvider.setTextColor(Colors.black);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(
                'Koyu Tema',
                style: TextStyle(color: themeProvider.textColor),
              ),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                themeProvider.setBackgroundColor(Colors.black);
                themeProvider.setTextColor(Colors.white);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(
                'Kendi Temanı Oluştur',
                style: TextStyle(color: themeProvider.textColor),
              ),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
              },
            ),
            const SizedBox(height: 20),

            Text(
              'Vurgu Rengi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.textColor,
              ),
            ),
            _buildColorPicker(themeProvider, themeProvider.accentColor, 'Vurgu Rengi Seç', themeProvider.setAccentColor),

            if (themeProvider.themeMode == ThemeMode.system) ...[
              const SizedBox(height: 20),
              Text(
                'Arkaplan Rengi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor,
                ),
              ),
              _buildColorPicker(themeProvider, themeProvider.backgroundColor, 'Arkaplan Rengi Seç', themeProvider.setBackgroundColor),
              const SizedBox(height: 20),
              Text(
                'Metin Rengi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor,
                ),
              ),
              _buildColorPicker(themeProvider, themeProvider.textColor, 'Metin Rengi Seç', themeProvider.setTextColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(ThemeProvider themeProvider, Color currentColor, String title, Function(Color) onColorChanged) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: themeProvider.textColor),
      ),
      trailing: CircleAvatar(
        backgroundColor: currentColor,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: themeProvider.textColor),
            ),
            content: SingleChildScrollView(
              child: MaterialPicker(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                enableLabel: true,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Seç'),
              ),
            ],
          ),
        );
      },
    );
  }
}
