import 'package:geolocator/geolocator.dart';
export 'package:geolocator/geolocator.dart' show Position;
import 'package:location_permissions/location_permissions.dart';
import 'package:app_settings/app_settings.dart';

class Geolocation {
  static final Geolocation _instance = Geolocation._internal();

  factory Geolocation() => _instance;

  Geolocation._internal();

  final Geolocator locator = Geolocator();

  Future<Position> getPosition() async {
    PermissionStatus permission = await LocationPermissions().checkPermissionStatus();

    if (permission != PermissionStatus.granted) {
      PermissionStatus status = await LocationPermissions().requestPermissions();

      if (status != PermissionStatus.granted) {
        await LocationPermissions().openAppSettings();
      }
      if (status != PermissionStatus.granted) {
        return null;
      }
    }

    ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
    if (serviceStatus != ServiceStatus.enabled) {
      await AppSettings.openLocationSettings();
    }

    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  Future<double> distance(double lat, double lon, {Position position}) async {
    return locator.distanceBetween(
      position.latitude,
      position.longitude,
      lat,
      lon,
    );
  }
}
