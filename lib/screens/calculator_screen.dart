import 'package:flutter/material.dart';
import 'package:note_engineer/screens/age_calculator_screen.dart';
import 'package:note_engineer/screens/area_calculator_screen.dart';
import 'package:note_engineer/screens/basic_calculator_screen.dart';
import 'package:note_engineer/screens/date_difference_calculator_screen.dart';
import 'package:note_engineer/screens/length_calculator_screen.dart';
import 'package:note_engineer/screens/numeral_system_calculator_screen.dart';
import 'package:note_engineer/screens/temperature_calculator_screen.dart';
import 'package:note_engineer/screens/time_calculator_screen.dart';
import 'package:note_engineer/screens/mass_calculator_screen.dart';
import 'package:note_engineer/screens/volume_calculator.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('calculatorScreen.title'.tr(),
            style: TextStyle(color: themeProvider.textColor)
        ),
        backgroundColor: themeProvider.accentColor,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('calculatorScreen.ageCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AgeCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.dateDifferenceCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const DateDifferenceCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.timeCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TimeCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.lengthCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LengthCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.massCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MassCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.temperatureCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const TemperatureCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.volumeCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VolumeCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.numeralSystemCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const NumeralSystemCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.areaCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AreaCalculatorScreen()
                ),
              );
            },
          ),
          ListTile(
            title: Text('calculatorScreen.basicCalculator'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BasicCalculatorScreen()
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}