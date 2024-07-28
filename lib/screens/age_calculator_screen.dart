import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  AgeCalculatorScreenState createState() => AgeCalculatorScreenState();
}

class AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _birthDate;
  DateTime? _currentDate = DateTime.now();
  int _years = 0;
  int _months = 0;
  int _days = 0;

  _selectDate(BuildContext context, bool isBirthDate) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthDate
          ? (_birthDate ?? DateTime.now())
          : (_currentDate ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: isBirthDate ? DateTime.now() : DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: themeProvider.accentColor,
              onPrimary: themeProvider.backgroundColor,
              onSurface: themeProvider.textColor,
              surface: themeProvider.backgroundColor,
            ),
            dialogBackgroundColor: themeProvider.backgroundColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeProvider.accentColor,
              ),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: themeProvider.textColor),
              bodyMedium: TextStyle(color: themeProvider.textColor),
              titleMedium: TextStyle(color: themeProvider.textColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _birthDate = picked;
        } else {
          _currentDate = picked;
        }
        _calculateAge();
      });
    }
  }

  _calculateAge() {
    if (_birthDate != null && _currentDate != null) {
      _years = _currentDate!.year - _birthDate!.year;
      _months = _currentDate!.month - _birthDate!.month;
      _days = _currentDate!.day - _birthDate!.day;

      if (_days < 0) {
        _months -= 1;
        _days += DateTime(_currentDate!.year, _currentDate!.month, 0).day;
      }
      if (_months < 0) {
        _years -= 1;
        _months += 12;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text(
          'ageCalculatorScreen.title'.tr(),
          style: TextStyle(color: themeProvider.textColor),
        ),
        backgroundColor: themeProvider.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                _birthDate == null
                    ? 'ageCalculatorScreen.selectBirthDate'.tr()
                    : DateFormat.yMMMd().format(_birthDate!),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing:
                  Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text(
                _currentDate == null
                    ? 'ageCalculatorScreen.selectCurrentDate'.tr()
                    : DateFormat.yMMMd().format(_currentDate!),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing:
                  Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 20),
            Text(
              _birthDate != null && _currentDate != null
                  ? '${'ageCalculatorScreen.agePrefix'.tr()} $_years ${'ageCalculatorScreen.years'.tr()}, $_months ${'ageCalculatorScreen.months'.tr()}, $_days ${'ageCalculatorScreen.days'.tr()}'
                  : 'ageCalculatorScreen.selectBothDates'.tr(),
              style: TextStyle(fontSize: 24, color: themeProvider.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
