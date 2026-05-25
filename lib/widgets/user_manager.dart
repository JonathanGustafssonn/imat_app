import 'dart:convert';
import 'package:imat_app/model/imat/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const _usersKey = "saved_users";
  static const _loggedInKey = "logged_in_user";

  // HÄMTA ALLA ANVÄNDARE
  static Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(_usersKey) ?? [];

    return data
        .map((e) => User.fromJson(jsonDecode(e)))
        .toList();
  }

  // SPARA NY ANVÄNDARE
  static Future<bool> register(
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final users = await loadUsers();

    // Kolla om email redan finns
    final exists = users.any(
      (u) => u.userName.toLowerCase() == email.toLowerCase(),
    );

    if (exists) return false;

    users.add(User(email, password));

    final encoded = users
        .map((u) => jsonEncode(u.toJson()))
        .toList();

    await prefs.setStringList(_usersKey, encoded);

    return true;
  }

  // LOGIN
  static Future<bool> login(
    String email,
    String password,
  ) async {
    final users = await loadUsers();

    try {
      final user = users.firstWhere(
        (u) =>
            u.userName.toLowerCase() ==
                email.toLowerCase() &&
            u.password == password,
      );

      await saveLoggedInUser(user);

      return true;
    } catch (_) {
      return false;
    }
  }

  // SPARA AKTIV SESSION
  static Future<void> saveLoggedInUser(
    User user,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _loggedInKey,
      jsonEncode(user.toJson()),
    );
  }

  // HÄMTA AKTIV SESSION
  static Future<User?> loadLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_loggedInKey);

    if (data == null) return null;

    return User.fromJson(jsonDecode(data));
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_loggedInKey);

    await prefs.setBool(
      "keepLogged_in",
      false,
    );
  }

  // LOGIN STATUS
  static Future<bool> isLoggedIn() async {
    final user = await loadLoggedInUser();

    return user != null;
  }
}