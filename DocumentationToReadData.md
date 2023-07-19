# How to read the data

The data will always be in List<int> format. It is representing list of bytes

## Heart Rate

- Service UUID => 0x180d
- Characteristic UUID => 0x2a37
- Descriptor UUID => 0x2902

### Example data:

[22, 56, 55, 4, 7, 3]

byte 0 => flags

#### 22 => flags

22 => 0001 0110 goes from right to left (<--)

bit 0:

- 0 => UINT8 bpm (beats per minute)
- 1 => UINT16 bpm
  In our case it is 0 => Unit8 bpm

bit 1-2 (Sensor Contact Status) => 11 => Supported and Detected

bit 3 (Energy Expended Status) => 0 => Not Present

bit 4 (RR-Interval) => 1 => One or more values are present

#### 56 => UINT8 beats per minute

Since flag 0 gives UINT8 bpm, so byte 1 is hr in bpm

But if flag gave UINT16 bpm, then byte 1-2 would combine to give UINT16 bpm

- For UINT16:

byte 1 added to byte 2 shifted by 8 bits

byte 1 + (byte 2 << 8)

#### 55, 4, 7, 3 => UINT16 RR Intervals

There are two UINT16 values here (there can be an arbitrary number of RR-Interval values)

[55, 4] => 55 + (4 << 8) => 1,079

[7, 3] => 7 + (3 << 8) => 775

Resolution of 1/1024 second.

RR0 => 1079 / 1024 => 1.05s

RR1 => 775 / 1024 => 0.76s

### References:

- https://stackoverflow.com/a/65458794/12555686
- Heart Rate Service documentation => https://www.bluetooth.com/specifications/specs/?types=specs-docs&keyword=heart+rate+service&filter=

## Battery Level

- Service UUID => 0x180f
- Characteristic UUID => 0x2a19

### Example Data:

[ byte(0) ]

byte(0) is your watch's battery level

### References

- Battery Service Documentation => https://www.bluetooth.com/specifications/specs/?types=specs-docs&keyword=battery+service&filter=

## Steps

### General Bands

- Service UUID => 0x183e
- Characteristic UUID => 0x2b40

#### Example Data

[byte(0), byte(1), byte(2), ...]

##### byte(1) => flags

Convert it to binary and go from right to left (<--)

bit 0:

- 0 => normal walk steps absent
- 1 => normal walk steps present

The above should be 1 to proceed ahead

bit 3:

- 0 => distance walked absent
- 1 => distance walked present

##### byte(14), byte(15), byte(16) => steps

steps = byte(14) + (byte(15) << 8) + (byte(16) << 16);

##### byte(23), byte(24), byte(25) => distance (meters)

steps = byte(23) + (byte(24) << 8) + (byte(25) << 16);

#### References

- Physical Activity Monitor Service (PAMS) Documentation => https://www.bluetooth.com/specifications/specs/?types=specs-docs&keyword=physical+activity+monitor+service&filter=

### MiBand

- Service UUID => 0xfee0
- Characteristic UUID => 0x0007

#### Example Data

[byte(0), byte(1), byte(2), byte(3), byte(4), byte(5), byte(6), byte(7), byte(8), byte(9)]

- steps => byte(1) + (byte(2) << 8)
- distance walked (meters) => byte(5) + (byte(6) << 8)
- calories burnt (kcal) => byte(9)

## Sleep

- Service UUID => 0x183e
- Characteristic UUID => 0x2b42

### Example Data

[byte(0), byte(1), byte(3), ...]

- total sleep time => byte(16) + (byte(17) << 8) + (byte(18) << 16);
- total wake time => byte(19) + (byte(20) << 8) + (byte(21) << 16);
