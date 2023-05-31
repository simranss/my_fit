import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothDevice {
  final DiscoveredDevice device;
  String status;

  BluetoothDevice(this.device, this.status);
}
