import 'package:help_match/core/current_user/data_provider/local.dart';
import 'package:help_match/core/current_user/data_provider/user_remote.dart';
import 'package:help_match/core/current_user/model/user_cache_model.dart';

class UserRepo {
  final UserInfoRemoteProvider userRemote;
  final UserLocalProvider userLocal;

  UserRepo(this.userRemote, this.userLocal);

  Future<User?> getUserById(
    String userId,
  ) async {
    final cachedUser = userLocal.getUser(userId);
    if (cachedUser != null) {
      return cachedUser;
    }
    try {
      final user = await userRemote.fetchCurrentUser(userId);
      if (user != null) {
        await userLocal.addOrUpdateUser(user);
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
