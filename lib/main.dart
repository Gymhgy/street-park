import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:part_it/server.dart';
import 'draggable_menu.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _UserMapInfoState();

}

class _UserMapInfoState extends State<MyApp> {

  LatLng? _currentPosition;
  bool _isLoading = true;
  SensorProvider sensorProvider = DemoSensorProvider();
  List<SensorSection> sensors = [];
  SensorSection? currentSensor;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getLocation();
    getSensors();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      final response = await http.get(
          Uri.parse('https://gymhgy.pythonanywhere.com/button_pressed'));
      if (response.statusCode == 200 && response.body == '1') {
        _showModalBottomSheet(context, new ParkDialog());
      }
    });

  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }


  getSensors() async {
    List<SensorSection> retrieved = await sensorProvider.getLocalSensorSections(LatLng(0, 0), 5);
    setState(() {
      sensors = retrieved;
    });
  }

  List<Marker> toMarkers(List<SensorSection> sensors, BuildContext context) {
    return sensors.where((s) => s.status != SensorStatus.occupied).map((sensor) => Marker(
        point: sensor.coords,
        alignment: Alignment.center,
        rotate: true,
        child: IconButton(
          onPressed: () => {
            setState(() {
              currentSensor = sensor;
            }),
            _showModalBottomSheet(
              context,
              Stack(
                alignment: AlignmentDirectional.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "2899-2849 Dwight Way",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)
                      ),
                      Text(
                        "Parking fee: \$0.25 / hr",
                        style: TextStyle(color: Colors.black, fontSize: 14)
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text("Navigate"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(color: Colors.white, fontSize: 14)
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  )
                ]
              )
            )
          },
          padding: EdgeInsets.zero,
          icon: Icon(
            /*currentSensor == sensor ? Icons.location_on : */ Icons.local_parking_rounded,
            color: darken(sensor.status.color),
            size: 40,
          ),
        )
      )
    ).toList();
  }

  Color darken(Color color, [double amount = .25]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  List<Polyline> toPolyline(List<SensorSection> sensors) {
    return sensors.map((sensor) => Polyline(
        points: sensor.points,
        color: sensor.status.color,
        strokeWidth: 4,
        //useStrokeWidthInMeter: true
     )
    ).toList();
  }

  void _showModalBottomSheet(BuildContext context, Widget content) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
        //isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        )),
      builder: (context) => SingleChildScrollView(
            //controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: content,
              ),
            ),
          )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _isLoading ? Center(child:CircularProgressIndicator()) : Stack(
        children: [
          SearchBarWidget(),
          FlutterMap(
            options: MapOptions(
              initialCenter: _currentPosition!,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolylineLayer(
                  polylines: toPolyline(sensors)
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 80,
                    height: 80,
                    child: IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.location_history,
                        color: Colors.blue,
                        size: 35,
                      ),
                    )
                  )
                ] + toMarkers(sensors, context),
              ),

            ],
          ),
        ],
      ),
    );
  }
}