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
	case "pending":
		return "Your application is pending"
	case "accepted":
		return fmt.Sprintf("Congratulations, you have been accepted for %s job at %s", jobName, orgName)
	case "rejected":
		return fmt.Sprintf("Unfortunaltey, you have not been accepted for the %s job at %s, go fuck yourself kindly", jobName, orgName)
	case "finished":
		return "You have successfully completed "
	default:
		return ""
	}
}
