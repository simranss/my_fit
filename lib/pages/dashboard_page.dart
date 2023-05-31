import 'package:flutter/material.dart';
import 'package:my_fit/utils/bluetooth_utils.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../models/bluetooth_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.device});
  final DiscoveredDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Print Data'),
          onPressed: () => debugPrintData(context),
        ),
      ),
    );
  }

  void debugPrintData(BuildContext context) async {
    List<DiscoveredService> services =
        await Provider.of<BluetoothModel>(context, listen: false)
            .discoverServices(device.id);
    for (var service in services) {
      var serviceUuid = service.serviceId;
      debugPrint(serviceUuid.toString());
      debugPrint(serviceUuid.data.toString());
      if (serviceUuid.toString().trim().contains('0000180d')) {
        debugPrint('service uuid: ${serviceUuid.toString()}');
        debugPrint('service uuid data: ${serviceUuid.data.toString()}');
      }
      var characteristicIds = service.characteristicIds;
      debugPrint(characteristicIds.length.toString());
      for (var characteristicId in characteristicIds) {
        if (characteristicId.toString().trim().contains('00002a37') ||
            characteristicId.toString().trim().contains('00002b40')) {
          debugPrint(characteristicId.toString().trim());
          final characteristic = QualifiedCharacteristic(
            serviceId: serviceUuid,
            characteristicId: characteristicId,
            deviceId: device.id,
          );
          if (context.mounted) {
            try {
              Provider.of<BluetoothModel>(context, listen: false)
                  .subscribeToCharacteristic(characteristic)
                  .listen(
                (values) {
                  debugPrint(values.toString());
                  debugPrint('hr: ${BluetoothUtils.getHR(values)}');
                },
              ).onError((error) {
                debugPrint(error.toString());
              });
            } catch (error) {
              debugPrint(error.toString());
            }
          }
        }
      }
    }
  }
}
