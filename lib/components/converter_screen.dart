import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'keypad.dart';
import 'package:provider/provider.dart';

class ConverterScreen extends StatefulWidget {
  final String title;
  final String initialInputUnit;
  final String initialOutputUnit;
  final List<Map<String, String>> unitPickerItems;
  final dynamic converter;
  final String initialWeightUnit;
  final bool showGoButton;

  const ConverterScreen({
    super.key,
    required this.title,
    required this.initialInputUnit,
    required this.initialOutputUnit,
    required this.unitPickerItems,
    required this.converter,
    this.initialWeightUnit = '',
    this.showGoButton = false,
  });

  @override
  ConverterScreenState createState() => ConverterScreenState();
}

class ConverterScreenState extends State<ConverterScreen> {
  final _inputController = TextEditingController();
  final _outputController = TextEditingController();
  String _inputUnit = '';
  String _outputUnit = '';
  bool _isInputActive = true;
  bool _hasUserInput = false;
  String lastInputSource = "input";

  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _outputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _inputUnit = widget.initialInputUnit;
    _outputUnit = widget.initialOutputUnit;
    _inputController.addListener(_updateConversion);
    _outputController.addListener(_updateConversion);
    _inputFocusNode.addListener(_onFocusChange);
    _outputFocusNode.addListener(_onFocusChange);
    _inputController.text = '0';
    _updateConversion();
  }

  @override
  void dispose() {
    _inputController.removeListener(_updateConversion);
    _outputController.removeListener(_updateConversion);
    _inputController.dispose();
    _outputController.dispose();

    _inputFocusNode.removeListener(_onFocusChange);
    _inputFocusNode.dispose();
    _outputFocusNode.removeListener(_onFocusChange);
    _outputFocusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isInputActive = _inputFocusNode.hasFocus;
      _hasUserInput = false;
    });
  }

  void _updateConversion() {
    setState(() {
      if (_isInputActive) {
        _convertFromInput();
      } else {
        _convertFromOutput();
      }
    });
  }

  void _convertFromInput() {
    if (widget.converter is String Function(String, String, String)) {
      final input = _inputController.text.isEmpty ? '0' : _inputController.text;
      final converted = (widget.converter as String Function(String, String, String))(input, _inputUnit, _outputUnit);
      _outputController.value = TextEditingValue(text: converted);
    } else {
      final input = double.tryParse(_inputController.text) ?? 0.0;
      final converted = (widget.converter as double Function(double, String, String))(input, _inputUnit, _outputUnit);
      _outputController.value = TextEditingValue(
        text: converted.toStringAsFixed(
            converted.truncateToDouble() == converted ? 0 : 2),
      );
    }
  }

  void _convertFromOutput() {
    if (widget.converter is String Function(String, String, String)) {
      final output = _outputController.text;
      final converted = (widget.converter as String Function(String, String, String))(output, _outputUnit, _inputUnit);
      _inputController.value = TextEditingValue(text: converted);
    } else {
      final output = double.tryParse(_outputController.text) ?? 0.0;
      final converted = (widget.converter as double Function(double, String, String))(output, _outputUnit, _inputUnit);
      _inputController.value = TextEditingValue(
        text: converted.toStringAsFixed(
            converted.truncateToDouble() == converted ? 0 : 2),
      );
    }
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (_isInputActive) {
        if (lastInputSource == "output" && !_hasUserInput) {
          _inputController.clear();
        }
        _inputController.text += value;
        lastInputSource = "input";
      } else {
        if (lastInputSource == "input" && !_hasUserInput) {
          _outputController.clear();
        }
        _outputController.text += value;
        lastInputSource = "output";
      }
      _hasUserInput = true;
    });
    _updateConversion();
  }

  void _onDeletePressed(BuildContext context) {
    setState(() {
      if (_isInputActive) {
        if (_inputController.text.isNotEmpty) {
          _inputController.text = _inputController.text.substring(
              0, _inputController.text.length - 1);
        }
      } else {
        if (_outputController.text.isNotEmpty) {
          _outputController.text = _outputController.text.substring(
              0, _outputController.text.length - 1);
        }
      }
      if (_inputController.text.isEmpty && _outputController.text.isEmpty) {
        _hasUserInput = false;
      }
    });
    _updateConversion();
  }


  void _showUnitPicker(bool isInput) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return Container(
              color: themeProvider.backgroundColor, // Use theme background color
              child: ListView(
                controller: scrollController,
                children: <Widget>[
                  ListTile(
                    title: Text(
                        widget.title == 'VKE Hesaplayıcı'
                            ? 'Birim Seçin'
                            : 'Sistem Seçin',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: themeProvider.textColor)), // Use theme text color
                  ),
                  ...widget.unitPickerItems.map((Map<String, String> unit) {
                    return ListTile(
                      title: Text(unit['name']!,
                          style: TextStyle(color: themeProvider.textColor)), // Use theme text color
                      onTap: () {
                        setState(() {
                          if (isInput) {
                            _inputUnit = unit['value']!;
                          } else {
                            _outputUnit = unit['value']!;
                          }
                          _updateConversion();
                        });
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (widget.title == 'Sayı Sistemi Dönüştürücü') {
      return Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        appBar: AppBar(
          title: Text('Sayı Sistemi Dönüştürücü', style: TextStyle(color: themeProvider.textColor)),
          backgroundColor: themeProvider.accentColor, // Use theme accent color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Row
              Row(
                children: [
                  _buildButton(_inputUnit,
                      onPressed: () => _showUnitPicker(true), flex: 0.5),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _inputFocusNode,
                      controller: _inputController,
                      style: TextStyle(fontSize: 24, color: themeProvider.textColor), // Use theme text color
                      textAlign: TextAlign.right,
                      enableInteractiveSelection:  Platform.isWindows,
                      showCursor: false,
                      readOnly: Platform.isWindows ? false : true,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Output Row
              Row(
                children: [
                  _buildButton(_outputUnit,
                      onPressed: () => _showUnitPicker(false), flex: 0.5),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      focusNode: _outputFocusNode,
                      controller: _outputController,
                      style: TextStyle(fontSize: 24, color: themeProvider.textColor), // Use theme text color
                      textAlign: TextAlign.right,
                      enableInteractiveSelection:  Platform.isWindows,
                      showCursor: false,
                      readOnly: Platform.isWindows ? false : true,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                  child: HexKeyPad(
                    onKeyPressed: _onKeyPressed,
                    onDeletePressed: _onDeletePressed,
                    unit: _isInputActive ? _inputUnit : _outputUnit,
                  )
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: themeProvider.textColor)), // Use theme text color
          backgroundColor: themeProvider.accentColor, // Use theme accent color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Row
              Row(
                children: [
                  _buildButton(_inputUnit,
                      onPressed: () => _showUnitPicker(true), flex: 0.5),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _inputFocusNode,
                      controller: _inputController,
                      style: TextStyle(fontSize: 24, color: themeProvider.textColor), // Use theme text color
                      textAlign: TextAlign.right,
                      enableInteractiveSelection:  Platform.isWindows,
                      showCursor: false,
                      readOnly: Platform.isWindows ? false : true,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Output Row
              Row(
                children: [
                  _buildButton(_outputUnit,
                      onPressed: () => _showUnitPicker(false), flex: 0.5),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      focusNode: _outputFocusNode,
                      controller: _outputController,
                      style: TextStyle(fontSize: 24, color: themeProvider.textColor), // Use theme text color
                      textAlign: TextAlign.right,
                      enableInteractiveSelection:  Platform.isWindows,
                      showCursor: false,
                      readOnly: Platform.isWindows ? false : true,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: KeyPad(
                    onKeyPressed: _onKeyPressed,
                    onDeletePressed: _onDeletePressed,
                    inputUnit: _inputUnit,
                  )),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildButton(String text, {Function()? onPressed, double flex = 1}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: themeProvider.textColor, // Use theme text color
            backgroundColor: themeProvider.backgroundColor, // Use theme background color
            padding: const EdgeInsets.symmetric(vertical: 24),
          ),
          onPressed: onPressed,
          child: Text(text,
              style: TextStyle(fontSize: 24, color: themeProvider.accentColor)), // Use theme accent color
        ),
      ),
    );
  }
}