# ============================================
# VPC - Virtual Private Cloud
# ============================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# ============================================
# Internet Gateway
# ============================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# ============================================
# Subnets Públicas (ALB, NAT Gateway)
# ============================================

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    Type = "Public"
    Tier = "Web"
  }
}

# ============================================
# Subnets Privadas (EC2 Instances)
# ============================================

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
    Type = "Private"
    Tier = "Application"
  }
}

# ============================================
# Subnets de Banco de Dados (Isoladas)
# ============================================

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnet-${count.index + 1}"
    Type = "Private"
    Tier = "Database"
  }
}

# ============================================
# Elastic IP para NAT Gateway
# ============================================

resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}

# ============================================
# NAT Gateway (para instâncias privadas acessarem internet)
# ============================================

resource "aws_nat_gateway" "main" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}

# ============================================
# Route Table - Public
# ============================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
    Type = "Public"
  }
}

# Associação das subnets públicas com a route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============================================
# Route Table - Private (uma por AZ para HA)
# ============================================

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-${count.index + 1}"
    Type = "Private"
  }
}

# Associação das subnets privadas com suas route tables
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ============================================
# Route Table - Database (sem acesso à internet)
# ============================================

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-database-rt"
    Type = "Private-Isolated"
  }
}

# Associação das subnets de banco de dados
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

# ============================================
# VPC Flow Logs (Segurança e Auditoria)
# Comentado para LocalStack (funcionalidade limitada)
# ============================================

# resource "aws_flow_log" "main" {
#   iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
#   log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
#   traffic_type    = "ALL"
#   vpc_id          = aws_vpc.main.id
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-vpc-flow-logs"
#   }
# }

# resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
#   name              = "/aws/vpc/${var.project_name}-${var.environment}"
#   retention_in_days = 30
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-vpc-flow-logs"
#   }
# }

# resource "aws_iam_role" "vpc_flow_logs" {
#   name = "${var.project_name}-${var.environment}-vpc-flow-logs-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "vpc-flow-logs.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-vpc-flow-logs-role"
#   }
# }

# resource "aws_iam_role_policy" "vpc_flow_logs" {
#   name = "${var.project_name}-${var.environment}-vpc-flow-logs-policy"
#   role = aws_iam_role.vpc_flow_logs.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#           "logs:DescribeLogGroups",
#           "logs:DescribeLogStreams"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# ============================================
# VPC Endpoints (Redução de custos NAT)
# Comentado para LocalStack (funcionalidade limitada)
# ============================================

# S3 VPC Endpoint (Gateway)
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.aws_region}.s3"
#
#   route_table_ids = concat(
#     [aws_route_table.public.id],
#     aws_route_table.private[*].id
#   )
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-s3-endpoint"
#   }
# }

# DynamoDB VPC Endpoint (Gateway)
# resource "aws_vpc_endpoint" "dynamodb" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.aws_region}.dynamodb"
#
#   route_table_ids = concat(
#     [aws_route_table.public.id],
#     aws_route_table.private[*].id
#   )
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-dynamodb-endpoint"
#   }
# }
