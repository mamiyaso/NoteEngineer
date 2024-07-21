import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

class KeyPad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final Function(BuildContext) onDeletePressed;
  final String inputUnit;

  const KeyPad({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
    required this.inputUnit,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildButton('7',
                  onPressed: () => onKeyPressed('7'),
                  themeProvider: themeProvider),
              _buildButton('8',
                  onPressed: () => onKeyPressed('8'),
                  themeProvider: themeProvider),
              _buildButton('9',
                  onPressed: () => onKeyPressed('9'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('4',
                  onPressed: () => onKeyPressed('4'),
                  themeProvider: themeProvider),
              _buildButton('5',
                  onPressed: () => onKeyPressed('5'),
                  themeProvider: themeProvider),
              _buildButton('6',
                  onPressed: () => onKeyPressed('6'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('1',
                  onPressed: () => onKeyPressed('1'),
                  themeProvider: themeProvider),
              _buildButton('2',
                  onPressed: () => onKeyPressed('2'),
                  themeProvider: themeProvider),
              _buildButton('3',
                  onPressed: () => onKeyPressed('3'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('.',
                  onPressed: () => onKeyPressed('.'),
                  alwaysEnabled: true,
                  themeProvider: themeProvider),
              _buildButton('0',
                  onPressed: () => onKeyPressed('0'),
                  themeProvider: themeProvider),
              // Delete Button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeProvider.textColor,
                      backgroundColor: themeProvider.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                    ),
                    onPressed: () => onDeletePressed(context),
                    child: Icon(Icons.backspace_outlined,
                        color: themeProvider.accentColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text,
      {required Function() onPressed,
      required ThemeProvider themeProvider,
      double flex = 1,
      bool alwaysEnabled = false}) {
    bool isEnabled = alwaysEnabled ||
        (int.tryParse(text) != null &&
            int.parse(text) <
                int.parse(
                    inputUnit == '2' || inputUnit == '8' || inputUnit == '10'
                        ? inputUnit
                        : '10'));

    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: themeProvider.textColor,
            backgroundColor: themeProvider.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 24),
          ),
          onPressed: isEnabled ? onPressed : null,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: isEnabled ? themeProvider.accentColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class HexKeyPad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final Function(BuildContext) onDeletePressed;
  final String unit;

  const HexKeyPad({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildButton('D',
                  onPressed: () => onKeyPressed('D'),
                  themeProvider: themeProvider),
              _buildButton('E',
                  onPressed: () => onKeyPressed('E'),
                  themeProvider: themeProvider),
              _buildButton('F',
                  onPressed: () => onKeyPressed('F'),
                  themeProvider: themeProvider),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeProvider.textColor,
                      backgroundColor: themeProvider.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                    ),
                    onPressed: () => onDeletePressed(context),
                    child: Icon(Icons.backspace_outlined,
                        color: themeProvider.accentColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('9',
                  onPressed: () => onKeyPressed('9'),
                  themeProvider: themeProvider),
              _buildButton('A',
                  onPressed: () => onKeyPressed('A'),
                  themeProvider: themeProvider),
              _buildButton('B',
                  onPressed: () => onKeyPressed('B'),
                  themeProvider: themeProvider),
              _buildButton('C',
                  onPressed: () => onKeyPressed('C'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('5',
                  onPressed: () => onKeyPressed('5'),
                  themeProvider: themeProvider),
              _buildButton('6',
                  onPressed: () => onKeyPressed('6'),
                  themeProvider: themeProvider),
              _buildButton('7',
                  onPressed: () => onKeyPressed('7'),
                  themeProvider: themeProvider),
              _buildButton('8',
                  onPressed: () => onKeyPressed('8'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('1',
                  onPressed: () => onKeyPressed('1'),
                  themeProvider: themeProvider),
              _buildButton('2',
                  onPressed: () => onKeyPressed('2'),
                  themeProvider: themeProvider),
              _buildButton('3',
                  onPressed: () => onKeyPressed('3'),
                  themeProvider: themeProvider),
              _buildButton('4',
                  onPressed: () => onKeyPressed('4'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildEmptyButton(themeProvider),
              _buildButton('0',
                  onPressed: () => onKeyPressed('0'),
                  themeProvider: themeProvider),
              _buildButton('.',
                  onPressed: () => onKeyPressed('.'),
                  alwaysEnabled: true,
                  themeProvider: themeProvider),
              _buildEmptyButton(themeProvider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text,
      {required Function() onPressed,
      required ThemeProvider themeProvider,
      double flex = 1,
      bool alwaysEnabled = false}) {
    bool isEnabled = alwaysEnabled ||
        (unit == '16' ||
            (unit == '10' && int.tryParse(text) != null) ||
            (unit == '8' &&
                int.tryParse(text) != null &&
                int.parse(text) < 8) ||
            (unit == '2' && int.tryParse(text) != null && int.parse(text) < 2));
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: themeProvider.textColor,
            backgroundColor: themeProvider.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 24),
          ),
          onPressed: isEnabled ? onPressed : null,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: isEnabled ? themeProvider.accentColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyButton(ThemeProvider themeProvider) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          color: themeProvider.backgroundColor,
        ),
      ),
    );
  }
}
