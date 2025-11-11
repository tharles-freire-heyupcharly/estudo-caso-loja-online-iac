# 🏗️ Guia Terraform - Estruturas e Conceitos

Este documento explica as estruturas do Terraform usadas no projeto, com exemplos práticos dos arquivos de configuração.

---

## 📖 Conceitos Básicos

### O que é Terraform?

**Terraform** é uma ferramenta de **Infrastructure as Code (IaC)** que permite definir, provisionar e gerenciar infraestrutura usando código declarativo.

**Vantagens:**
- ✅ **Versionável** - Git
- ✅ **Reproduzível** - Mesma infra em dev/staging/prod
- ✅ **Auditável** - Histórico de mudanças
- ✅ **Colaborativo** - Equipe trabalha no mesmo código

### Fluxo de Trabalho

```
1. WRITE    → Escrever código .tf
2. INIT     → terraform init (baixar providers)
3. PLAN     → terraform plan (ver mudanças)
4. APPLY    → terraform apply (criar recursos)
5. DESTROY  → terraform destroy (deletar tudo)
```

---

## 📁 Estrutura de Arquivos

```
terraform/localstack/
├── provider.tf      # Configuração AWS + LocalStack
├── variables.tf     # Declaração de variáveis
├── vpc.tf           # VPC, Subnets, IGW, NAT
├── ec2.tf           # EC2, ALB, Auto Scaling
├── data.tf          # Data sources (AMI, IAM)
├── outputs.tf       # Outputs (VPC ID, ALB DNS)
└── terraform.tfstate  # Estado (NÃO editar manualmente!)
```

**Por que separar?**
- ✅ Fácil encontrar recursos específicos
- ✅ Modificar sem afetar outros arquivos
- ✅ Múltiplos devs editando simultaneamente

> Terraform lê **todos os `.tf`** no diretório (ordem não importa)

---

## 🔌 Provider

**Arquivo:** `provider.tf`

Um **provider** é um plugin que permite Terraform interagir com APIs (AWS, Azure, GCP, etc).

### Exemplo: AWS + LocalStack

```terraform
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # 5.x
    }
  }
}

provider "aws" {
  region = var.aws_region  # us-east-1

  # Endpoints LocalStack (redireciona para localhost)
  endpoints {
    ec2     = "http://localhost:4566"
    s3      = "http://localhost:4566"
    iam     = "http://localhost:4566"
  }

  # Credenciais fake (LocalStack não valida)
  access_key = "test"
  secret_key = "test"
  skip_credentials_validation = true

  # Tags padrão em TODOS os recursos
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
```

---

## 📥 Variables

**Arquivo:** `variables.tf`

Variables parametrizam a infraestrutura. Evita valores hardcoded.

### Estrutura

```terraform
variable "nome" {
  description = "Descrição"
  type        = string  # ou number, bool, list, map
  default     = "valor_padrao"
  
  validation {
    condition     = <expressão booleana>
    error_message = "Mensagem de erro"
  }
}
```

### Exemplos do Projeto

#### 1. String

```terraform
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "loja-online"
}
```

**Uso:**
```terraform
resource "aws_vpc" "main" {
  tags = {
    Name = "${var.project_name}-vpc"  # loja-online-vpc
  }
}
```

---

#### 2. Number

```terraform
variable "max_size" {
  description = "Máximo de instâncias (CONTROLE DE CUSTOS)"
  type        = number
  default     = 10
}
```

**Uso:**
```terraform
resource "aws_autoscaling_group" "main" {
  max_size = var.max_size  # 10
}
```

**⚠️ CRÍTICO:** Esta variável resolve o problema de custos!
- Antes: Sem limite → Centenas de instâncias → R$ 32k/mês
- Depois: `max_size = 10` → Controlado → R$ 12k/mês

---

#### 3. List

```terraform
variable "availability_zones" {
  description = "Lista de AZs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```

**Uso:**
```terraform
resource "aws_subnet" "public" {
  count = length(var.availability_zones)  # 3
  
  availability_zone = var.availability_zones[count.index]
  # count.index = 0, 1, 2
}
```

---

#### 4. Com Validação

```terraform
variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "prod"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Deve ser dev, staging ou prod."
  }
}
```

---

### Sobrescrever Valores

```bash
# Opção 1: Flag
terraform apply -var="max_size=20"

# Opção 2: Arquivo terraform.tfvars
echo 'max_size = 20' > terraform.tfvars
terraform apply

# Opção 3: Variável de ambiente
export TF_VAR_max_size=20
terraform apply
```

---

## 🏗️ Resources

**Arquivos:** `vpc.tf`, `ec2.tf`

Um **resource** é um componente de infraestrutura que Terraform **cria e gerencia**.

### Estrutura

```terraform
resource "tipo" "nome_local" {
  argumento1 = "valor1"
  argumento2 = "valor2"
  
  bloco {
    propriedade = "valor"
  }
}
```

---

### Exemplo 1: VPC

```terraform
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr  # 10.0.0.0/16
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
```

**Referência:**
```terraform
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id  # Usa a VPC criada acima
}
```

---

### Exemplo 2: Subnets com Count

```terraform
variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)  # 3

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}
```

**Resultado:**
```
Subnet 1: 10.0.1.0/24 em us-east-1a
Subnet 2: 10.0.2.0/24 em us-east-1b
Subnet 3: 10.0.3.0/24 em us-east-1c
```

---

### Exemplo 3: Auto Scaling Group

```terraform
resource "aws_autoscaling_group" "main" {
  name                = "${var.project_name}-asg"
  vpc_zone_identifier = aws_subnet.private[*].id
  
  min_size         = var.min_size          # 2 (custo mínimo)
  max_size         = var.max_size          # 10 (CUSTO MÁXIMO!)
  desired_capacity = var.desired_capacity  # 2
  
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  
  target_group_arns = [aws_lb_target_group.main.arn]
  
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.project_name}-instance"
    propagate_at_launch = true
  }
}
```

**Explicação:**
- `min_size`, `max_size` → **CONTROLE DE CUSTOS!**
- `aws_subnet.private[*].id` → `[*]` pega todos os IDs
- `health_check_type = "ELB"` → ALB substitui instâncias unhealthy

---

### Exemplo 4: Scheduled Scaling

```terraform
# Scale UP - Sexta 08:00
resource "aws_autoscaling_schedule" "scale_up_friday" {
  scheduled_action_name  = "${var.project_name}-scale-up-friday"
  autoscaling_group_name = aws_autoscaling_group.main.name
  
  recurrence       = "0 8 * * FRI"  # Cron
  desired_capacity = 6
}

# Scale DOWN - Sexta 23:00
resource "aws_autoscaling_schedule" "scale_down_friday" {
  scheduled_action_name  = "${var.project_name}-scale-down-friday"
  autoscaling_group_name = aws_autoscaling_group.main.name
  
  recurrence       = "0 23 * * FRI"
  desired_capacity = 2
}
```

**Problema resolvido:** Picos previsíveis nas sextas-feiras
- 08:00 → Aumenta para 6 instâncias (antes do pico)
- 23:00 → Reduz para 2 instâncias (economia)

---

### Exemplo 5: Security Group

```terraform
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group para ALB"
  vpc_id      = aws_vpc.main.id

  # ENTRADA - HTTP
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SAÍDA - Permitir tudo
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}
```

---

## 📚 Data Sources

**Arquivo:** `data.tf`

Um **data source** busca informações **existentes** (não cria recursos novos).

**Diferença:**
- **Resource:** "Crie uma VPC"
- **Data Source:** "Busque informações sobre VPCs existentes"

---

### Exemplo 1: AMI mais recente

```terraform
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
```

**Uso:**
```terraform
resource "aws_launch_template" "main" {
  image_id = data.aws_ami.amazon_linux_2023.id
}
```

**Por quê?**
- ✅ Sempre usa AMI mais recente (patches de segurança)
- ✅ Não precisa hardcoded AMI ID

---

### Exemplo 2: Availability Zones

```terraform
data "aws_availability_zones" "available" {
  state = "available"
}
```

**Uso:**
```terraform
availability_zone = data.aws_availability_zones.available.names[0]
```

---

### Exemplo 3: IAM Policy Document

```terraform
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
```

**Uso:**
```terraform
resource "aws_iam_role" "ec2_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
```

**Por quê?**
- ✅ Mais legível que JSON
- ✅ Terraform valida estrutura

---

## 📤 Outputs

**Arquivo:** `outputs.tf`

Outputs exibem informações após `terraform apply`.

### Estrutura

```terraform
output "nome" {
  description = "Descrição"
  value       = <expressão>
  sensitive   = false  # true = não exibe (senhas)
}
```

### Exemplos

```terraform
# VPC ID
output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

# Lista de IDs
output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

# ALB DNS
output "alb_dns_name" {
  description = "DNS do ALB"
  value       = aws_lb.main.dns_name
}

# URL completa
output "alb_url" {
  description = "URL do ALB"
  value       = "http://${aws_lb.main.dns_name}"
}
```

### Uso

```bash
# Ver todos
terraform output

# Ver específico
terraform output vpc_id

# JSON (para scripts)
terraform output -json
```

---

## 🔄 Meta-Arguments

Meta-arguments funcionam com **qualquer** resource.

### 1. count - Múltiplos recursos

```terraform
resource "aws_subnet" "public" {
  count = 3

  cidr_block = var.public_subnet_cidrs[count.index]
}
```

**Referência:**
```terraform
aws_subnet.public[0].id  # Primeira
aws_subnet.public[*].id  # Todas (lista)
```

---

### 2. for_each - Map/Set

```terraform
variable "environments" {
  default = {
    dev  = "10.0.0.0/16"
    prod = "10.2.0.0/16"
  }
}

resource "aws_vpc" "envs" {
  for_each = var.environments

  cidr_block = each.value

  tags = {
    Name = "vpc-${each.key}"
  }
}
```

---

### 3. depends_on - Controlar ordem

```terraform
resource "aws_instance" "app" {
  # ...
  
  depends_on = [aws_db_instance.main]
}
```

---

### 4. lifecycle

```terraform
resource "aws_instance" "app" {
  # ...
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags]
  }
}
```

---

### 5. dynamic - Blocos condicionais

```terraform
variable "allowed_ssh_cidrs" {
  default = []
}

resource "aws_security_group" "ec2" {
  # ...
  
  dynamic "ingress" {
    for_each = length(var.allowed_ssh_cidrs) > 0 ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
    }
  }
}
```

---

## ✅ Boas Práticas

### 1. Nomenclatura

```terraform
# ✅ BOM
resource "aws_vpc" "main" { }
resource "aws_subnet" "public" { }

# ❌ RUIM
resource "aws_vpc" "vpc1" { }
```

---

### 2. Tags Consistentes

```terraform
# Provider
provider "aws" {
  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}

# Resource
resource "aws_vpc" "main" {
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
```

---

### 3. Variáveis, não Hardcoded

```terraform
# ❌ RUIM
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# ✅ BOM
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}
```

---

### 4. Comentários

```terraform
# Auto Scaling com controle de custos
# min=2, max=10 previne escalação ilimitada
resource "aws_autoscaling_group" "main" {
  min_size = var.min_size  # Custo mínimo
  max_size = var.max_size  # CRÍTICO!
}
```

---

### 5. Validação

```terraform
variable "environment" {
  type    = string
  default = "prod"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Deve ser dev, staging ou prod."
  }
}
```

---

## 📝 Comandos Essenciais

```bash
# Inicializar
terraform init

# Validar
terraform validate

# Formatar
terraform fmt

# Planejar
terraform plan

# Aplicar
terraform apply
terraform apply -auto-approve  # CI/CD

# Destruir
terraform destroy

# Estado
terraform show
terraform state list
terraform state show aws_vpc.main

# Outputs
terraform output
terraform output vpc_id
```

---

## 🎯 Resumo do Projeto

### Problema:
Auto Scaling **sem limites** → R$ 32.000/mês

### Solução:
```terraform
resource "aws_autoscaling_group" "main" {
  min_size = 2   # Mínimo controlado
  max_size = 10  # LIMITE MÁXIMO!
}

resource "aws_autoscaling_schedule" "scale_up_friday" {
  recurrence       = "0 8 * * FRI"
  desired_capacity = 6
}
```

### Resultado:
- ✅ Redução 60% nos custos (R$ 12k/mês)
- ✅ Infraestrutura versionada
- ✅ Escalabilidade controlada

---

## 📚 Recursos Adicionais

- **Terraform Docs:** https://developer.hashicorp.com/terraform/docs
- **AWS Provider:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **Best Practices:** https://www.terraform-best-practices.com/
- **HashiCorp Learn:** https://developer.hashicorp.com/terraform/tutorials

---

## 👨‍🏫 Sobre

**MBA em Cybersecurity - Governance & Management**

**Professor:** Tharles Maicon Freire dos Santos  
**Email:** tharles.freire@heyupcharly.com.br
