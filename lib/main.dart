import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_fit/constants/shared_prefs_strings.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:my_fit/models/home.dart';
import 'package:my_fit/models/user_model.dart';
import 'package:my_fit/pages/device_list.dart';
import 'package:my_fit/pages/home.dart';
import 'package:my_fit/pages/login.dart';
import 'package:my_fit/utils/shared_prefs_utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothModel>(create: (_) => BluetoothModel()),
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel())
      ],
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
      home: _showPage(context),
    );
  }

  Widget _showPage(BuildContext context) {
    var userModel = context.read<UserModel>();
    return StreamBuilder<User?>(
      stream: userModel.subscribeToUserChanges(),
      builder: (_, userSnapShot) {
        if (userSnapShot.hasData) {
          var user = userSnapShot.data;
          if (user != null) {
            userModel.setUser(user);
            return FutureBuilder(
              future:
                  SharedPrefsUtils.getString(SharedPrefsStrings.DEVICE_ID_KEY),
              builder: (context, futureSnapshot) {
                String? deviceId = futureSnapshot.data;
                if (deviceId == null) {
                  return const DeviceListPage();
                } else {
                  var bluetoothModel = context.read<BluetoothModel>();
                  return StreamBuilder(
                    stream: bluetoothModel.connect(deviceId),
                    builder: (__, streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        ConnectionStateUpdate? connectionStateUpdate =
                            streamSnapshot.data;
                        DeviceConnectionState state =
                            connectionStateUpdate?.connectionState ??
                                DeviceConnectionState.disconnected;
                        if (state == DeviceConnectionState.connected) {
                          return ChangeNotifierProvider<HomeModel>(
                            create: (_) => HomeModel(),
                            child: const HomePage(),
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
        return ChangeNotifierProvider<LoginModel>(
          create: (_) => LoginModel(),
          child: const LoginPage(),
        );
      },
    );
  }
}
