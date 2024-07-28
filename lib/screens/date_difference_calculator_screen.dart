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
  int _difference = 0;

  _selectDate(BuildContext context, bool isStartDate) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _calculateDifference();
      });
    }
  }

  _calculateDifference() {
    if (_startDate != null && _endDate != null) {
      setState(() {
        _difference = (_endDate!.difference(_startDate!)).inDays.abs();
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
              trailing:
                  Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text(
                _endDate == null
                    ? 'dateDifferenceCalculator.selectEndDate'.tr()
                    : DateFormat.yMMMd().format(_endDate!),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing:
                  Icon(Icons.calendar_today, color: themeProvider.accentColor),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 20),
            Text(
              _startDate != null && _endDate != null
                  ? '${'dateDifferenceCalculator.differencePrefix'.tr()} $_difference ${'dateDifferenceCalculator.differenceSuffix'.tr()}'
                  : 'dateDifferenceCalculator.selectBothDates'.tr(),
              style: TextStyle(fontSize: 24, color: themeProvider.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
