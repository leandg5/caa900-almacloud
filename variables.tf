variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ALMA Cloud"
}

variable "team_name" {
  description = "Team name"
  type        = string
  default     = "ALMA Cloud"
}

variable "lab_role_arn" {
  description = "Learner Lab IAM Role ARN"
  type        = string
  default     = "arn:aws:iam::012906612629:role/LabRole"
}