import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_fit/classes/bluetooth_device.dart';

class BluetoothModel extends ChangeNotifier {
  final _flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription? _subscription;

  final List<String> _deviceIds = [];
  UnmodifiableListView<BluetoothDevice> get devices =>
      UnmodifiableListView(_devices);
  final List<BluetoothDevice> _devices = [];

  void startScanning() {
    _deviceIds.clear();
    _devices.clear();
    notifyListeners();
    _subscription?.cancel();
    _subscription = _flutterReactiveBle.scanForDevices(
        withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
      //code for handling results
      debugPrint('device: ${device.name} ${device.id}');
      if (device.name.trim() != '' && !_deviceIds.contains(device.id)) {
        debugPrint(
            'deviceIds contains ${device.id}: ${_deviceIds.contains(device.id)}');
        debugPrint('new device: ${device.name}');
        _deviceIds.add(device.id);
        _devices.add(BluetoothDevice(device, 'unknown'));
        notifyListeners();
      }
    }, onError: (err) {
      //code for handling error
      debugPrint('error: ${err.toString()}');
    });
  }

  Future<void> stopScanning() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Stream<ConnectionStateUpdate> connect(String deviceId) {
    return _flutterReactiveBle.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  void connectAndUpdate(String deviceId) {
    _flutterReactiveBle
        .connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    )
        .listen((event) {
      DeviceConnectionState status = event.connectionState;
      int index = _deviceIds.indexOf(deviceId);
      switch (status) {
        case DeviceConnectionState.connected:
          _devices[index].status = 'Connected';
          notifyListeners();
          break;
        case DeviceConnectionState.connecting:
          _devices[index].status = 'Connecting';
          notifyListeners();
          break;
        case DeviceConnectionState.disconnected:
          _devices[index].status = 'Disconnected';
          notifyListeners();
          break;
        case DeviceConnectionState.disconnecting:
          _devices[index].status = 'Disconnecting';
          notifyListeners();
          break;
        default:
          _devices[index].status = 'Unknown';
          notifyListeners();
      }
    });
  }

  Future<List<DiscoveredService>> discoverServices(String deviceId) {
    return _flutterReactiveBle.discoverServices(deviceId);
  }

  Future<List<int>> getCharacteristicData(QualifiedCharacteristic c) {
    return _flutterReactiveBle.readCharacteristic(c);
  }

  Stream<List<int>> subscribeToCharacteristic(QualifiedCharacteristic c) {
    return _flutterReactiveBle.subscribeToCharacteristic(c);
  }
}
