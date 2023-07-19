import 'package:flutter/material.dart';
import 'package:my_fit/utils/bluetooth_utils.dart';

class SleepComponent extends StatelessWidget {
  const SleepComponent(this._sleepDataStream,
      {super.key, required this.isSummaryData});
  final Stream<List<int>> _sleepDataStream;
  final bool isSummaryData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.white,
            Colors.grey.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(int.parse('bebebe', radix: 16) + 0xFF000000),
            // Shadow for bottom right corner
            offset: const Offset(10, 10),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Icon(
                Icons.bedtime_rounded,
                size: isSummaryData ? 75 : 24,
                color: Colors.purple.shade800,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 80,
            color: Colors.grey.shade800,
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: StreamBuilder(
                  stream: _sleepDataStream,
                  builder: (context, snapshot) {
                    var values = snapshot.data;
                    debugPrint(values.toString());
                    var sleepData = BluetoothUtils.getSleepData(
                        values ?? [], isSummaryData);
                    debugPrint('sleep data: $sleepData');
                    return isSummaryData
                        ? _summaryWidget(sleepData)
                        : _instantWidget(sleepData);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryWidget(Map<String, dynamic> sleepData) {
    String totalSleep =
        sleepData.containsKey('total_sleep') ? sleepData['total_sleep'] : '--';
    String totalWake =
        sleepData.containsKey('total_wake') ? sleepData['total_wake'] : '--';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total Sleep Time: $totalSleep'),
          Text('Total Wake Time: $totalWake'),
        ],
      ),
    );
  }

  Widget _instantWidget(Map<String, dynamic> sleepData) {
    bool isAwake = sleepData.containsKey('awake') ? sleepData['awake'] : true;
    return Center(
      child: Text(isAwake ? 'Awake' : 'Sleeping'),
    );
  }
}
