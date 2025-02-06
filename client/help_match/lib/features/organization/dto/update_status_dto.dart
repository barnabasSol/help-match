class UpdateStatusDto {
  final String jobId;
  //as userId is going to be modified later dont' make it final
   String userId;
  final String status;

  UpdateStatusDto(
      {required this.jobId, required this.userId, required this.status });

  Map<String, String> toJson() {
    return {'job_id': jobId, 'status': status, 'user_id': userId};
  }
}
