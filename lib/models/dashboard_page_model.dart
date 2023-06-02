import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_fit/components/heart_rate_component.dart';
import 'package:my_fit/models/bluetooth_model.dart';

class DashboardPageModel extends ChangeNotifier {
  DashboardPageModel(this._bluetoothModel);

  final BluetoothModel _bluetoothModel;
  final List<Widget> _components = [];
  UnmodifiableListView<Widget> get components =>
      UnmodifiableListView(_components);

  String? _deviceId;
  String get deviceId => _deviceId ?? '';

  void init(String deviceIdTemp) async {
    debugPrint('inside init');
    _deviceId = deviceIdTemp;
    debugPrint('model deviceId: $deviceIdTemp');
    //notifyListeners();
    var services = await _bluetoothModel.discoverServices(deviceIdTemp);
    debugPrint('services: ${services.length}');
    for (var service in services) {
      var serviceUuid = service.serviceId;
      var characteristicIds = service.characteristicIds;
      debugPrint('characteristics: ${characteristicIds.length.toString()}');
      for (var characteristicId in characteristicIds) {
        debugPrint('before handle characteristics');
        String characteristicIdStr = characteristicId.toString().trim();
        if (characteristicIdStr.contains('00002a37')) {
          // heart rate
          _printStmt('heart rate');
          final characteristic = QualifiedCharacteristic(
            serviceId: serviceUuid,
            characteristicId: characteristicId,
            deviceId: deviceId,
          );
          _components.add(HeartRateComponent(
              _bluetoothModel.subscribeToCharacteristic(characteristic)));
          notifyListeners();
        }
        if (characteristicIdStr.contains('00002b40')) {
          // steps - Step Counter Activity Summary Data
          _printStmt('steps - Step Counter Activity Summary Data');
        }
        if (characteristicIdStr.contains('000027ba')) {
          // steps - step (per minute)
          _printStmt('steps - step (per minute)');
        }
        if (characteristicIdStr.contains('00002acf')) {
          // steps - Step Climber Data
          _printStmt('steps - Step Climber Data');
        }
        if (characteristicIdStr.contains('00002b41')) {
          // sleep - Sleep Activity Instantaneous Data
          _printStmt('sleep - Sleep Activity Instantaneous Data');
        }
        if (characteristicIdStr.contains('00002b42')) {
          // sleep - Sleep Activity Summary Data
          _printStmt('sleep - Sleep Activity Summary Data');
        }
        if (characteristicIdStr.contains('000027a9')) {
          // energy - gram calorie
          _printStmt('energy - gram calorie');
        }
        if (characteristicIdStr.contains('00002725')) {
          // energy - joule
          _printStmt('energy - joule');
        }
        if (characteristicIdStr.contains('000027aa')) {
          // energy - kilogram calorie
          _printStmt('energy - kilogram calorie');
        }
        if (characteristicIdStr.contains('000027ab')) {
          // energy - kilowatt hour
          _printStmt('energy - kilowatt hour');
        }
        if (characteristicIdStr.contains('0000274a')) {
          // energy density - joule per cubic metre
          _printStmt('energy density - joule per cubic metre');
        }
      }
    }
  }

  void _printStmt(String message) {
    debugPrint('charActivity: $message');
  }
}
