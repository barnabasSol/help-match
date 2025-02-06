import 'package:help_match/core/current_user/model/user_cache_model.dart';
import 'package:hive_ce/hive.dart';

class UserLocalProvider {
  final Box<User> _userBox = Hive.box<User>('userBox');

  Future<void> addOrUpdateUser(User user) async {
    await _userBox.put(user.username, user);
  }

  User? getUser(String username) {
    return _userBox.get(username);
  }

  Future<void> deleteUser(String userId) async {
    await _userBox.delete(userId);
  }

  List<User> getAllUsers() {
    return _userBox.values.toList();
  }

  Future<void> clearAllUsers() async {
    await _userBox.clear();
  }
}
