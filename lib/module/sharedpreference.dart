import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(String email, String password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.setString("Email", email);
    _preferences.setString("Password", password);
  }

  Future createidCache(String id) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.setString("id", id);
  }

  Future readMailId() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var id = _preferences.getString("Email");
    return id;
  }

  Future readId() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var id = _preferences.getString("id");
    return id;
  }

  Future readCache() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var email = _preferences.getString("Email");
    var password = _preferences.getString("Password");
    var id = _preferences.getString("id");
    List cache = [email, password, id];

    return cache;
  }

  Future removeCache() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.remove("Email");
    _preferences.remove("Password");
    _preferences.remove("id");
  }
}
