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
  String _age = '';

  _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Theme(
          data: themeProvider.themeMode == ThemeMode.dark
              ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark().copyWith(
              primary: themeProvider.accentColor,
              onPrimary: themeProvider.textColor,
              onSurface: themeProvider.textColor,
            ),
            dialogBackgroundColor: themeProvider.backgroundColor,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: themeProvider.textColor),
            ),
          )
              : ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: themeProvider.accentColor,
              onPrimary: themeProvider.textColor,
              onSurface: themeProvider.textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _calculateAge();
      });
    }
  }

  _selectCurrentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Theme(
          data: themeProvider.themeMode == ThemeMode.dark
              ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark().copyWith(
              primary: themeProvider.accentColor,
              onPrimary: themeProvider.textColor,
              onSurface: themeProvider.textColor,
            ),
            dialogBackgroundColor: themeProvider.backgroundColor,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: themeProvider.textColor),
            ),
          )
              : ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: themeProvider.accentColor,
              onPrimary: themeProvider.textColor,
              onSurface: themeProvider.textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
        _calculateAge();
      });
    }
  }

  _calculateAge() {
    if (_birthDate != null && _currentDate != null) {
      int years = _currentDate!.year - _birthDate!.year;
      int months = _currentDate!.month - _birthDate!.month;
      int days = _currentDate!.day - _birthDate!.day;

      if (days < 0) {
        months -= 1;
        days += DateTime(_currentDate!.year, _currentDate!.month, 0).day;
      }
      if (months < 0) {
        years -= 1;
        months += 12;
      }

      setState(() {
        _age = 'ageCalculatorScreen.age'.tr(args: ['$years', '$months', '$days']);
      });
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
              trailing: Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectBirthDate(context),
            ),
            ListTile(
              title: Text(
                _currentDate == null
                    ? 'ageCalculatorScreen.selectCurrentDate'.tr()
                    : DateFormat.yMMMd().format(_currentDate!),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing: Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectCurrentDate(context),
            ),
            const SizedBox(height: 20),
            Text(
              'ageCalculatorScreen.agePrefix'.tr(namedArgs: {'age': _age}),
              style: TextStyle(fontSize: 24, color: themeProvider.textColor),
            ),
          ],
        ),
      ),
    );
  }
}