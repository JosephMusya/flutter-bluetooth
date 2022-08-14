import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter BT', home: BluetoothApp());
  }
}

class BluetoothApp extends StatefulWidget {
  const BluetoothApp({Key? key}) : super(key: key);

  @override
  State<BluetoothApp> createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  var _device;
  bool _connected = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error Occured");
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case FlutterBluetoothSerial.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BT App'),
        actions: const [IconButton(onPressed: null, icon: Icon(Icons.add))],
      ),
      body:Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Paired Devices',
              style: TextStyle(color: Colors.green[900], fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(children: [
              const Text(
                'Device Connected:',
                style: TextStyle(fontSize: 20),
              ),
              DropdownButton(
                items: null,
                onChanged: (value) => setState(() {
                  value = _device;
                }),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
