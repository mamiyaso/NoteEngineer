import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';

class VolumeCalculatorScreen extends StatelessWidget {
  const VolumeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConverterScreen(
      title: 'Hacim Dönüştürücü',
      initialInputUnit: 'L',
      initialOutputUnit: 'mL',
      unitPickerItems: [
        {'name': 'Kilometreküp', 'value': 'km³'},
        {'name': 'Metreküp', 'value': 'm³'},
        {'name': 'Desimetreküp', 'value': 'dm³'},
        {'name': 'Santimetreküp', 'value': 'cm³'},
        {'name': 'Milimetreküp', 'value': 'mm³'},
        {'name': 'Hektolitre', 'value': 'hl'},
        {'name': 'Litre', 'value': 'L'},
        {'name': 'Desilitre', 'value': 'dL'},
        {'name': 'Santilitre', 'value': 'cL'},
        {'name': 'Mililitre', 'value': 'mL'},
        {'name': 'Adımküp', 'value': 'ft³'},
        {'name': 'İnçküp', 'value': 'in³'},
        {'name': 'Yardküp', 'value': 'yd³'},
        {'name': 'Dönüm-Adım', 'value': 'acre-ft'},
      ],
      converter: UnitConverter.convertVolume,
    );
  }
}