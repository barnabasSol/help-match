sealed class ApplicantState{
}
class InitialState extends ApplicantState{
}
class UpdateStatusFailed extends ApplicantState {
  String error;
  UpdateStatusFailed(this.error);
}

class UpdateStatusSuccessful extends ApplicantState {
  final String status;
  UpdateStatusSuccessful({required this.status});
}
