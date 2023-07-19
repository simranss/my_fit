import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_fit/constants/shared_prefs_strings.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:my_fit/models/dashboard_page_model.dart';
import 'package:my_fit/pages/dashboard_page.dart';
import 'package:my_fit/pages/device_list.dart';
import 'package:my_fit/utils/shared_prefs_utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BluetoothModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _showPage(),
    );
  }

  Widget _showPage() {
    return FutureBuilder(
      future: SharedPrefsUtils.getString(SharedPrefsStrings.DEVICE_ID_KEY),
      builder: (context, futureSnapshot) {
        String? deviceId = futureSnapshot.data;
        if (deviceId == null) {
          return const DeviceListPage();
        } else {
          return StreamBuilder(
            stream: Provider.of<BluetoothModel>(context, listen: false)
                .connect(deviceId),
            builder: (_, streamSnapshot) {
              if (streamSnapshot.hasData) {
                ConnectionStateUpdate? connectionStateUpdate =
                    streamSnapshot.data;
                DeviceConnectionState state =
                    connectionStateUpdate?.connectionState ??
                        DeviceConnectionState.disconnected;
                if (state == DeviceConnectionState.connected) {
                  return ChangeNotifierProxyProvider<BluetoothModel,
                      DashboardPageModel>(
                    create: (context) => DashboardPageModel(
                        Provider.of<BluetoothModel>(context, listen: false)),
                    update: (_, bluetoothModel, prevDashboardPageModel) =>
                        DashboardPageModel(bluetoothModel),
                    child: DashboardPage(deviceId: deviceId),
                  );
                } else {
                  return const DeviceListPage();
                }
              }
              return const DeviceListPage();
            },
          );
        }
      },
    );
  }
}
