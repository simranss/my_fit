import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothModel extends ChangeNotifier {
  FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  final List<BluetoothDevice> _devices = [];
  UnmodifiableListView<BluetoothDevice> get devices =>
      UnmodifiableListView(_devices);

  void startScanning() {
    _devices.clear();
    notifyListeners();
    _flutterBlue.startScan(timeout: const Duration(seconds: 25)).then((val) => {
          print('devices found: ${_devices.length}'),
          for (BluetoothDevice device in _devices)
            {
              print('device: ${device.name}'),
            }
        });

    // Listen to scan results
    _flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (!_devices.contains(r.device) && r.device.name.trim() != '') {
          debugPrint('${r.device.name} found! rssi: ${r.rssi}');
          _devices.add(r.device);
          notifyListeners();
        }
      }
    });
  }

  void connect(BluetoothDevice device) {
    device.connect();
  }

  void stopScanning() {
    _flutterBlue.stopScan();
  }
}
