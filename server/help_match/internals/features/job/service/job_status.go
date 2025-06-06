package service

import "fmt"

const (
	Accepted = "accepted"
	Rejected = "rejected"
	Pending  = "pending"
	Finished = "finished"
)

func notificationMessageFromStatus(jobName, orgName, status string) string {
	switch status {
	case Pending:
		return "Your application is pending"
	case Accepted:
		return fmt.Sprintf("Congratulations, you have been accepted for %s job at %s", jobName, orgName)
	case Rejected:
		return fmt.Sprintf("Unfortunaltey, you have not been accepted for the %s job at %s", jobName, orgName)
	case Finished:
		return "You have successfully completed "
	default:
		return ""
	}
}
