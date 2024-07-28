import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class TemperatureCalculatorScreen extends StatelessWidget {
  const TemperatureCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'temperatureConverter.title'.tr(),
      initialInputUnit: 'C',
      initialOutputUnit: 'F',
      unitPickerItems: [
        {'name': 'temperatureConverter.celsius'.tr(), 'value': 'C'},
        {'name': 'temperatureConverter.fahrenheit'.tr(), 'value': 'F'},
        {'name': 'temperatureConverter.kelvin'.tr(), 'value': 'K'},
      ],
      converter: UnitConverter.convertTemperature,
    );
  }
}