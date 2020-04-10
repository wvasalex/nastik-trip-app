import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class DeviceInfo {
  static final DeviceInfo _instance = DeviceInfo._internal();
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  factory DeviceInfo() => _instance;

  String appIdentifier;
  String appVersion;
  String device;
  String os;
  String platform;
  String screenResolution;

  DeviceInfo._internal();

  Future<String> getVersion() async {
    await _getPackageInfo();
    return appVersion;
  }

  Future<Map<String, String>> getInfo() async {
    screenResolution = '${window.physicalSize.width}x${window.physicalSize.height}';
    if (Platform.isAndroid) {
      await _getAndroidInfo();
    } else if (Platform.isIOS) {
      await _getIosInfo();
    }
    return _toJSON();
  }

  _getAndroidInfo() async {
    await _getPackageInfo();

    final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    platform = 'android';
    os = info.version.release;
    device = info.device;
  }

  _getIosInfo() async {
    await _getPackageInfo();

    final IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
    platform = 'ios';
    os = info.systemVersion;
    device = info.name;
  }

  _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    appIdentifier = packageInfo.appName;
  }

  Map<String, String> _toJSON() {
    return {
      'app_identifier': appIdentifier,
      'app_version': appVersion,
      'device': device,
      'os': os,
      'platform': platform,
      'screen_resolution': screenResolution,
    };
  }
}