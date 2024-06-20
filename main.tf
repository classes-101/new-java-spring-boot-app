provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_role_policies" {
  count      = 3
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = element([
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  ], count.index)
}

resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-role"
  role = aws_iam_role.beanstalk_ec2_role.name
}

resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket
  acl    = "private"
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = var.app_name
  description = "An example Elastic Beanstalk application"
}

resource "aws_elastic_beanstalk_application_version" "example" {
  name        = var.app_version
  application = aws_elastic_beanstalk_application.example.name
  bucket      = aws_s3_bucket.example.bucket
  key         = var.s3_key
  description = "Version ${var.app_version} of my application"
  depends_on  = [aws_s3_bucket.example]
}

resource "aws_elastic_beanstalk_environment" "example" {
  name                = var.env_name
  application         = aws_elastic_beanstalk_application.example.name
  version_label       = aws_elastic_beanstalk_application_version.example.name
  solution_stack_name = var.solution_stack

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "GRADLE_HOME"
    value     = var.gradle_home
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "M2"
    value     = var.m2
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "M2_HOME"
    value     = var.m2_home
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = var.port
  }

}
