import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class MassCalculatorScreen extends StatelessWidget {
  const MassCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'massConverter.title'.tr(),
      initialInputUnit: 'g',
      initialOutputUnit: 'kg',
      unitPickerItems: [
        {'name': 'massConverter.micrograms'.tr(), 'value': 'μg'},
        {'name': 'massConverter.milligram'.tr(), 'value': 'mg'},
        {'name': 'massConverter.gram'.tr(), 'value': 'g'},
        {'name': 'massConverter.kilogram'.tr(), 'value': 'kg'},
        {'name': 'massConverter.tonne'.tr(), 'value': 'ton'},
        {'name': 'massConverter.pound'.tr(), 'value': 'lb'},
        {'name': 'massConverter.ounce'.tr(), 'value': 'oz'},
      ],
      converter: UnitConverter.convertMass,
    );
  }
}