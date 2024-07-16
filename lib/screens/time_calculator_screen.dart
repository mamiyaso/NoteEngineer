import 'package:flutter/material.dart';
import 'package:note_engineer/components/converter_screen.dart';
import 'package:note_engineer/components/unit_converter.dart';
import 'package:easy_localization/easy_localization.dart';

class TimeCalculatorScreen extends StatelessWidget {
  const TimeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConverterScreen(
      title: 'timeConverter.title'.tr(),
      initialInputUnit: 's',
      initialOutputUnit: 'min',
      unitPickerItems: [
        {'name': 'timeConverter.year'.tr(), 'value': 'y'},
        {'name': 'timeConverter.week'.tr(), 'value': 'wk'},
        {'name': 'timeConverter.day'.tr(), 'value': 'd'},
        {'name': 'timeConverter.hour'.tr(), 'value': 'h'},
        {'name': 'timeConverter.minute'.tr(), 'value': 'min'},
        {'name': 'timeConverter.second'.tr(), 'value': 's'},
        {'name': 'timeConverter.millisecond'.tr(), 'value': 'ms'},
        {'name': 'timeConverter.microsecond'.tr(), 'value': 'μs'},
      ],
      converter: UnitConverter.convertTime,
    );
  }
}