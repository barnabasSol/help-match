package service

const (
	Accepted = "accepted"
	Rejected = "rejected"
	Pending  = "pending"
	Finished = "finished"
)

func notificationMessageFromStatus(status string) string {
	switch status {
	case "pending":
		return "Your application is pending"
	case "accepted":
		return "Congratulations, you have been accepted for this job"
	case "rejected":
		return "Unfortunaltey, you have been rejected for this job, go fuck yourself"
	case "finished":
		return "You have successfully completed "
	default:
		return ""
	}
}
