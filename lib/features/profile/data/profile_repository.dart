import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/user_model.dart';

class ProfileRepository {
  final SharedPreferences _prefs;
  static const String _userKey = 'user_profile_data';

  ProfileRepository(this._prefs);

  // Зберегти користувача
  Future<void> saveUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, jsonString);
  }

  // Отримати користувача
  UserModel? getUser() {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  // Перевірка чи є вже профіль
  bool get hasProfile => _prefs.containsKey(_userKey);
}