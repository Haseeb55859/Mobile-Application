import 'package:flutter/material.dart';

void main() => runApp(SmartHomeApp());

class SmartHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class Device {
  String name;
  String type;
  String room;
  bool isOn;
  double value;

  Device({
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.value = 0.5,
  });
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Device> devices = [
    Device(name: 'Living Room Light', type: 'Light', room: 'Living Room', isOn: true, value: 0.8),
    Device(name: 'Bedroom Fan', type: 'Fan', room: 'Bedroom', isOn: false, value: 0.4),
    Device(name: 'Hall AC', type: 'AC', room: 'Hall', isOn: true, value: 0.6),
    Device(name: 'Front Door Camera', type: 'Camera', room: 'Entrance', isOn: true, value: 0.0),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addDevice(Device newDevice) {
    setState(() => devices.add(newDevice));
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Light':
        return Icons.lightbulb_outline;
      case 'Fan':
        return Icons.toys;
      case 'AC':
        return Icons.ac_unit;
      case 'Camera':
        return Icons.videocam;
      default:
        return Icons.device_unknown;
    }
  }

  Color _cardColor(Device d) => d.isOn ? Colors.indigo.shade50 : Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 800 ? 4 : width > 600 ? 3 : 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Smart Home Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.indigo),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('My Devices', style: Theme.of(context).textTheme.titleLarge)),
                Text('${devices.length} items'),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 4,
                children: List.generate(devices.length, (index) {
                  final d = devices[index];
                  return DeviceCard(
                    device: d,
                    icon: _iconForType(d.type),
                    cardColor: _cardColor(d),
                    onToggle: (val) => setState(() => d.isOn = val),
                    onOpenDetails: () async {
                      final updated = await Navigator.push<Device?>(
                        context,
                        MaterialPageRoute(builder: (_) => DeviceDetailsScreen(device: d)),
                      );
                      if (updated != null) setState(() {});
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String room = '';
    String type = 'Light';
    bool status = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Device'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Device name'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                    onSaved: (v) => name = v!.trim(),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: type,
                    items: ['Light', 'Fan', 'AC', 'Camera']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => type = v ?? 'Light',
                    decoration: InputDecoration(labelText: 'Device type'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Room name'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter room' : null,
                    onSaved: (v) => room = v!.trim(),
                  ),
                  SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Status (ON/OFF)'),
                    value: status,
                    onChanged: (v) => setState(() => status = v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newDevice = Device(name: name, type: type, room: room, isOn: status, value: 0.5);
                  _addDevice(newDevice);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class DeviceCard extends StatefulWidget {
  final Device device;
  final IconData icon;
  final Color cardColor;
  final ValueChanged<bool> onToggle;
  final VoidCallback onOpenDetails;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.icon,
    required this.cardColor,
    required this.onToggle,
    required this.onOpenDetails,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 0.1)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.device;
    final scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onOpenDetails,
      child: Transform.scale(
        scale: scale,
        child: Card(
          elevation: 2,
          color: widget.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(widget.icon, size: 22, color: Colors.indigo),
                    ),
                    Switch(
                      value: d.isOn,
                      onChanged: (v) {
                        widget.onToggle(v);
                        setState(() {});
                      },
                    )
                  ],
                ),
                SizedBox(height: 12),
                Text(d.name, style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 6),
                Text(d.room, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                Spacer(),
                Text('${d.type} is ${d.isOn ? 'ON' : 'OFF'}', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;
  DeviceDetailsScreen({required this.device});

  @override
  _DeviceDetailsScreenState createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  IconData _iconForType(String type) {
    switch (type) {
      case 'Light':
        return Icons.lightbulb_outline;
      case 'Fan':
        return Icons.toys;
      case 'AC':
        return Icons.ac_unit;
      case 'Camera':
        return Icons.videocam;
      default:
        return Icons.device_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.device;
    return Scaffold(
      appBar: AppBar(
        title: Text(d.name),
        leading: BackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.indigo.shade50,
              child: Icon(_iconForType(d.type), size: 56, color: Colors.indigo),
            ),
            SizedBox(height: 20),
            Text('${d.type} — ${d.room}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Status: ${d.isOn ? 'ON' : 'OFF'}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),
            if (d.type == 'Light' || d.type == 'Fan') ...[
              Text(d.type == 'Light' ? 'Brightness' : 'Speed'),
              Slider(
                value: d.value,
                onChanged: (val) => setState(() => d.value = val),
                min: 0,
                max: 1,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(() => d.isOn = !d.isOn),
                    icon: Icon(d.isOn ? Icons.power_settings_new : Icons.power_off),
                    label: Text(d.isOn ? 'Turn OFF' : 'Turn ON'),
                  ),
                  Text('${(d.value * 100).round()}%', style: TextStyle(fontSize: 16)),
                ],
              )
            ] else ...[
              ElevatedButton.icon(
                onPressed: () => setState(() => d.isOn = !d.isOn),
                icon: Icon(d.isOn ? Icons.power_settings_new : Icons.power_off),
                label: Text(d.isOn ? 'Turn OFF' : 'Turn ON'),
              )
            ],
            Spacer(),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, d),
              icon: Icon(Icons.arrow_back),
              label: Text('Back to Dashboard'),
            )
          ],
        ),
      ),
    );
  }
}
