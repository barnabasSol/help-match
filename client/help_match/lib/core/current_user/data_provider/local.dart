import 'package:help_match/core/current_user/model/user_cache_model.dart';
import 'package:hive_ce/hive.dart';

class UserLocalProvider {
  final Box<User> _userBox = Hive.box<User>('userBox');

  Future<void> addOrUpdateUser(User user) async {
    await _userBox.put(user.id, user);
  }

  User? getUser(String id) {
    return _userBox.get(id);
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
