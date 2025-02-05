import 'package:help_match/features/Auth/data_provider/remote/auth_remote.dart';
import 'package:help_match/features/Auth/dto/login_dto.dart';
import 'package:help_match/features/Auth/dto/signup_dto.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider;
  AuthRepository(this.authDataProvider);
  Future<String> signIn(LoginDTO login) async {
    try {
      final response = await authDataProvider.login(login.toJson());
        return response["data"]["access_token"];
    } catch (e) {
      rethrow;
    }
  }

   Future<String> signUpUser(UserSignUpDto dto) async {
    try {
      final response = await authDataProvider.signUp(dto.toMap());
        return response["data"]["tokens"]["access_token"];
    } catch (e) {
      rethrow;
    }
  }
   Future<String> signUpOrg(OrgSignUpDto dto) async {
    try {
      final response = await authDataProvider.signUp(dto.toMap());
        return response["data"]["tokens"]["access_token"];
    } catch (e) {
      rethrow;
    }
  }
}
