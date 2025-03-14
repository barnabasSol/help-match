import 'package:bloc/bloc.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';
import 'package:meta/meta.dart';

part 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  List<String> jobIds = [];
  final VolunteerRepository _volunteerRepository;
  JobCubit({required volunteerRepository})
      : _volunteerRepository = volunteerRepository,
        super(JobInitial());

  Future<void> applyJob(String job_id) async {
    try {
      if (jobIds.contains(job_id)) return;
      jobIds.add(job_id);
      await _volunteerRepository.applyJob(job_id);
      emit(JobsAppliedSuccessfully(job_ids: jobIds));
    } catch (e) {
      emit(JobApplicationFailed(error: e.toString()));
    }
  }
}
