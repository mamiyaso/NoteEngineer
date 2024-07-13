import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class TemperatureCalculatorScreen extends StatelessWidget {
  const TemperatureCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Sıcaklık Dönüştürücü',
      initialInputUnit: 'C',
      initialOutputUnit: 'F',
      unitPickerItems: [
        {'name': 'Celsius', 'value': 'C'},
        {'name': 'Fahrenheit', 'value': 'F'},
        {'name': 'Kelvin', 'value': 'K'},
      ],
      converter: UnitConverter.convertTemperature,
    );
  }
}