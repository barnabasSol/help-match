import 'package:help_match/features/Auth/data_provider/remote/auth_remote.dart';
import 'package:help_match/features/Auth/dto/login_dto.dart';
import 'package:help_match/features/Auth/dto/signup_dto.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider;
  AuthRepository(this.authDataProvider);
  Future<dynamic> signIn(LoginDTO login) async {
    try {
      final response = await authDataProvider.login(login.toJson());
        return response["data"] ;
    } catch (e) {
      rethrow;
    }
  }

   Future<dynamic> signUpUser(UserSignUpDto dto) async {
    try {
      final response = await authDataProvider.signUp(dto.toMap());
        return response["data"]["tokens"] ;
    } catch (e) {
      rethrow;
    }
  }
   Future<dynamic> signUpOrg(OrgSignUpDto dto) async {
    try {
      final response = await authDataProvider.signUp(dto.toMap());
      return response["data"]["tokens"];
    } catch (e) {
      rethrow;
    }
  }
}
