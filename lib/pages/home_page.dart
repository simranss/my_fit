import 'package:flutter/material.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:my_fit/pages/dashboard_page.dart';
import 'package:my_fit/utils/navigation_utils.dart';
import 'package:provider/provider.dart';

import '../classes/bluetooth_device.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Fit'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Consumer<BluetoothModel>(
                  builder: (_, bluetoothModel, __) => ListView.builder(
                    itemCount: bluetoothModel.devices.length,
                    itemBuilder: (context, index) => getListItem(
                        bluetoothModel.devices[index], context, bluetoothModel),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<BluetoothModel>(context, listen: false)
                      .startScanning();
                },
                child: const Text('Start Scanning'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<BluetoothModel>(context, listen: false)
                      .stopScanning();
                },
                child: const Text('Stop Scanning'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListItem(
      BluetoothDevice device, BuildContext context, BluetoothModel model) {
    final name = device.device.name;
    String status = device.status;
    return ListTile(
      title: Text(name),
      subtitle: Text(status),
      onTap: () => {
        if (status.toLowerCase().trim() != 'connected')
          {
            Provider.of<BluetoothModel>(context, listen: false).stopScanning(),
            Provider.of<BluetoothModel>(context, listen: false)
                .connect(device.device),
          }
        else
          NavigationUtils.push(context, DashboardPage(device: device.device))
      },
    );
  }
}
