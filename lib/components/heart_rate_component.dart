import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_fit/utils/bluetooth_utils.dart';

class HeartRateComponent extends StatelessWidget {
  const HeartRateComponent(this._heartRateStream, {super.key});
  final Stream<List<int>> _heartRateStream;

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
              child: SvgPicture.asset(
                'assets/svg/ecg_heart_fill_48.svg',
                width: 75,
                height: 75,
                colorFilter:
                    const ColorFilter.mode(Colors.red, BlendMode.srcIn),
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
                  stream: _heartRateStream,
                  builder: (context, snapshot) {
                    var values = snapshot.data;
                    debugPrint(values.toString());
                    var hr = BluetoothUtils.getHR(values ?? []);
                    debugPrint('hr: $hr');
                    return Center(
                      child: Text(
                        (hr != -1) ? hr.toString() : '--',
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
