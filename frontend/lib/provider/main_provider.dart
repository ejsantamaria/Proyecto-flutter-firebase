import 'package:flutter/material.dart';
import 'package:frontend/models/studentModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider extends ChangeNotifier {
  bool _mode = false;
  String _token = "";
  bool _adm = false;
  String _motocycle = "";
  bool _pendientes = false;
  bool get mode {
    return _mode;
  }

  set mode(bool value) {
    _mode = value;
    notifyListeners();
  }

  String get token {
    return _token;
  }

  bool get adm {
    return _adm;
  }

  String get motocycle {
    return _motocycle;
  }

  bool get pendientes {
    return _pendientes;
  }

  set token(String newToken) {
    updateToken(newToken);
    _token = newToken;
    notifyListeners();
  }

  set adm(bool adms) {
    updateAdm(adms);
    _adm = adms;
    notifyListeners();
  }

  set motocycle(String newMotocycle) {
    updateMotocycle(newMotocycle);
    _motocycle = newMotocycle;
    notifyListeners();
  }

  set pendientes(bool newPendientes) {
    updatePendientes(newPendientes);
    _pendientes = newPendientes;
    notifyListeners();
  }

  Future<bool> getPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _mode = prefs.getBool("mode") ?? true;
      _token = prefs.getString("token") ?? "";
      _adm = prefs.getBool("adm") ?? false;
      _motocycle = prefs.getString("motocycle") ?? "";
      _pendientes = prefs.getBool("pendientes") ?? false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<void> updatePendientes(bool pendientes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("pendientes", pendientes);
  }

  Future<void> updateAdm(bool adm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("adm", adm);
  }

  Future<void> updateMotocycle(String motocycle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("motocycle", motocycle);
  }
}
