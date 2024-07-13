import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class TimeCalculatorScreen extends StatelessWidget {
  const TimeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Zaman Dönüştürücü',
      initialInputUnit: 'sn',
      initialOutputUnit: 'min',
      unitPickerItems: [
        {'name': 'Yıl', 'value': 'y'},
        {'name': 'Hafta', 'value': 'wk'},
        {'name': 'Gün', 'value': 'g'},
        {'name': 'Saat', 'value': 'h'},
        {'name': 'Dakika', 'value': 'min'},
        {'name': 'Saniye', 'value': 'sn'},
        {'name': 'Milisaniye', 'value': 'ms'},
        {'name': 'Mikrosaniye', 'value': 'μs'},
      ],
      converter: UnitConverter.convertTime,
    );
  }
}