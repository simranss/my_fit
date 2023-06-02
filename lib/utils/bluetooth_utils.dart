class BluetoothUtils {
  static int getHR(List<int> values) {
    if (values.length > 1) {
      var binaryFlags = values[0].toRadixString(2);
      var flagUINT = binaryFlags[binaryFlags.length - 1];
      if (flagUINT == '0') {
        // UINT8 bpm
        return values[1];
      } else if (flagUINT == '1') {
        // UINT16 bpm
        var hr = values[1] + (values[2] << 8);
        return hr;
      } else {
        return -1;
      }
    } else {
      return -1;
    }
  }
}
