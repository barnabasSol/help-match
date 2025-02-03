import 'package:flutter_bloc/flutter_bloc.dart';

part 'volunteer_event.dart';
part 'volunteer_state.dart';

class VolunteerBloc extends Bloc<VolunteerEvent, VolunteerState> {
  VolunteerBloc() : super(VolunteerInitial()) {
    on<VolunteerEvent>((event, emit) {});
  }
}
