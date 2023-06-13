import 'package:flutter/material.dart';

class BluetoothUtils {
  static int getHR(List<int> values) {
    if (values.length > 1) {
      var binaryFlags = values[0].toRadixString(2);
      var flagUINT = binaryFlags[binaryFlags.length - 1];
      if (flagUINT == '0') {
        // UINT8 bpm
        return values[1];
      } else if (flagUINT == '1') {
        // UINT16 bpm
        var hr = values[1] + (values[2] << 8);
        return hr;
      } else {
        return -1;
      }
    } else {
      return -1;
    }
  }

  static int getBatteryLevel(List<int> values) {
    if (values.isNotEmpty) {
      return values[0];
    } else {
      return -1;
    }
  }

  static int getMiSubscriptionBatteryLevel(List<int> values) {
    if (values.length > 1) {
      return values[1];
    } else {
      return -1;
    }
  }

  static Map<String, int> handleSteps(List<int> values) {
    Map<String, int> data = {};
    if (values.length >= 10) {
      // calories
      debugPrint('calories: ${values[9]}');
      data.putIfAbsent('cal', () => values[9]);
    }
    if (values.length >= 3) {
      // steps
      int steps = values[1] + (values[2] << 8);
      debugPrint('steps: $steps');
      data.putIfAbsent('steps', () => steps);
    }
    if (values.length >= 7) {
      // meters
      int meters = values[5] + (values[6] << 8);
      debugPrint('meters: $meters');
      data.putIfAbsent('meters', () => meters);
    }
    return data;
  }
}
