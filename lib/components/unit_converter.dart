import 'package:easy_localization/easy_localization.dart';

class UnitConverter {
  static String convertNumeralSystem(String value, String fromUnit, String toUnit) {
    int decimalValue;
    try {
      decimalValue = int.parse(value, radix: int.parse(fromUnit));
    } catch (e) {
      return "invalidInput".tr();
    }
    return decimalValue.toRadixString(int.parse(toUnit)).toUpperCase();
  }

  static double convertArea(double value, String fromUnit, String toUnit) {
    double lengthInMeters = fromUnit == 'km2'
        ? value * 1000000
        : fromUnit == 'm2'
        ? value
        : fromUnit == 'dm2'
        ? value / 100
        : fromUnit == 'cm2'
        ? value / 10000
        : fromUnit == 'mm2'
        ? value / 1000000
        : fromUnit == 'μm2'
        ? value / 1000000000000
        : fromUnit == 'mi2'
        ? value * 2589988.11
        : fromUnit == 'yd2'
        ? value * 0.836127
        : fromUnit == 'ft2'
        ? value * 0.092903
        : fromUnit == 'in2'
        ? value * 0.00064516
        : value;

    return toUnit == 'km2'
        ? lengthInMeters / 1000000
        : toUnit == 'm2'
        ? lengthInMeters
        : toUnit == 'dm2'
        ? lengthInMeters * 100
        : toUnit == 'cm2'
        ? lengthInMeters * 10000
        : toUnit == 'mm2'
        ? lengthInMeters * 1000000
        : toUnit == 'μm2'
        ? lengthInMeters * 1000000000000
        : toUnit == 'mi2'
        ? lengthInMeters / 2589988.11
        : toUnit == 'yd2'
        ? lengthInMeters / 0.836127
        : toUnit == 'ft2'
        ? lengthInMeters / 0.092903
        : toUnit == 'in2'
        ? lengthInMeters / 0.00064516
        : lengthInMeters;
  }

  static double convertLength(double value, String fromUnit, String toUnit) {
    double lengthInMeters = fromUnit == 'km'
        ? value * 1000
        : fromUnit == 'm'
        ? value
        : fromUnit == 'dm'
        ? value / 10
        : fromUnit == 'cm'
        ? value / 100
        : fromUnit == 'mm'
        ? value / 1000
        : fromUnit == 'μm'
        ? value / 1000000
        : fromUnit == 'mi'
        ? value * 1609.34
        : fromUnit == 'yd'
        ? value * 0.9144
        : fromUnit == 'ft'
        ? value * 0.3048
        : fromUnit == 'in'
        ? value * 0.0254
        : value;

    return toUnit == 'km'
        ? lengthInMeters / 1000
        : toUnit == 'm'
        ? lengthInMeters
        : toUnit == 'dm'
        ? lengthInMeters * 10
        : toUnit == 'cm'
        ? lengthInMeters * 100
        : toUnit == 'mm'
        ? lengthInMeters * 1000
        : toUnit == 'μm'
        ? lengthInMeters * 1000000
        : toUnit == 'mi'
        ? lengthInMeters / 1609.34
        : toUnit == 'yd'
        ? lengthInMeters / 0.9144
        : toUnit == 'ft'
        ? lengthInMeters / 0.3048
        : toUnit == 'in'
        ? lengthInMeters / 0.0254
        : lengthInMeters;
  }

  static double convertVolume(double value, String fromUnit, String toUnit) {
    double volumeInMetersCubed = fromUnit == 'km3'
        ? value * 1e9
        : fromUnit == 'm3'
        ? value
        : fromUnit == 'dm3'
        ? value / 1e3
        : fromUnit == 'cm3'
        ? value / 1e6
        : fromUnit == 'mm3'
        ? value / 1e9
        : fromUnit == 'hl'
        ? value / 1e2
        : fromUnit == 'L'
        ? value / 1e3
        : fromUnit == 'dL'
        ? value / 1e4
        : fromUnit == 'cL'
        ? value / 1e5
        : fromUnit == 'mL'
        ? value / 1e6
        : fromUnit == 'ft3'
        ? value * 0.0283168
        : fromUnit == 'in3'
        ? value * 0.0000163871
        : fromUnit == 'yd3'
        ? value * 0.764555
        : fromUnit == 'acre-ft'
        ? value * 1233.48
        : value;

    return toUnit == 'km3'
        ? volumeInMetersCubed / 1e9
        : toUnit == 'm3'
        ? volumeInMetersCubed
        : toUnit == 'dm3'
        ? volumeInMetersCubed * 1e3
        : toUnit == 'cm3'
        ? volumeInMetersCubed * 1e6
        : toUnit == 'mm3'
        ? volumeInMetersCubed * 1e9
        : toUnit == 'hl'
        ? volumeInMetersCubed * 1e2
        : toUnit == 'L'
        ? volumeInMetersCubed * 1e3
        : toUnit == 'dL'
        ? volumeInMetersCubed * 1e4
        : toUnit == 'cL'
        ? volumeInMetersCubed * 1e5
        : toUnit == 'mL'
        ? volumeInMetersCubed * 1e6
        : toUnit == 'ft3'
        ? volumeInMetersCubed / 0.0283168
        : toUnit == 'in3'
        ? volumeInMetersCubed / 0.0000163871
        : toUnit == 'yd3'
        ? volumeInMetersCubed / 0.764555
        : toUnit == 'acre-ft'
        ? volumeInMetersCubed / 1233.48
        : volumeInMetersCubed;
  }

  static double convertTime(double value, String fromUnit, String toUnit) {
    double timeInSeconds = fromUnit == 'μs'
        ? value / 1000000
        : fromUnit == 'ms'
        ? value / 1000
        : fromUnit == 'min'
        ? value * 60
        : fromUnit == 'h'
        ? value * 3600
        : fromUnit == 'd'
        ? value * 86400
        : fromUnit == 'wk'
        ? value * 604800
        : fromUnit == 'y'
        ? value * 31536000
        : value;

    return toUnit == 'μs'
        ? timeInSeconds * 1000000
        : toUnit == 'ms'
        ? timeInSeconds * 1000
        : toUnit == 'min'
        ? timeInSeconds / 60
        : toUnit == 'h'
        ? timeInSeconds / 3600
        : toUnit == 'd'
        ? timeInSeconds / 86400
        : toUnit == 'wk'
        ? timeInSeconds / 604800
        : toUnit == 'y'
        ? timeInSeconds / 31536000
        : timeInSeconds;
  }

  static double convertMass(dynamic value, String fromUnit, String toUnit) {
    double massInGrams = fromUnit == 'μg'
        ? value / 1000000
        : fromUnit == 'mg'
        ? value / 1000
        : fromUnit == 'g'
        ? value
        : fromUnit == 'kg'
        ? value * 1000
        : fromUnit == 't'
        ? value * 1000000
        : fromUnit == 'lb'
        ? value * 453.592
        : fromUnit == 'oz'
        ? value * 28.3495
        : value;

    return toUnit == 'μg'
        ? massInGrams * 1000000
        : toUnit == 'mg'
        ? massInGrams * 1000
        : toUnit == 'g'
        ? massInGrams
        : toUnit == 'kg'
        ? massInGrams / 1000
        : toUnit == 'ton'
        ? massInGrams / 1000000
        : toUnit == 'lb'
        ? massInGrams / 453.592
        : toUnit == 'oz'
        ? massInGrams / 28.3495
        : massInGrams;
  }

  static double convertTemperature(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) {
      return value;
    }

    if (fromUnit == 'C') {
      if (toUnit == 'F') {
        return (value * 9 / 5) + 32;
      } else if (toUnit == 'K') {
        return value + 273.15;
      }
    } else if (fromUnit == 'F') {
      if (toUnit == 'C') {
        return (value - 32) * 5 / 9;
      } else if (toUnit == 'K') {
        return ((value - 32) * 5 / 9) + 273.15;
      }
    } else if (fromUnit == 'K') {
      if (toUnit == 'C') {
        return value - 273.15;
      } else if (toUnit == 'F') {
        return ((value - 273.15) * 9 / 5) + 32;
      }
    }

    throw ArgumentError('invalidUnitConversion'.tr);
  }
}