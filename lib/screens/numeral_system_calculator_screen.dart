import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class NumeralSystemCalculatorScreen extends StatelessWidget {
  const NumeralSystemCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'numeralSystemConverter.title'.tr(),
      initialInputUnit: '10',
      initialOutputUnit: '2',
      unitPickerItems: [
        {'name': 'numeralSystemConverter.binary'.tr(), 'value': '2'},
        {'name': 'numeralSystemConverter.octal'.tr(), 'value': '8'},
        {'name': 'numeralSystemConverter.decimal'.tr(), 'value': '10'},
        {'name': 'numeralSystemConverter.hexadecimal'.tr(), 'value': '16'},
      ],
      converter: UnitConverter.convertNumeralSystem,
    );
  }
}