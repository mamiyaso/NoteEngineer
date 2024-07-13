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

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('Hesaplayıcı', style: TextStyle(color: themeProvider.textColor)),
        backgroundColor: themeProvider.accentColor,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Yaş Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgeCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Tarih Farkı Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DateDifferenceCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Zaman Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimeCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Uzunluk Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LengthCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Kütle Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MassCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Sıcaklık Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TemperatureCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Hacim Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VolumeCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Numeral Sistem Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NumeralSystemCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Alan Hesaplama', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AreaCalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Hesap Makinesi', style: TextStyle(color: themeProvider.textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BasicCalculatorScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
