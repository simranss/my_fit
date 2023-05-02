import 'package:flutter/material.dart';
import 'package:my_fit/models/bluetooth_model.dart';
import 'package:my_fit/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
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
      home: ChangeNotifierProvider<BluetoothModel>(
        create: (_) => BluetoothModel(),
        child: const HomePage(),
      ),
    );
  }
}
