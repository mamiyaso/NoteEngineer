import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class AreaCalculatorScreen extends StatelessWidget {
  const AreaCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'areaConverter.title'.tr(),
      initialInputUnit: 'm2',
      initialOutputUnit: 'cm2',
      unitPickerItems: [
        {'name': 'areaConverter.squareKilometer'.tr(), 'value': 'km2'},
        {'name': 'areaConverter.squareMeter'.tr(), 'value': 'm2'},
        {'name': 'areaConverter.squareDecimeter'.tr(), 'value': 'dm2'},
        {'name': 'areaConverter.squareCentimeter'.tr(), 'value': 'cm2'},
        {'name': 'areaConverter.squareMillimeter'.tr(), 'value': 'mm2'},
        {'name': 'areaConverter.squareMicrometer'.tr(), 'value': 'µm2'},
        {'name': 'areaConverter.squareMile'.tr(), 'value': 'mi2'},
        {'name': 'areaConverter.squareYard'.tr(), 'value': 'yd2'},
        {'name': 'areaConverter.squareFoot'.tr(), 'value': 'ft2'},
        {'name': 'areaConverter.squareInch'.tr(), 'value': 'in2'},
      ],
      converter: UnitConverter.convertArea,
    );
  }
}