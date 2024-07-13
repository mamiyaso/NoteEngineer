import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class LengthCalculatorScreen extends StatelessWidget {
  const LengthCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Uzunluk Dönüştürücü',
      initialInputUnit: 'm',
      initialOutputUnit: 'cm',
      unitPickerItems: [
        {'name': 'Kilometre', 'value': 'km'},
        {'name': 'Metre', 'value': 'm'},
        {'name': 'Desimetre', 'value': 'dm'},
        {'name': 'Santimetre', 'value': 'cm'},
        {'name': 'Milimetre', 'value': 'mm'},
        {'name': 'Mikrometre', 'value': 'μm'},
        {'name': 'Mil', 'value': 'mi'},
        {'name': 'Yard', 'value': 'yd'},
        {'name': 'Adım', 'value': 'ft'},
        {'name': 'İnç', 'value': 'in'},
      ],
      converter: UnitConverter.convertLength,
    );
  }
}