import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class LengthCalculatorScreen extends StatelessWidget {
  const LengthCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'lengthConverter.title'.tr(),
      initialInputUnit: 'm',
      initialOutputUnit: 'cm',
      unitPickerItems: [
        {'name': 'lengthConverter.kilometer'.tr(), 'value': 'km'},
        {'name': 'lengthConverter.meter'.tr(), 'value': 'm'},
        {'name': 'lengthConverter.decimeter'.tr(), 'value': 'dm'},
        {'name': 'lengthConverter.centimeter'.tr(), 'value': 'cm'},
        {'name': 'lengthConverter.millimeter'.tr(), 'value': 'mm'},
        {'name': 'lengthConverter.micrometer'.tr(), 'value': 'μm'},
        {'name': 'lengthConverter.mile'.tr(), 'value': 'mi'},
        {'name': 'lengthConverter.yard'.tr(), 'value': 'yd'},
        {'name': 'lengthConverter.foot'.tr(), 'value': 'ft'},
        {'name': 'lengthConverter.inch'.tr(), 'value': 'in'},
      ],
      converter: UnitConverter.convertLength,
    );
  }
}