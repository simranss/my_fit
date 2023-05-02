import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:my_fit/pages/DashboardPage.dart';
import 'package:provider/provider.dart';

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
                  builder: (ctx, bluetoothModel, child) => ListView.builder(
                      itemCount: bluetoothModel.devices.length,
                      itemBuilder: (context, index) =>
                          getListItem(bluetoothModel.devices[index])),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<BluetoothModel>(context, listen: false)
                        .startScanning();
                  },
                  child: const Text('Start Scanning')),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<BluetoothModel>(context, listen: false)
                        .stopScanning();
                  },
                  child: const Text('Stop Scanning')),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListItem(BluetoothDevice device) {
    final name = device.name;
    String status = '';
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (context, snapshot) {
        var event = snapshot.data;
        if (event == BluetoothDeviceState.connected) {
        status = 'connected';
        } else if (event == BluetoothDeviceState.connecting) {
          status = 'connecting';
        } else if (event == BluetoothDeviceState.disconnected) {
          status = 'disconnected';
        } else if (event == BluetoothDeviceState.disconnecting) {
          status = 'disconnecting';
        } else {
          status = '';
        }
        return ListTile(
          title: Text(name),
          trailing: Text(status),
          onTap: () => {
            Provider.of<BluetoothModel>(context, listen: false).connect(device),
            Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage(device: device,)))
          },
        );
      },
    );
  }
}
