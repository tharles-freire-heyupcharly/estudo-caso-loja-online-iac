# Variáveis Gerais
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "loja-online"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

# Variáveis de Rede (VPC)
variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de AZs para deploy"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks para subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks para subnets privadas"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks para subnets de banco de dados"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

# Variáveis de EC2 / Auto Scaling
variable "instance_type" {
  description = "Tipo de instância EC2"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Número mínimo de instâncias no Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Número máximo de instâncias no Auto Scaling Group (CONTROLE DE CUSTO)"
  type        = number
  default     = 10
}

variable "desired_capacity" {
  description = "Capacidade desejada inicial"
  type        = number
  default     = 2
}

# Variáveis de Scaling por Horário (Sexta-feira)
variable "scale_up_recurrence" {
  description = "Cron para scale up (Sexta-feira 08:00 UTC)"
  type        = string
  default     = "0 8 * * FRI"
}

variable "scale_down_recurrence" {
  description = "Cron para scale down (Sexta-feira 23:00 UTC)"
  type        = string
  default     = "0 23 * * FRI"
}

variable "friday_desired_capacity" {
  description = "Capacidade desejada nas sextas-feiras"
  type        = number
  default     = 6
}

variable "weekend_desired_capacity" {
  description = "Capacidade desejada nos finais de semana"
  type        = number
  default     = 2
}

# Variáveis de Monitoramento
variable "cpu_target_value" {
  description = "Target de utilização de CPU para Auto Scaling (%)"
  type        = number
  default     = 70
}

variable "alarm_email" {
  description = "Email para receber alarmes do CloudWatch"
  type        = string
  default     = "admin@loja-online.com"
}

# Variáveis de Segurança
variable "allowed_ssh_cidrs" {
  description = "CIDR blocks permitidos para SSH (apenas para manutenção)"
  type        = list(string)
  default     = [] # Vazio por padrão - segurança
}

variable "enable_waf" {
  description = "Habilitar AWS WAF no CloudFront"
  type        = bool
  default     = true
}

# Variáveis de Banco de Dados
variable "db_instance_class" {
  description = "Classe da instância Aurora"
  type        = string
  default     = "db.r6g.large"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "lojaonline"
}

variable "db_username" {
  description = "Username do banco de dados (usar Secrets Manager em produção)"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_backup_retention_period" {
  description = "Período de retenção de backups (dias)"
  type        = number
  default     = 7
}

# Variáveis de Custo
variable "monthly_budget_limit" {
  description = "Limite de budget mensal em USD"
  type        = number
  default     = 1000
}

variable "budget_alert_threshold" {
  description = "Percentual do budget para enviar alerta"
  type        = number
  default     = 80
}
