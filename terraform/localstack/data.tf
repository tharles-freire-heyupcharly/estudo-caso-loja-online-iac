# Data Sources - Buscar informações existentes da AWS

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Availability Zones disponíveis na região
data "aws_availability_zones" "available" {
  state = "available"
}

# Account ID atual
data "aws_caller_identity" "current" {}

# Região atual
data "aws_region" "current" {}

# ACM Certificate para CloudFront (us-east-1)
# Descomentar quando tiver um domínio configurado
# data "aws_acm_certificate" "cloudfront_cert" {
#   domain      = "*.loja-online.com"
#   statuses    = ["ISSUED"]
#   most_recent = true
#   provider    = aws.us_east_1  # CloudFront requer certificados em us-east-1
# }

# IAM Policy para EC2 assumir role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM Policy para EC2 acessar S3, CloudWatch e Secrets Manager
data "aws_iam_policy_document" "ec2_permissions" {
  # CloudWatch Logs
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ec2/*"]
  }

  # CloudWatch Metrics
  statement {
    sid    = "CloudWatchMetrics"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]

    resources = ["*"]
  }

  # S3 - Acesso ao bucket de assets estáticos (se necessário)
  statement {
    sid    = "S3Access"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.project_name}-${var.environment}-assets",
      "arn:aws:s3:::${var.project_name}-${var.environment}-assets/*"
    ]
  }

  # Secrets Manager - Acesso a credenciais do DB
  statement {
    sid    = "SecretsManagerAccess"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.environment}/db-*"
    ]
  }

  # SSM Parameter Store (alternativa ao Secrets Manager)
  statement {
    sid    = "SSMParameterAccess"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.environment}/*"
    ]
  }

  # EC2 Instance Connect (para troubleshooting seguro)
  statement {
    sid    = "EC2InstanceConnect"
    effect = "Allow"

    actions = [
      "ec2-instance-connect:SendSSHPublicKey"
    ]

    resources = ["*"]
  }

  # Systems Manager Session Manager (acesso sem SSH)
  statement {
    sid    = "SSMSessionManager"
    effect = "Allow"

    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }
}
