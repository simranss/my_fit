// flutter packages
import 'package:flutter/material.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:provider/provider.dart';

// constants
import 'package:my_fit/constants/shared_prefs_strings.dart';

// models
import 'package:my_fit/models/dashboard_page_model.dart';

// utils
import 'package:my_fit/utils/bluetooth_utils.dart';
import 'package:my_fit/utils/shared_prefs_utils.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  //final String deviceId;

  @override
  Widget build(BuildContext context) {
    final dashboardModel = context.read<DashboardPageModel>();
    final bluetoothModel = context.read<BluetoothModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var deviceId =
          await SharedPrefsUtils.getString(SharedPrefsStrings.DEVICE_ID_KEY);
      debugPrint('deviceId: $deviceId');
      dashboardModel.init(bluetoothModel, deviceId!);
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: FutureBuilder(
          future:
              SharedPrefsUtils.getString(SharedPrefsStrings.DEVICE_NAME_KEY),
          builder: (context, snapshot) => Text(
              snapshot.hasData ? snapshot.data ?? 'Dashboard' : 'Dashboard'),
        ),
        actions: [
          Consumer<DashboardPageModel>(
            builder: (_, model, __) => Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 12),
              child: model.batteryStream != null
                  ? StreamBuilder<List<int>>(
                      stream: model.batteryStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var batteryData = snapshot.data ?? [];
                          var batteryLevel =
                              BluetoothUtils.getMiSubscriptionBatteryLevel(
                                  batteryData);
                          return Text(
                            '$batteryLevel%',
                            style: const TextStyle(fontSize: 16),
                          );
                        }
                        return Text(
                          '${model.batteryLevel}%',
                          style: const TextStyle(fontSize: 16),
                        );
                      })
                  : Text(
                      '${model.batteryLevel}%',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<DashboardPageModel>(
          builder: (_, model, __) => ListView.builder(
            itemCount: model.components.length,
            itemBuilder: (_, index) => model.components[index],
          ),
        ),
      ),
    );
  }
}
