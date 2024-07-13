import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class NumeralSystemCalculatorScreen extends StatelessWidget {
  const NumeralSystemCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Sayı Sistemi Dönüştürücü',
      initialInputUnit: '10',
      initialOutputUnit: '2',
      unitPickerItems: [
        {'name': '2\'lik (İkili)', 'value': '2'},
        {'name': '8\'lik (Sekizlik)', 'value': '8'},
        {'name': '10\'luk (Onluk)', 'value': '10'},
        {'name': '16\'lık (Onaltılık)', 'value': '16'},
      ],
      converter: UnitConverter.convertNumeralSystem,
    );
  }
}