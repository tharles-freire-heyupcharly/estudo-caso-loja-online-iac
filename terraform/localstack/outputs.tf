# ============================================
# Outputs - Informações importantes da infraestrutura
# ============================================

# VPC
output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block da VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnets
output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "IDs das subnets de banco de dados"
  value       = aws_subnet.database[*].id
}

# Load Balancer - Comentado (requer LocalStack Pro)
# output "alb_dns_name" {
#   description = "DNS name do Application Load Balancer"
#   value       = aws_lb.main.dns_name
# }

# output "alb_zone_id" {
#   description = "Zone ID do ALB (para Route53)"
#   value       = aws_lb.main.zone_id
# }

# output "alb_arn" {
#   description = "ARN do Application Load Balancer"
#   value       = aws_lb.main.arn
# }

# output "alb_url" {
#   description = "URL do Application Load Balancer"
#   value       = "http://${aws_lb.main.dns_name}"
# }

# Auto Scaling - Comentado (requer LocalStack Pro)
# output "autoscaling_group_name" {
#   description = "Nome do Auto Scaling Group"
#   value       = aws_autoscaling_group.backend.name
# }

# output "autoscaling_group_arn" {
#   description = "ARN do Auto Scaling Group"
#   value       = aws_autoscaling_group.backend.arn
# }

output "launch_template_id" {
  description = "ID do Launch Template"
  value       = aws_launch_template.backend.id
}

output "launch_template_latest_version" {
  description = "Última versão do Launch Template"
  value       = aws_launch_template.backend.latest_version
}

# Security Groups
output "alb_security_group_id" {
  description = "ID do Security Group do ALB"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID do Security Group das instâncias EC2"
  value       = aws_security_group.ec2.id
}

# IAM
output "ec2_iam_role_name" {
  description = "Nome da IAM Role das instâncias EC2"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_iam_role_arn" {
  description = "ARN da IAM Role das instâncias EC2"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "Nome do Instance Profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

# S3 - Comentado (ALB logs não disponível)
# output "alb_logs_bucket_name" {
#   description = "Nome do bucket S3 para logs do ALB"
#   value       = aws_s3_bucket.alb_logs.id
# }

# output "alb_logs_bucket_arn" {
#   description = "ARN do bucket S3 para logs do ALB"
#   value       = aws_s3_bucket.alb_logs.arn
# }

# NAT Gateways
output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "IPs públicos dos NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# CloudWatch
# VPC Flow Logs comentado no LocalStack
# output "vpc_flow_logs_group_name" {
#   description = "Nome do CloudWatch Log Group para VPC Flow Logs"
#   value       = aws_cloudwatch_log_group.vpc_flow_logs.name
# }

# Account Info
output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}

# Scaling Configuration
output "scaling_configuration" {
  description = "Configuração de Auto Scaling"
  value = {
    min_size                 = var.min_size
    max_size                 = var.max_size
    desired_capacity         = var.desired_capacity
    friday_desired_capacity  = var.friday_desired_capacity
    weekend_desired_capacity = var.weekend_desired_capacity
    cpu_target               = var.cpu_target_value
  }
}

# Informações úteis para conexão e debug
output "connection_info" {
  description = "Informações de conexão"
  value = {
    note            = "ALB e Auto Scaling requerem LocalStack Pro"
    vpc_id          = aws_vpc.main.id
    private_subnets = aws_subnet.private[*].id
    public_subnets  = aws_subnet.public[*].id
    launch_template = aws_launch_template.backend.id
  }
}

output "localstack_limitations" {
  description = "Recursos comentados no LocalStack Free"
  value = {
    autoscaling_group = "Auto Scaling Group requer LocalStack Pro"
    alb               = "Application Load Balancer requer LocalStack Pro"
    target_groups     = "Target Groups requerem LocalStack Pro"
    s3_advanced       = "S3 lifecycle policies limitadas"
    vpc_flow_logs     = "VPC Flow Logs funcionalidade limitada"
    vpc_endpoints     = "VPC Endpoints funcionalidade limitada"
    note              = "Para ambiente de produção AWS, descomentar recursos no código"
  }
}

output "terraform_demonstration" {
  description = "O que este projeto demonstra (conceitos educacionais)"
  value = {
    iac                = "Infrastructure as Code com Terraform"
    networking         = "VPC com 3 camadas (pública, privada, database)"
    security           = "Security Groups e IAM Roles"
    modularity         = "Código modularizado e reutilizável"
    best_practices     = "Naming conventions, tags, outputs"
    cost_control       = "Variáveis para controle de limites (max_size, min_size)"
    scheduled_scaling  = "Código para scaling baseado em horário (comentado)"
    high_availability  = "Multi-AZ deployment strategy"
  }
}
