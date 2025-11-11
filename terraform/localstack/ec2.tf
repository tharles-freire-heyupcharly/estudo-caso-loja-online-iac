# ============================================
# Security Groups
# ============================================

# Security Group para Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group para Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Inbound HTTP
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTPS
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - permitir tudo
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# Security Group para EC2 Instances (Backend)
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security group para instancias EC2 do backend"
  vpc_id      = aws_vpc.main.id

  # Inbound do ALB na porta da aplicação (Node.js)
  ingress {
    description     = "Application port from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Inbound SSH (apenas de IPs específicos - se configurado)
  dynamic "ingress" {
    for_each = length(var.allowed_ssh_cidrs) > 0 ? [1] : []
    content {
      description = "SSH from allowed IPs"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
    }
  }

  # Outbound - permitir tudo
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  }
}

# ============================================
# IAM Role para EC2 Instances
# ============================================

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-${var.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name   = "${var.project_name}-${var.environment}-ec2-policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ec2_permissions.json
}

# Anexar policy managed da AWS para SSM
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-profile"
  }
}

# ============================================
# Launch Template
# ============================================

resource "aws_launch_template" "backend" {
  name_prefix   = "${var.project_name}-${var.environment}-backend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ec2.id]

  # User data para inicializar a aplicação
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    
    # Variáveis
    PROJECT_NAME="${var.project_name}"
    ENVIRONMENT="${var.environment}"
    AWS_REGION="${var.aws_region}"
    
    # Atualizar sistema
    dnf update -y
    
    # Instalar dependências
    dnf install -y git curl wget unzip amazon-cloudwatch-agent jq
    
    # Instalar Node.js 20.x
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    dnf install -y nodejs
    
    # Instalar PM2
    npm install -g pm2
    
    # Criar usuário da aplicação
    useradd -r -s /bin/false -d /opt/app appuser || true
    
    # Criar estrutura de diretórios
    mkdir -p /opt/app /var/log/app
    chown -R appuser:appuser /opt/app /var/log/app
    
    # Criar aplicação Node.js
    cat > /opt/app/package.json <<'PACKAGE'
{
  "name": "loja-online-backend",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2"
  }
}
PACKAGE
    
    cat > /opt/app/server.js <<'SERVER'
const express = require('express');
const os = require('os');
const app = express();
const PORT = process.env.PORT || 3000;

app.use((req, res, next) => {
  console.log(`$${new Date().toISOString()} - $${req.method} $${req.url}`);
  next();
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    hostname: os.hostname(),
    uptime: process.uptime()
  });
});

app.get('/', (req, res) => {
  res.json({
    message: 'Loja Online - Backend API',
    version: '1.0.0',
    instance: os.hostname(),
    environment: process.env.ENVIRONMENT || 'development'
  });
});

app.get('/api/products', (req, res) => {
  res.json({
    products: [
      { id: 1, name: 'Produto 1', price: 99.99 },
      { id: 2, name: 'Produto 2', price: 149.99 },
      { id: 3, name: 'Produto 3', price: 199.99 }
    ],
    instance: os.hostname()
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port $${PORT}`);
});
SERVER
    
    # Instalar dependências
    cd /opt/app
    npm install
    chown -R appuser:appuser /opt/app
    
    # Configurar PM2
    cat > /opt/app/ecosystem.config.js <<PMCONFIG
module.exports = {
  apps: [{
    name: 'loja-online-backend',
    script: './server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000,
      ENVIRONMENT: '$ENVIRONMENT'
    },
    error_file: '/var/log/app/error.log',
    out_file: '/var/log/app/out.log',
    max_memory_restart: '1G'
  }]
};
PMCONFIG
    
    # Configurar CloudWatch Agent
    cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<CWCONFIG
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/app/out.log",
            "log_group_name": "/aws/ec2/$PROJECT_NAME-$ENVIRONMENT/application",
            "log_stream_name": "{instance_id}/out.log"
          },
          {
            "file_path": "/var/log/app/error.log",
            "log_group_name": "/aws/ec2/$PROJECT_NAME-$ENVIRONMENT/application",
            "log_stream_name": "{instance_id}/error.log"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "$PROJECT_NAME/$ENVIRONMENT",
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_iowait"],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      }
    }
  }
}
CWCONFIG
    
    # Iniciar CloudWatch Agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config -m ec2 -s \
        -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json
    
    # Iniciar aplicação
    su - appuser -s /bin/bash -c "cd /opt/app && pm2 start ecosystem.config.js"
    env PATH=$PATH:/usr/bin pm2 startup systemd -u appuser --hp /opt/app
    su - appuser -s /bin/bash -c "cd /opt/app && pm2 save"
    
    echo "Instance initialization completed!"
  EOF
  )

  # Monitoramento detalhado habilitado
  monitoring {
    enabled = true
  }

  # Proteção contra terminação acidental
  disable_api_termination = false

  # EBS otimizado
  ebs_optimized = true

  # Configuração do disco root
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
    }
  }

  # Metadata options (segurança IMDSv2)
  # Comentado para LocalStack
  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = 1
  #   instance_metadata_tags      = "enabled"
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-backend-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "${var.project_name}-${var.environment}-backend-volume"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-lt"
  }
}

# ============================================
# Application Load Balancer
# NOTA: ALB requer LocalStack Pro - comentado para versão gratuita
# Em produção AWS, descomentar este bloco
# ============================================

# resource "aws_lb" "main" {
#   name               = "${var.project_name}-${var.environment}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets            = aws_subnet.public[*].id
#
#   enable_deletion_protection = false
#   enable_http2               = true
#   enable_cross_zone_load_balancing = true
#
#   drop_invalid_header_fields = true
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-alb"
#   }
# }

# Target Group
# resource "aws_lb_target_group" "backend" {
#   name     = "${var.project_name}-${var.environment}-backend-tg"
#   port     = 3000
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
#
#   health_check {
#     enabled             = true
#     healthy_threshold   = 2
#     unhealthy_threshold = 3
#     timeout             = 5
#     interval            = 30
#     path                = "/health"
#     protocol            = "HTTP"
#     matcher             = "200"
#   }
#
#   deregistration_delay = 30
#
#   stickiness {
#     type            = "lb_cookie"
#     cookie_duration = 86400
#     enabled         = true
#   }
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-backend-tg"
#   }
# }

# Listener HTTP (redirecionar para HTTPS em produção)
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "80"
#   protocol          = "HTTP"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend.arn
#   }
# }

# ============================================
# Auto Scaling Group
# NOTA: Auto Scaling Group requer LocalStack Pro
# Para demonstração educacional, veja a configuração completa
# Em produção AWS, descomentar este bloco
# ============================================

# resource "aws_autoscaling_group" "backend" {
#   name                = "${var.project_name}-${var.environment}-backend-asg"
#   vpc_zone_identifier = aws_subnet.private[*].id
#
#   min_size         = var.min_size
#   max_size         = var.max_size # CONTROLE DE CUSTO - LIMITE MÁXIMO
#   desired_capacity = var.desired_capacity
#
#   health_check_type         = "EC2" # Alterado de ELB para EC2 (sem ALB)
#   health_check_grace_period = 300
#   force_delete              = false
#   wait_for_capacity_timeout = "10m"
#
#   enabled_metrics = [
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupMaxSize",
#     "GroupMinSize",
#     "GroupPendingInstances",
#     "GroupStandbyInstances",
#     "GroupTerminatingInstances",
#     "GroupTotalInstances"
#   ]
#
#   launch_template {
#     id      = aws_launch_template.backend.id
#     version = "$Latest"
#   }
#
#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 50
#     }
#   }
#
#   tag {
#     key                 = "Name"
#     value               = "${var.project_name}-${var.environment}-backend-asg"
#     propagate_at_launch = true
#   }
#
#   tag {
#     key                 = "Environment"
#     value               = var.environment
#     propagate_at_launch = true
#   }
#
#   tag {
#     key                 = "ManagedBy"
#     value               = "Terraform"
#     propagate_at_launch = true
#   }
# }

# ============================================
# Auto Scaling Policies
# NOTA: Requer Auto Scaling Group (LocalStack Pro)
# ============================================

# Target Tracking Scaling Policy - CPU
# resource "aws_autoscaling_policy" "cpu_target" {
#   name                   = "${var.project_name}-${var.environment}-cpu-target"
#   autoscaling_group_name = aws_autoscaling_group.backend.name
#   policy_type            = "TargetTrackingScaling"
#
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#
#     target_value = var.cpu_target_value
#   }
# }

# Target Tracking Scaling Policy - Request Count
# Comentado - requer ALB que não está disponível no LocalStack Free
# resource "aws_autoscaling_policy" "request_count_target" {
#   name                   = "${var.project_name}-${var.environment}-request-count-target"
#   autoscaling_group_name = aws_autoscaling_group.backend.name
#   policy_type            = "TargetTrackingScaling"
#
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       resource_label         = "${aws_lb.main.arn_suffix}/${aws_lb_target_group.backend.arn_suffix}"
#     }
#
#     target_value = 1000.0  # 1000 requests por instância
#   }
# }

# ============================================
# Scheduled Scaling (Sextas-feiras)
# NOTA: Requer Auto Scaling Group (LocalStack Pro)
# ============================================

# Scale UP - Sexta-feira manhã
# resource "aws_autoscaling_schedule" "scale_up_friday" {
#   scheduled_action_name  = "${var.project_name}-${var.environment}-scale-up-friday"
#   autoscaling_group_name = aws_autoscaling_group.backend.name
#   recurrence             = var.scale_up_recurrence
#   desired_capacity       = var.friday_desired_capacity
#   min_size               = var.min_size
#   max_size               = var.max_size
# }

# Scale DOWN - Sexta-feira noite
# resource "aws_autoscaling_schedule" "scale_down_friday" {
#   scheduled_action_name  = "${var.project_name}-${var.environment}-scale-down-friday"
#   autoscaling_group_name = aws_autoscaling_group.backend.name
#   recurrence             = var.scale_down_recurrence
#   desired_capacity       = var.weekend_desired_capacity
#   min_size               = var.min_size
#   max_size               = var.max_size
# }

# ============================================
# S3 Bucket para ALB Logs
# Comentado - ALB não disponível no LocalStack Free
# ============================================

# resource "aws_s3_bucket" "alb_logs" {
#   bucket = "${var.project_name}-${var.environment}-alb-logs"
#
#   tags = {
#     Name = "${var.project_name}-${var.environment}-alb-logs"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "alb_logs" {
#   bucket = aws_s3_bucket.alb_logs.id
#
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }
