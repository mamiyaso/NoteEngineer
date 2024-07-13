import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class MassCalculatorScreen extends StatelessWidget {
  const MassCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Kütle Dönüştürücü',
      initialInputUnit: 'g',
      initialOutputUnit: 'kg',
      unitPickerItems: [
        {'name': 'Mikrogram', 'value': 'μg'},
        {'name': 'Miligram', 'value': 'mg'},
        {'name': 'Gram', 'value': 'g'},
        {'name': 'Kilogram', 'value': 'kg'},
        {'name': 'Ton', 'value': 'ton'},
        {'name': 'Pound', 'value': 'lb'},
        {'name': 'Ons', 'value': 'oz'},
      ],
      converter: UnitConverter.convertMass,
    );
  }
}