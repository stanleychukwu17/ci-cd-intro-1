variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "allowed_ip_address" {
  description = "I.P addresses allowed to visit the ec2 instance"
  type = list(string)
}