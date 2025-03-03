import 'package:bloc/bloc.dart';
import 'package:help_match/features/organization/dto/job_add_dto.dart';
import 'package:help_match/features/volunteer/presentation/widgets/job_card.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';
import 'package:meta/meta.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final VolunteerRepository _volunteerRepository;
  JobsBloc({required volunteerRepository})
      : _volunteerRepository = volunteerRepository,
        super(JobsInitial()) {
    on<FetchedJobs>((event, emit) async {
      try {
        emit(JobsLoading());
        final List<JobDto> jobs =
            await _volunteerRepository.getJobs(event.org_id);
        emit(JobsFetchedSuccessfully(jobs: jobs));
      } catch (e) {
        emit(JobsFetchFailed(error: e.toString()));
      }
    });
  }
}
