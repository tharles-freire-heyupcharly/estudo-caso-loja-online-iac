# 🏪 Estudo de Caso: Loja Online - Infrastructure as Code

Projeto educacional que demonstra como resolver problemas de escalabilidade e custos descontrolados usando **Infrastructure as Code (IaC)** com **Terraform** e **LocalStack** para simulação local da AWS.

**Contexto:** MBA em Cybersecurity - Cloud Computing, DevOps e DevSecOps

## 📋 Descrição

Projeto de Infrastructure as Code (IaC) usando **Terraform** para resolver o estudo de caso de uma loja online que enfrenta problemas de escalabilidade e custos elevados durante picos de tráfego.

## 🎯 Problema Original

**Cenário:** Loja online com picos de tráfego às sextas-feiras e baixa atividade nos finais de semana

Uma loja online enfrentava:

- 📈 Picos de tráfego nas **sextas-feiras** (promoções)
- 📉 Baixa atividade nos **finais de semana**
- 💸 Auto Scaling **sem limites** → **R$ 32.000/mês**
- ❌ Falta de controle e previsibilidade
- **Problema:** Auto Scaling sem limites causou custos operacionais excessivos
- **Causa:** Falta de controles de escalabilidade e otimização de infraestrutura

## ✅ Solução Implementada

Arquitetura AWS completa com foco em:

### 🔐 Segurança (DevSecOps)

- ✅ VPC isolada com 3 camadas (pública, privada, database)
- ✅ Security Groups com regras restritivas
- ✅ IAM Roles com princípio de menor privilégio
- ✅ VPC Flow Logs para auditoria
- ✅ S3 com criptografia e versionamento
- ✅ IMDSv2 obrigatório nas instâncias EC2

### 💰 Controle de Custos

- ✅ **Auto Scaling com limites** (min: 2, max: 10)
- ✅ **Scheduled Scaling** para padrões previsíveis (sextas-feiras)
- ✅ Target Tracking Policies (CPU e Request Count)
- ✅ NAT Gateway otimizado
- ✅ VPC Endpoints para reduzir custos de tráfego

### 📊 Monitoramento

- ✅ CloudWatch Metrics customizados
- ✅ CloudWatch Logs centralizados
- ✅ Health checks no ALB
- ✅ Alarmes de CPU, requests e custos

### 🏗️ Alta Disponibilidade

- ✅ Multi-AZ (3 Availability Zones)
- ✅ Application Load Balancer
- ✅ Auto Scaling Group com health checks
- ✅ Aurora PostgreSQL (preparado para multi-AZ)

**Resultado:** Redução de **60%** nos custos (R$ 12k/mês)

---

## �� Pré-requisitos

Antes de começar, você precisa ter instalado em sua máquina:

### 1️⃣ Docker & Docker Compose

Docker é necessário para executar o LocalStack.

#### 🪟 Windows

- **Docker Desktop for Windows**: https://docs.docker.com/desktop/install/windows-install/
- Requisitos: Windows 10 64-bit Pro/Enterprise/Education ou Windows 11
- Habilitar WSL 2: https://docs.microsoft.com/pt-br/windows/wsl/install

#### 🍎 macOS

- **Docker Desktop for Mac**: https://docs.docker.com/desktop/install/mac-install/
- Disponível para chips Intel e Apple Silicon (M1/M2/M3)

**Verificar instalação:**

\`\`\`bash
docker --version
docker compose version
\`\`\`

---

### 2️⃣ Terraform

Terraform é a ferramenta de IaC que usaremos para provisionar a infraestrutura.

#### 🪟 Windows

\`\`\`powershell
# Usando Chocolatey
choco install terraform

# OU baixar manualmente de: https://developer.hashicorp.com/terraform/downloads
\`\`\`

#### 🍎 macOS

\`\`\`bash
# Usando Homebrew
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
\`\`\`

**Documentação oficial**: https://developer.hashicorp.com/terraform/downloads

**Verificar instalação:**

\`\`\`bash
terraform version
\`\`\`

---

### 3️⃣ AWS CLI (Opcional, mas recomendado)

Útil para verificar recursos criados no LocalStack.

#### 🪟 Windows

Baixar instalador MSI de: https://aws.amazon.com/cli/

#### 🍎 macOS

\`\`\`bash
brew install awscli
\`\`\`

**Documentação oficial**: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

**Verificar instalação:**

\`\`\`bash
aws --version
\`\`\`

---

## 🚀 Guia de Demonstração

### Passo 1: Iniciar o LocalStack

Primeiro, navegue até o diretório do projeto e inicie o LocalStack com Docker Compose:

\`\`\`bash
# Navegar para o diretório do projeto
cd estudo-caso-loja-online-iac

# Iniciar LocalStack em background
docker compose up -d

# Verificar se o container está rodando
docker ps

# Verificar logs (opcional)
docker compose logs -f localstack

# Verificar saúde do LocalStack
curl http://localhost:4566/_localstack/health
\`\`\`

**Saída esperada**: JSON mostrando serviços disponíveis (ec2, s3, iam, etc.) com status \`"available"\` ou \`"running"\`.

---

### Passo 2: Navegar para o diretório Terraform

\`\`\`bash
cd terraform/localstack
\`\`\`

---

### Passo 3: Inicializar o Terraform

Este comando baixa os providers necessários (AWS provider):

\`\`\`bash
terraform init
\`\`\`

**Saída esperada**:
\`\`\`
Terraform has been successfully initialized!
\`\`\`

---

### Passo 4: Validar a configuração

Verifica se não há erros de sintaxe nos arquivos \`.tf\`:

\`\`\`bash
terraform validate
\`\`\`

**Saída esperada**:
\`\`\`
Success! The configuration is valid.
\`\`\`

---

### Passo 5: Planejar a infraestrutura

Mostra o que será criado SEM aplicar as mudanças:

\`\`\`bash
terraform plan
\`\`\`

**O que você verá**:
- Recursos a serem criados: VPC, Subnets, ALB, Auto Scaling Group, Security Groups, etc.
- Total de recursos: ~40-50 recursos
- **🔍 Pontos importantes**:
  - \`min_size = 2\` e \`max_size = 10\` → Controle de custos!
  - Scheduled actions para sextas-feiras
  - 3 Availability Zones para alta disponibilidade

---

### Passo 6: Aplicar a infraestrutura

Cria os recursos no LocalStack:

\`\`\`bash
terraform apply
\`\`\`

Digite \`yes\` quando solicitado.

**⏱️ Tempo estimado**: 2-5 minutos

**Saída esperada**:
\`\`\`
Apply complete! Resources: XX added, 0 changed, 0 destroyed.

Outputs:
alb_dns_name = "loja-online-alb-XXXXXXXXX.elb.localhost.localstack.cloud"
autoscaling_group_name = "loja-online-asg-XXXXXXXXX"
vpc_id = "vpc-XXXXXXXXX"
...
\`\`\`

---

### Passo 7: Verificar recursos criados (Opcional)

#### Usando AWS CLI com LocalStack:

\`\`\`bash
# Configurar alias para facilitar
alias awslocal="aws --endpoint-url=http://localhost:4566"

# Listar VPCs
awslocal ec2 describe-vpcs

# Listar Auto Scaling Groups
awslocal autoscaling describe-auto-scaling-groups

# Listar Load Balancers
awslocal elbv2 describe-load-balancers

# Listar instâncias EC2
awslocal ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' --output table
\`\`\`

---

### Passo 8: Visualizar os outputs

O Terraform exibe informações importantes após o \`apply\`:

\`\`\`bash
# Ver todos os outputs
terraform output

# Ver um output específico
terraform output alb_dns_name
terraform output autoscaling_group_name
\`\`\`

---

### Passo 9: Explorar o estado

Mostra todos os recursos gerenciados pelo Terraform:

\`\`\`bash
# Listar todos os recursos
terraform state list

# Ver detalhes de um recurso específico
terraform state show aws_autoscaling_group.main
\`\`\`

---

## 🧹 Destruir a Infraestrutura

### ⚠️ IMPORTANTE: Sempre destrua a infraestrutura ao final

\`\`\`bash
cd terraform/localstack

# Destruir todos os recursos criados pelo Terraform
terraform destroy
\`\`\`

Digite \`yes\` quando solicitado.

**Saída esperada**:
\`\`\`
Destroy complete! Resources: XX destroyed.
\`\`\`

---

### Parar o LocalStack

\`\`\`bash
# Voltar para o diretório raiz do projeto
cd ../..

# Parar e remover containers
docker compose down

# (Opcional) Remover volumes também
docker compose down -v
\`\`\`

---

## 📁 Estrutura do Projeto

\`\`\`
estudo-caso-loja-online-iac/
├── README.md                    # 👈 Você está aqui
├── docker-compose.yml           # Configuração do LocalStack
│
├── terraform/
│   └── localstack/              # Código Terraform
│       ├── provider.tf          # Configuração do provider AWS + LocalStack
│       ├── variables.tf         # Variáveis do projeto
│       ├── vpc.tf               # VPC, Subnets, Internet Gateway
│       ├── ec2.tf               # Auto Scaling, Launch Template, ALB
│       ├── data.tf              # Data sources (AMI)
│       ├── outputs.tf           # Outputs do Terraform
│       └── TERRAFORM.md         # 👈 Guia das estruturas Terraform
│
├── diagramas/                   # Diagramas de arquitetura (PNG)
│   ├── *.png                    # Diagramas gerados
│   ├── scripts/                 # Scripts Python para gerar diagramas
│   ├── README.md                # Índice dos diagramas
│   └── DIAGRAMS.md              # 👈 Documentação de geração
│
└── apresentacao/                # Apresentação PowerPoint
    ├── gerar-apresentacao.py    # Script para gerar PPT
    └── *.pptx                   # Apresentações geradas
\`\`\`

---

## 🎯 Objetivo do Projeto

### Problema Original:

- Loja online com **picos de tráfego nas sextas-feiras**
- Auto Scaling **sem limites** → Custos dispararam para **R$ 32.000/mês**
- Falta de controle e previsibilidade

### Solução com Terraform:

✅ **Controle de custos**: \`max_size = 10\` limita número de instâncias  
✅ **Escalabilidade programada**: Scale up automático sextas às 08:00  
✅ **Alta disponibilidade**: 3 Availability Zones  
✅ **Segurança**: Security Groups, subnets privadas  
✅ **Infraestrutura como Código**: Versionável, reproduzível, auditável  

### Resultado:

- **Redução de 60% nos custos** (de R$ 32k para R$ 12k/mês)
- **Infraestrutura previsível e controlada**
- **Deploy reproduzível em minutos**

---

## 🆘 Troubleshooting

### LocalStack não inicia

\`\`\`bash
# Verificar logs
docker compose logs localstack

# Reiniciar
docker compose down
docker compose up -d
\`\`\`

### Terraform não conecta ao LocalStack

\`\`\`bash
# Verificar se LocalStack está rodando
curl http://localhost:4566/_localstack/health

# Verificar porta 4566 está livre
lsof -i :4566  # macOS
netstat -ano | findstr :4566  # Windows
\`\`\`

### Erro "Error acquiring the state lock"

\`\`\`bash
# Forçar desbloqueio (use com cuidado!)
terraform force-unlock <LOCK_ID>
\`\`\`

---

## 📚 Recursos Adicionais

- **Terraform Documentation**: https://developer.hashicorp.com/terraform/docs
- **LocalStack Documentation**: https://docs.localstack.cloud/
- **AWS Documentation**: https://docs.aws.amazon.com/
- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

---

## 👨‍🏫 Sobre este Projeto

Este é um projeto educacional desenvolvido para o curso de **MBA em Cybersecurity - Governance & Management**, disciplina **Cloud Computing, DevOps e DevSecOps**.

**Professor**: Tharles Maicon Freire dos Santos  
**Email**: tharles.freire@heyupcharly.com.br

---

## 📄 Licença

Copyright © 2024 Prof. Tharles Maicon Freire dos Santos

Todos os direitos reservados. Reprodução ou divulgação total ou parcial deste projeto é expressamente proibida sem o consentimento formal, por escrito, do Professor (autor).

---

**🎯 Objetivo:** Demonstrar Infrastructure as Code com Terraform e conceitos de DevSecOps usando LocalStack para simulação local sem custos AWS.
