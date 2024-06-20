variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "s3_bucket" {
  description = "The S3 bucket to store the application JAR file"
  type        = string
}

variable "app_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
}

variable "env_name" {
  description = "The name of the Elastic Beanstalk environment"
  type        = string
}

variable "solution_stack" {
  description = "The Elastic Beanstalk solution stack"
  type        = string
  default     = "64bit Amazon Linux 2 v3.1.1 running Corretto 11"
}

variable "gradle_home" {
  description = "GRADLE_HOME environment variable"
  type        = string
  default     = "/usr/local/gradle"
}

variable "m2" {
  description = "M2 environment variable"
  type        = string
  default     = "/usr/local/apache-maven/bin"
}

variable "m2_home" {
  description = "M2_HOME environment variable"
  type        = string
  default     = "/usr/local/apache-maven"
}

variable "port" {
  description = "PORT environment variable"
  type        = string
  default     = "8080"
}

variable "app_version" {
  description = "The version label of the Elastic Beanstalk application"
  type        = string
}

variable "s3_key" {
  description = "The S3 key (path) to the application JAR file"
  type        = string
}
