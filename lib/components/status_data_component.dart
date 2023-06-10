import 'package:flutter/material.dart';

class StatusDataComponent extends StatelessWidget {
  const StatusDataComponent(this._statusData, this._goalSteps, {super.key});
  final Map<String, int> _statusData;
  final int _goalSteps;

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
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: _getCircularProgressIndicator(),
                    ),
                    Text(_statusData.containsKey('steps')
                        ? _statusData['steps'].toString()
                        : '--')
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 80,
            color: Colors.grey.shade800,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _caloriesWidget(),
                _distWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _distWidget() {
    int meters =
        _statusData.containsKey('meters') ? _statusData['meters'] ?? 0 : 0;
    if (meters > 1000) {
      if (meters % 1000 == 0) {
        meters ~/= 1000;
        debugPrint('meters dashboard: $meters');
        return Text('Distance: ${meters}km');
      }
      double metersFloat = meters.toDouble() / 1000;
      return Text('Distance: ${metersFloat.toStringAsFixed(2)}km');
    }
    return Text('Distance: ${meters}m');
  }

  Widget _caloriesWidget() {
    int cal = _statusData.containsKey('cal') ? _statusData['cal'] ?? 0 : 0;
    return Text('Calories: ${cal}kcal');
  }

  Widget _getCircularProgressIndicator() {
    int steps =
        _statusData.containsKey('steps') ? _statusData['steps'] ?? 0 : 0;
    double value = 0;
    if (steps <= _goalSteps) {
      value = steps / _goalSteps;
    } else {
      value = 1;
    }
    return CircularProgressIndicator(
      value: 1 - value,
      backgroundColor: Colors.blue,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade100),
      strokeWidth: 10,
    );
  }
}
