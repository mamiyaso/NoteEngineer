import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class VolumeCalculatorScreen extends StatelessWidget {
  const VolumeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'volumeConverter.title'.tr(),
      initialInputUnit: 'L',
      initialOutputUnit: 'mL',
      unitPickerItems: [
        {'name': 'volumeConverter.cubicKilometer'.tr(), 'value': 'km³'},
        {'name': 'volumeConverter.cubicMeter'.tr(), 'value': 'm³'},
        {'name': 'volumeConverter.cubicDecimeter'.tr(), 'value': 'dm³'},
        {'name': 'volumeConverter.cubicCentimeter'.tr(), 'value': 'cm³'},
        {'name': 'volumeConverter.cubicMillimeter'.tr(), 'value': 'mm³'},
        {'name': 'volumeConverter.hectoliters'.tr(), 'value': 'hl'},
        {'name': 'volumeConverter.liter'.tr(), 'value': 'L'},
        {'name': 'volumeConverter.deciliter'.tr(), 'value': 'dL'},
        {'name': 'volumeConverter.centiliter'.tr(), 'value': 'cL'},
        {'name': 'volumeConverter.milliliter'.tr(), 'value': 'mL'},
        {'name': 'volumeConverter.cubicFoot'.tr(), 'value': 'ft³'},
        {'name': 'volumeConverter.cubicInch'.tr(), 'value': 'in³'},
        {'name': 'volumeConverter.cubicYard'.tr(), 'value': 'yd³'},
        {'name': 'volumeConverter.acreFoot'.tr(), 'value': 'acre-ft'},
      ],
      converter: UnitConverter.convertVolume,
    );
  }
}