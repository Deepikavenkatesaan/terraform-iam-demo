variable "iam_users" {
  description = "IAM users and their cb-auth groups"
  type        = map(list(string))
  default     = {}
}
