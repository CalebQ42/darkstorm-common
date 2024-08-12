import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:platform_info/platform_info.dart';
import 'package:http/http.dart';

class DarkstormBackend {
  final Uri baseUrl;
  late String plat;
  final String apiKey;
  final void Function(Object, StackTrace)? onError;
  final InternetConnection con;
  final bool waitForInternet;

  final FlutterSecureStorage _securePrefs = const FlutterSecureStorage();

  bool _internetAvailable = true;
  bool get isAvailable => _internetAvailable;

  DarkstormBackend(
      {required this.baseUrl,
      required this.apiKey,
      Uri? internetCheckAddress,
      this.waitForInternet = true,
      this.onError})
      : con = InternetConnection.createInstance(
            customCheckOptions: internetCheckAddress != null
                ? [InternetCheckOption(uri: internetCheckAddress)]
                : null,
            useDefaultOptions: internetCheckAddress == null) {
    platform.when(
        io: () => platform.when(
              fuchsia: () => plat = "fuchsia",
              windows: () => plat = 'windows',
              android: () => plat = 'android',
              iOS: () => plat = 'iOS',
              macOS: () => plat = 'macOS',
              linux: () => plat = 'linux',
              unknown: () => plat = 'unknown',
            ),
        web: () => plat = "web",
        unknown: () => plat = "unknown");
    con.internetStatus.then(
        (value) => _internetAvailable = value == InternetStatus.connected);
    con.onStatusChange.listen(
        (event) => _internetAvailable = event == InternetStatus.connected);
  }

  Future<String?> getID() async {
    return await _securePrefs.read(key: "darkstorm_count_id");
  }

  Future<void> setID(String value) async {
    return _securePrefs.write(key: "darkstorm_count_id", value: value);
  }

  Future<bool> count() async {
    if (waitForInternet && !await con.hasInternetAccess) {
      await con.onStatusChange
          .where((event) => event == InternetStatus.connected)
          .first;
    }
    try {
      var id = await getID() ?? "";
      var resp = await post(baseUrl.resolveUri(Uri(path: "/count")),
          headers: {
            "X-API-Key": apiKey,
            "content-type": "application/json",
          },
          body: const JsonEncoder()
              .convert(<String, String>{"id": id, "platform": plat}));
      if (resp.statusCode == 201) {
        Map<String, String> rt = const JsonDecoder().convert(resp.body);
        if (rt["id"] != id) {
          setID(rt["id"]!);
        }
      }
      return resp.statusCode == 201;
    } catch (e, stack) {
      if (onError != null) onError!(e, stack);
      return false;
    }
  }

  Future<bool> crash(Crash cr) async {
    if (waitForInternet && !await con.hasInternetAccess) {
      await con.onStatusChange
          .where((event) => event == InternetStatus.connected)
          .first;
    }
    try {
      var resp = await post(
        baseUrl.resolveUri(Uri(path: "/crash")),
        headers: <String, String>{
          "X-API-Key": apiKey,
          "content-type": "application/json",
        },
        body: const JsonEncoder().convert(cr),
      );
      return resp.statusCode == 201;
    } catch (e, stack) {
      if (onError != null) onError!(e, stack);
      return false;
    }
  }
}

class Crash {
  String error;
  String stack;
  String version;

  Crash({required this.error, required this.stack, this.version = "unknown"});
}
