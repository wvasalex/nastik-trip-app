import 'package:flutter/material.dart';
import '../storage.dart';
import '../api.dart';
import '../device_info.dart';
import 'auth.model.dart';
import '../cache.dart';
import '../geolocation.dart';

export 'auth.model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final ApiService api = ApiService();
  final DeviceInfo _deviceInfo = DeviceInfo();
  final Cache _cache = Cache();
  final Geolocation _geolocation = Geolocation();
  final LocalStorage _storage = LocalStorage();

  String _token;
  UserProfile _profile;

  UserProfile getProfile() {
    return _profile;
  }

  String getToken() {
    return _token;
  }

  Future<bool> checkSession() async {
    var token = await _storage.getItem('auth.token');
    if (token != null) {
      return await _updateProfile(token);
    }

    return _token != null;
  }

  Future<bool> initSession({
    @required String phone,
    @required String password,
  }) async {
    var auth;
    try {
      auth = await api.post(
        '/api/mobile/users/login',
        body: {
          'phone': _fixPhone(phone),
          'password': password,
        },
        raw: true,
      );
    } catch (e) {
      return false;
    }

    if (auth['user'] != null) {
      final bool ok = await _updateProfile(null, auth['user']);

      return ok;
    }
    return false;
  }

  Future<bool> destroySession() async {
    _updateProfile(null, null);
    _cache.clear();
    try {
      var result = await api.post('/api/auth/sign_out');
      return result['ok'];
    } catch (e) {
      return false;
    }
  }

  Future<ApiError> signUp({
    @required String phone,
    @required String password,
  }) async {
    try {
      await api.post('/api/users/sign_up', body: {
        'phone': _fixPhone(phone),
        'password': password,
      });
      return null;
    } on ApiError catch (e) {
      return e;
    }
  }

  Future confirmPhone(String phone, String code) async {
    try {
      var result = await api.post('/api/users/confirm_phone', body: {
        'phone': _fixPhone(phone),
        'code': code,
      });
      return result != null && result['token'] != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendCode(String phone, {bool restore = false}) async {
    final String method = restore
        ? 'get_restore_password_confirmation_code'
        : 'get_sign_up_confirmation_code';

    try {
      await api.post('/api/users/$method', body: {
        'phone': _fixPhone(phone),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restorePassword({
    @required String phone,
    @required String password,
    @required String code,
  }) async {
    try {
      await api.post('/api/users/restore_password', body: {
        'phone': _fixPhone(phone),
        'password': password,
        'code': code,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveProfile({
    String firstName,
    String lastName,
    String email,
  }) async {
    final UserProfile cur = getProfile();
    try {
      await api.post('/api/users/update_my_profile', body: {
        'first_name': firstName,
        'last_name': lastName,
      });

      _profile.update(UserProfile(
        id: cur.id,
        firstName: firstName,
        lastName: lastName,
      ));
    } catch (e) {
      return false;
    }

    if (email != null && email.length > 0) {
      try {
        await api.post('/api/users/change_my_email', body: {
          'new_email': email,
        });

        await api.post('/api/users/send_confirmation_email');

        /*_profile.update(UserProfile(
          id: cur.id,
          email: email,
        ));*/
      } catch (e) {
        return false;
      }
    }

    return true;
  }

  Future<UserLocation> getJobLocation() async {
    try {
      final raw = await api.post('/api/users/get_job_location');
      return UserLocation.fromJSON(raw);
    } catch (e) {}
    return null;
  }

  Future<void> checkLocation() async {
    final UserLocation location = await getJobLocation();
    if (location != null && location.hasLocation == true) {
      return;
    }

    return updateJobLocation();
  }

  Future<void> updateJobLocation() async {
    final Position position = await _geolocation.getPosition();
    if (position != null) {
      await api.post(
        '/api/users/update_job_location',
        body: {
          'longitude': position.longitude,
          'latitude': position.latitude,
        },
      );
    }
  }

  Future<bool> _updateProfile(
    String token, [
    Map<String, dynamic> profile,
  ]) async {
    await _storage.setItem('auth.token', _token = token ?? profile['token']);

    if (profile == null) {
      try {
        profile = await api.get('/api/mobile/users/profile');
      } on ApiError catch (e) {
        if (e.errorCode == 7) {
          profile = null;
        } else {
          throw e;
        }
      } catch (e) {
        /*final String stored = await _storage.getItem('auth.profile');
        if (stored != null) {
          profile = json.decode(stored);
        }*/
      }
    }

    if (profile != null && profile['id'] != null) {
      _profile = UserProfile.fromJSON(profile);
      return true;
    } else {
      _profile = null;
      return false;
    }

    /*await _storage.setItem('auth.profile', json.encode(profile));
        await api.post(
          '/api/users/update_device_info',
          body: await _deviceInfo.getInfo(),
        );*/
  }

  String _fixPhone(String phone) {
    phone = phone.replaceAll('+', '');
    if (phone.startsWith('8')) {
      phone = phone.replaceFirst('8', '7');
    }
    return phone;
  }
}
