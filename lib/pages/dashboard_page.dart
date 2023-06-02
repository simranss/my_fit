import 'package:flutter/material.dart';
import 'package:my_fit/models/dashboard_page_model.dart';
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
        title: const Text('Dashboard'),
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
