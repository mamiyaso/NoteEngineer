import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:note_engineer/screens/history_screen.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

class BasicCalculatorScreen extends StatefulWidget {
  const BasicCalculatorScreen({super.key});

  @override
  BasicCalculatorScreenState createState() => BasicCalculatorScreenState();
}

class BasicCalculatorScreenState extends State<BasicCalculatorScreen> {
  final List<String> _history = [];
  String _expression = '';
  String _display = '';
  bool _isOperatorLast = false;

  bool _lastNumberContainsDecimal() {
    List<String> parts = _expression.split(RegExp(r'[+\-x÷%]'));
    return parts.isNotEmpty && parts.last.contains('.');
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final logicalKey = event.logicalKey;
      String? value;

      if (logicalKey == LogicalKeyboardKey.enter) {
        value = '=';
      } else if (logicalKey == LogicalKeyboardKey.backspace) {
        value = 'sil';
      } else if (logicalKey == LogicalKeyboardKey.delete) {
        value = 'AC';
      } else if (logicalKey == LogicalKeyboardKey.numpadAdd) {
        value = '+';
      } else if (logicalKey == LogicalKeyboardKey.numpadSubtract) {
        value = '-';
      } else if (logicalKey == LogicalKeyboardKey.numpadMultiply) {
        value = 'x';
      } else if (logicalKey == LogicalKeyboardKey.numpadDivide) {
        value = '÷';
      } else if (logicalKey == LogicalKeyboardKey.period ||
          logicalKey == LogicalKeyboardKey.numpadDecimal) {
        value = '.';
      } else if (logicalKey.keyLabel.isNotEmpty && RegExp(r'^[0-9]$').hasMatch(logicalKey.keyLabel)) {
        value = logicalKey.keyLabel;
      }

      if (value != null) {
        _onKeyPressed(value);
      }
    }
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _clear();
      } else if (value == 'sil') {
        _deleteLastCharacter();
      } else if (value == '=') {
        _calculate();
        _isOperatorLast = false;
      } else if (_isOperator(value)) {
        if (_isOperatorLast) {
          _expression =
              _expression.substring(0, _expression.length - 1) + value;
        } else {
          if (_expression.endsWith('.')) {
            _expression = _expression.substring(0, _expression.length - 1);
          }
          _expression += value;
          _isOperatorLast = true;
        }
      } else if (value == '.') {
        if (!_lastNumberContainsDecimal()) {
          _expression += value;
        }
        _isOperatorLast = false;
      } else {
        _expression += value;
        _isOperatorLast = false;
      }

      _display = _expression;
    });
  }

  void _clear() {
    _expression = '';
    _display = '';
    _isOperatorLast = false;
  }

  void _deleteLastCharacter() {
    if (_expression.isNotEmpty) {
      if (_expression.endsWith('.')) {
      }
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression;
      _isOperatorLast = _isOperator(
          _expression.isEmpty ? '' : _expression[_expression.length - 1]);
    }
  }

  void _calculate() {
    try {
      if (_isOperatorLast) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      String expressionToEvaluate = _expression
          .replaceAll('x', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/ 100 *');

      Parser p = Parser();
      Expression exp = p.parse(expressionToEvaluate);
      ContextModel cm = ContextModel();
      double resultDouble = exp.evaluate(EvaluationType.REAL, cm);

      if (resultDouble == double.infinity ||
          resultDouble == double.negativeInfinity) {
        _showErrorSnackBar("basicCalculator.divideByZeroError".tr());
      } else {
        if (resultDouble == resultDouble.floor()) {
          _display = resultDouble.toInt().toString();
        } else {
          _display = resultDouble.toString();
        }

        _history.add('$_expression = $_display');
        _expression = _display;
      }
    } on FormatException catch (e) {
      _showErrorSnackBar("basicCalculator.invalidFormatError".tr(args: [e.message]));
    } on RangeError {
      _showErrorSnackBar("basicCalculator.rangeError".tr());
    } on ArgumentError catch (e) {
      _showErrorSnackBar("basicCalculator.invalidArgumentError".tr(args: [e.message]));
    } on StateError catch (e) {
      _showErrorSnackBar("basicCalculator.invalidStateError".tr(args: [e.message]));
    } catch (e) {
      _showErrorSnackBar("basicCalculator.unknownError".tr(args: [e.toString()]));
      _display = "basicCalculator.error".tr();
    }
  }

  bool _isOperator(String value) {
    return value == '+' ||
        value == '-' ||
        value == 'x' ||
        value == '÷' ||
        value == '%';
  }

  void _showErrorSnackBar(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeProvider.accentColor,
      ),
    );
  }

  Widget _buildButton(String text,
      {Function()? onPressed,
      required ThemeProvider themeProvider,
      double flex = 1}) {
    Widget buttonChild;
    if (text == 'basicCalculator.history'.tr()) {
      buttonChild =
          Icon(Icons.history, color: themeProvider.accentColor);
    } else if (text == 'sil') {
      buttonChild =
          Icon(Icons.backspace, color: themeProvider.accentColor);
    } else if (text == 'AC') {
      buttonChild =
          Icon(Icons.delete, color: themeProvider.accentColor);
    } else {
      buttonChild = Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color:
              text == '=' ? themeProvider.accentColor : themeProvider.textColor,
        ),
      );
    }

    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            foregroundColor: themeProvider.textColor,
            backgroundColor:
                themeProvider.backgroundColor,
          ),
          onPressed: onPressed,
          child: buttonChild,
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final themeProvider =
        Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildButton('basicCalculator.history'.tr(), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      history: _history,
                      onSelect: (String value) {
                        setState(() {
                          _display = value;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }, themeProvider: themeProvider),
              _buildButton('AC',
                  onPressed: () => _onKeyPressed('AC'),
                  themeProvider: themeProvider),
              _buildButton('sil',
                  onPressed: () => _onKeyPressed('sil'),
                  themeProvider: themeProvider),
              _buildButton('÷',
                  onPressed: () => _onKeyPressed('÷'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('7',
                  onPressed: () => _onKeyPressed('7'),
                  themeProvider: themeProvider),
              _buildButton('8',
                  onPressed: () => _onKeyPressed('8'),
                  themeProvider: themeProvider),
              _buildButton('9',
                  onPressed: () => _onKeyPressed('9'),
                  themeProvider: themeProvider),
              _buildButton('x',
                  onPressed: () => _onKeyPressed('x'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('4',
                  onPressed: () => _onKeyPressed('4'),
                  themeProvider: themeProvider),
              _buildButton('5',
                  onPressed: () => _onKeyPressed('5'),
                  themeProvider: themeProvider),
              _buildButton('6',
                  onPressed: () => _onKeyPressed('6'),
                  themeProvider: themeProvider),
              _buildButton('-',
                  onPressed: () => _onKeyPressed('-'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('1',
                  onPressed: () => _onKeyPressed('1'),
                  themeProvider: themeProvider),
              _buildButton('2',
                  onPressed: () => _onKeyPressed('2'),
                  themeProvider: themeProvider),
              _buildButton('3',
                  onPressed: () => _onKeyPressed('3'),
                  themeProvider: themeProvider),
              _buildButton('+',
                  onPressed: () => _onKeyPressed('+'),
                  themeProvider: themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildButton('.',
                  onPressed: () => _onKeyPressed('.'),
                  themeProvider: themeProvider),
              _buildButton('0',
                  onPressed: () => _onKeyPressed('0'),
                  themeProvider: themeProvider),
              _buildButton('=',
                  onPressed: () => _onKeyPressed('='),
                  flex: 2,
                  themeProvider: themeProvider),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context);
    return KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _onKey,
        autofocus: true,
        child: Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.accentColor,
        title: Text(
          'basicCalculator.title'.tr(),
          style: TextStyle(
              fontSize: 24,
              color: themeProvider.textColor
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  _display,
                  style: TextStyle(
                      fontSize: 48,
                      color: themeProvider.textColor
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: _buildKeypad(),
            ),
          ],
        ),
      ),
        ),
    );
  }
}