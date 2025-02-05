  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/Auth/dto/signup_dto.dart';
import 'package:latlong2/latlong.dart';

class SignUpUserCubit extends Cubit<UserSignUpDto> {
  SignUpUserCubit() : super(UserSignUpDto(name: '', userName: '', email: '', password: '', interests: [],));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }
    void updateUserName(String name) {
    emit(state.copyWith(userName: name));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateInterests(List<String> interests) {
    emit(state.copyWith(interests: interests));
  }
}
class SignUpOrgCubit extends Cubit<OrgSignUpDto> {
  SignUpOrgCubit() : super(OrgSignUpDto(name: '', email: '', password: '',  orgname: '', description: '', type: '', username: '',));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }
    void updateUserName(String name) {
    emit(state.copyWith(username: name));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateLocation(LatLng loc) {
    emit(state.copyWith(location: loc));
  }

  
  void updateOrgName(String name) {
    emit(state.copyWith(orgname: name));
  }
  
  void updateDesc(String desc) {
    emit(state.copyWith(desc: desc));
  }
  void updateType(String type) {
    emit(state.copyWith(type: type));
  }
}
