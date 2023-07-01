import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_fit/components/heart_rate_component.dart';
import 'package:my_fit/components/status_data_component.dart';
import 'package:my_fit/constants/shared_prefs_strings.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:my_fit/utils/bluetooth_utils.dart';
import 'package:my_fit/utils/shared_prefs_utils.dart';

class DashboardPageModel extends ChangeNotifier {
  DashboardPageModel(this._bluetoothModel);

  final BluetoothModel _bluetoothModel;
  final List<Widget> _components = [];
  UnmodifiableListView<Widget> get components =>
      UnmodifiableListView(_components);

  String? _deviceId;
  String get deviceId => _deviceId ?? '';
  String batteryLevel = '';
  Stream<List<int>>? batteryStream;

  void init(String deviceIdTemp) async {
    debugPrint('inside init');
    _deviceId = deviceIdTemp;
    debugPrint('model deviceId: $deviceIdTemp');
    var services = await _bluetoothModel.discoverServices(deviceIdTemp);
    debugPrint('services: ${services.length}');
    for (var service in services) {
      var serviceUuid = service.serviceId;
      var serviceIdStr = serviceUuid.toString().trim().toLowerCase();
      var characteristicIds = service.characteristicIds;
      if (serviceIdStr.contains('183e')) {
        // physical activity monitor service
        debugPrint('found physical activity monitor service');
        for (var characteristicId in characteristicIds) {
          String characteristicIdStr = characteristicId.toString().trim();
          if (characteristicIdStr.contains('00002b40')) {
            // steps
            final characteristic = QualifiedCharacteristic(
              serviceId: serviceUuid,
              characteristicId: characteristicId,
              deviceId: deviceId,
            );
            try {
              int goalSteps = await SharedPrefsUtils.getInt(
                      SharedPrefsStrings.GOAL_STEPS_KEY) ??
                  5000;
              _components.insert(
                0,
                StatusDataComponent(
                  isMi: false,
                  goalSteps: goalSteps,
                  statusStream:
                      _bluetoothModel.subscribeToCharacteristic(characteristic),
                ),
              );
              print('components steps: $_components');
            } catch (err) {
              debugPrint('steps error');
              debugPrint(err.toString());
            }
          }
        }
      } else if (serviceIdStr.contains('180d')) {
        // heart rate service
        debugPrint('found heart rate service');
        for (var characteristicId in characteristicIds) {
          String characteristicIdStr = characteristicId.toString().trim();
          if (characteristicIdStr.contains('00002a37')) {
            // heart rate measurement
            final characteristic = QualifiedCharacteristic(
              serviceId: serviceUuid,
              characteristicId: characteristicId,
              deviceId: deviceId,
            );
            _components.add(HeartRateComponent(
                _bluetoothModel.subscribeToCharacteristic(characteristic)));
            print('components hr: $_components');
          }
        }
      } else if (serviceIdStr.contains('180f')) {
        // battery service
        debugPrint('found battery service');
        for (var characteristicId in characteristicIds) {
          String characteristicIdStr = characteristicId.toString().trim();
          if (characteristicIdStr.contains('00002a19')) {
            // battery level
            final characteristic = QualifiedCharacteristic(
              serviceId: serviceUuid,
              characteristicId: characteristicId,
              deviceId: deviceId,
            );
            try {
              List<int> values =
                  await _bluetoothModel.getCharacteristicData(characteristic);
              debugPrint('battery level data: ${values.toString()}');
              int batteryLevelInt = BluetoothUtils.getBatteryLevel(values);
              debugPrint('battery level: $batteryLevelInt');
              batteryLevel = batteryLevelInt.toString();
            } catch (err) {
              debugPrint('battery level error');
              debugPrint(err.toString());
            }
          }
        }
      } else if (serviceIdStr.contains('fee0')) {
        // mi band
        debugPrint('found mi band fee0 service');
        for (var characteristicId in characteristicIds) {
          String characteristicIdStr = characteristicId.toString().trim();
          if (characteristicIdStr.contains('00000007')) {
            // steps
            final characteristic = QualifiedCharacteristic(
              serviceId: serviceUuid,
              characteristicId: characteristicId,
              deviceId: deviceId,
            );
            try {
              int goalSteps = await SharedPrefsUtils.getInt(
                      SharedPrefsStrings.GOAL_STEPS_KEY) ??
                  5000;
              _components.insert(
                0,
                StatusDataComponent(
                  isMi: true,
                  goalSteps: goalSteps,
                  statusStream:
                      _bluetoothModel.subscribeToCharacteristic(characteristic),
                ),
              );
              print('components steps: $_components');
            } catch (err) {
              debugPrint('steps error');
              debugPrint(err.toString());
            }
          } else if (characteristicIdStr.contains('00000006')) {
            // battery
            final characteristic = QualifiedCharacteristic(
              serviceId: serviceUuid,
              characteristicId: characteristicId,
              deviceId: deviceId,
            );
            batteryStream =
                _bluetoothModel.subscribeToCharacteristic(characteristic);
          }
        }
      } else if (serviceIdStr.contains('fee1')) {
        // mi band
        debugPrint('found mi band fee1 service');
      } else {
        debugPrint('other service: $serviceIdStr');
      }
    }
    print(_components);
    notifyListeners();
  }
}
