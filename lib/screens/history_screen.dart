import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> history;
  final Function(String) onSelect;

  const HistoryScreen({super.key, required this.history, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.accentColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Geçmiş',
                style: TextStyle(fontSize: 24, color: themeProvider.textColor),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: themeProvider.textColor),
              onPressed: () {
                history.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              history[index],
              style: TextStyle(color: themeProvider.textColor),
            ),
            onTap: () => onSelect(history[index]),
          );
        },
      ),
    );
  }
}