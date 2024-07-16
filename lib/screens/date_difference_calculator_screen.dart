import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

class DateDifferenceCalculatorScreen extends StatefulWidget {
  const DateDifferenceCalculatorScreen({super.key});

  @override
  DateDifferenceCalculatorScreenState createState() =>
      DateDifferenceCalculatorScreenState();
}

class DateDifferenceCalculatorScreenState
    extends State<DateDifferenceCalculatorScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _difference = '';

  _selectStartDate(BuildContext context) async {
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
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _calculateDifference();
      });
    }
  }

  _selectEndDate(BuildContext context) async {
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
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _calculateDifference();
      });
    }
  }

  _calculateDifference() {
    if (_startDate != null && _endDate != null) {
      final difference = _endDate!.difference(_startDate!);
      setState(() {
        _difference = 'dateDifferenceCalculator.difference'.tr(args: ['${difference.inDays}']);
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
          'dateDifferenceCalculator.title'.tr(),
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
                _startDate == null
                    ? 'dateDifferenceCalculator.selectStartDate'.tr()
                    : DateFormat.yMMMd().format(_startDate!),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing: Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectStartDate(context),
            ),
            ListTile(
              title: Text(
                _endDate == null
                    ? 'dateDifferenceCalculator.selectEndDate'.tr()
                    : DateFormat.yMMMd().format(_endDate!),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing: Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectEndDate(context),
            ),
            const SizedBox(height: 20),
            Text(
              'dateDifferenceCalculator.differencePrefix'.tr(namedArgs: {'difference': _difference}),
              style: TextStyle(fontSize: 24, color: themeProvider.textColor),
            ),
          ],
        ),
      ),
    );
  }
}