import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

abstract class SensorProvider {

  Future<List<SensorSection>> getLocalSensorSections(LatLng center, double radius);

}

class SensorSection {
  final LatLng coords;
  final List<LatLng> points;
  final SensorStatus status;

  factory SensorSection(List<LatLng> points, SensorStatus status) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    return SensorSection.withCenter(LatLng(latitude / n, longitude / n), points, status);
  }

  SensorSection.withCenter(this.coords, this.points, this.status);
}

enum SensorStatus {
  open(color: Colors.green),
  occupied(color: Colors.red);

  const SensorStatus({
    required this.color
  });

  final Color color;
}

class DemoSensorProvider implements SensorProvider {
  @override
  Future<List<SensorSection>> getLocalSensorSections(LatLng center, double radius) async {
    return [
      SensorSection([
        LatLng(37.86600402993, -122.25036401482518),
        LatLng(37.866034496198544, -122.24966844827783)
      ], SensorStatus.open),
      SensorSection([
        LatLng(37.865991295773355, -122.24922297805104),
        LatLng(37.866018822826334, -122.24866373749074)
      ], SensorStatus.open),
      SensorSection([
        LatLng(37.86800450015009, -122.24999804907539),
        LatLng(37.86757254761903, -122.24991221839214)
      ], SensorStatus.open),
      SensorSection([
        LatLng(37.86755978846737, -122.24990683645144),
        LatLng(37.86638461045329, -122.24969225971263)
      ], SensorStatus.occupied),
      SensorSection([
        LatLng(37.866369776063515, -122.24969095914183),
        LatLng(37.866052157108534, -122.24963329165152)
      ], SensorStatus.open),
    ];
  }

}