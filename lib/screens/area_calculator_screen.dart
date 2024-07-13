import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class AreaCalculatorScreen extends StatelessWidget {
  const AreaCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Alan Dönüştürücü',
      initialInputUnit: 'm²',
      initialOutputUnit: 'cm²',
      unitPickerItems: [
        {'name': 'Kilometre Kare', 'value': 'km²'},
        {'name': 'Metre Kare', 'value': 'm²'},
        {'name': 'Desimetre Kare', 'value': 'dm²'},
        {'name': 'Santimetre Kare', 'value': 'cm²'},
        {'name': 'Milimetre Kare', 'value': 'mm²'},
        {'name': 'Mikrometre Kare', 'value': 'μm²'},
        {'name': 'Mil Kare', 'value': 'mi²'},
        {'name': 'Yard Kare', 'value': 'yd²'},
        {'name': 'Adım Kare', 'value': 'ft²'},
        {'name': 'İnç Kare', 'value': 'in²'},
      ],
      converter: UnitConverter.convertArea,
    );
  }
}