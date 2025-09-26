import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

abstract class DeviceInfo {
  Future<String> get deviceModel;
  Future<String> get osVersion;
  Future<bool> get isPhysicalDevice;
}

class DeviceInfoImpl implements DeviceInfo {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  Future<String> get deviceModel async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.model;
    }
    return 'Unknown';
  }

  @override
  Future<String> get osVersion async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    }
    return 'Unknown';
  }

  @override
  Future<bool> get isPhysicalDevice async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice;
    }
    return true;
  }
}