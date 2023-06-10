import 'package:flutter/material.dart';
import 'package:my_fit/constants/shared_prefs_strings.dart';
import 'package:my_fit/models/dashboard_page_model.dart';
import 'package:my_fit/utils/shared_prefs_utils.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('deviceId: $deviceId');
      Provider.of<DashboardPageModel>(context, listen: false).init(deviceId);
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
              child: Text('${model.batteryLevel}%', style: const TextStyle(fontSize: 16),),
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
