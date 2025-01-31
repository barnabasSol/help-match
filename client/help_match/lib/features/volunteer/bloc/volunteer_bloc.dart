import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'volunteer_event.dart';
part 'volunteer_state.dart';

class VolunteerBloc extends Bloc<VolunteerEvent, VolunteerState> {
  VolunteerBloc() : super(VolunteerInitial()) {
    on<VolunteerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
