# 🏪 Estudo de Caso: Loja Online - Terraform + LocalStack# 🏪 Estudo de Caso: Loja Online - Terraform + LocalStack# 🏪 Estudo de Caso: Loja Online com Terraform + LocalStack# Estudo de Caso: Loja Online - Infrastructure as Code



Projeto educacional que demonstra como resolver problemas de escalabilidade e custos descontrolados usando **Infrastructure as Code (IaC)** com Terraform e LocalStack.



## 🎯 O ProblemaProjeto educacional que demonstra como resolver problemas de escalabilidade e custos descontrolados usando **Infrastructure as Code (IaC)** com Terraform e LocalStack.



Uma loja online enfrentava:

- 📈 Picos de tráfego nas **sextas-feiras** (promoções)

- 📉 Baixa atividade nos **finais de semana**## 🎯 O ProblemaEste projeto demonstra como resolver problemas de escalabilidade e custos descontrolados em uma loja online usando **Infrastructure as Code (IaC)** com **Terraform** e **LocalStack** para simulação local da AWS.## 📋 Descrição

- 💸 Auto Scaling **sem limites** → **R$ 32.000/mês**

- ❌ Falta de controle e previsibilidade



## ✅ A SoluçãoUma loja online enfrentava:



Infraestrutura como código com **controles de escalabilidade**:- 📈 Picos de tráfego nas **sextas-feiras** (promoções)

- ✅ `max_size = 10` → Limite máximo de instâncias

- ✅ Scheduled Scaling → Aumenta capacidade sextas 08:00- 📉 Baixa atividade nos **finais de semana**## 📋 Pré-requisitosProjeto de Infrastructure as Code (IaC) usando **Terraform** para resolver o estudo de caso de uma loja online que enfrenta problemas de escalabilidade e custos elevados durante picos de tráfego.

- ✅ Multi-AZ → Alta disponibilidade (3 zonas)

- ✅ Security Groups → Segurança em camadas- 💸 Auto Scaling **sem limites** → **R$ 32.000/mês**

- ✅ CloudWatch → Monitoramento e alarmes

- ❌ Falta de controle e previsibilidade

**Resultado:** Redução de **60%** nos custos (R$ 12k/mês)



---

## ✅ A SoluçãoAntes de começar, você precisa ter instalado em sua máquina:**Contexto:** MBA em Cybersecurity - Cloud Computing, DevOps e DevSecOps

## 📋 Pré-requisitos



### 1. Docker & Docker Compose

Infraestrutura como código com **controles de escalabilidade**:

**🪟 Windows:**

- https://docs.docker.com/desktop/install/windows-install/- ✅ `max_size = 10` → Limite máximo de instâncias

- Requer Windows 10/11 64-bit Pro/Enterprise

- ✅ Scheduled Scaling → Aumenta capacidade sextas 08:00### 1️⃣ Docker & Docker Compose## 🎯 Problema Original

**🍎 macOS:**

- https://docs.docker.com/desktop/install/mac-install/- ✅ Multi-AZ → Alta disponibilidade (3 zonas)



**🐧 Linux:**- ✅ Security Groups → Segurança em camadas

```bash

# Ubuntu/Debian- ✅ CloudWatch → Monitoramento e alarmes

sudo apt-get update && sudo apt-get install docker.io docker-compose-plugin

Docker é necessário para executar o LocalStack.- **Cenário:** Loja online com picos de tráfego às sextas-feiras e baixa atividade nos finais de semana

# Fedora

sudo dnf install docker docker-compose-plugin**Resultado:** Redução de **60%** nos custos (R$ 12k/mês)



# Adicionar usuário ao grupo docker- **Problema:** Auto Scaling sem limites causou custos operacionais excessivos

sudo usermod -aG docker $USER

newgrp docker---

```

#### 🪟 Windows- **Causa:** Falta de controles de escalabilidade e otimização de infraestrutura

**Verificar:**

```bash## 📋 Pré-requisitos

docker --version

docker compose version- **Docker Desktop for Windows**: https://docs.docker.com/desktop/install/windows-install/

```

### 1. Docker & Docker Compose

---

- Requisitos: Windows 10 64-bit Pro/Enterprise/Education ou Windows 11## ✨ Solução Implementada

### 2. Terraform

**🪟 Windows:**

**🪟 Windows:**

```powershell- https://docs.docker.com/desktop/install/windows-install/- Habilitar WSL 2: https://docs.microsoft.com/pt-br/windows/wsl/install

choco install terraform

# OU baixar de: https://developer.hashicorp.com/terraform/downloads- Requer Windows 10/11 64-bit Pro/Enterprise

```

Arquitetura AWS completa com foco em:

**🍎 macOS:**

```bash**🍎 macOS:**

brew tap hashicorp/tap

brew install hashicorp/tap/terraform- https://docs.docker.com/desktop/install/mac-install/#### 🍎 macOS

```



**🐧 Linux:**

```bash**🐧 Linux:**- **Docker Desktop for Mac**: https://docs.docker.com/desktop/install/mac-install/### 🔐 Segurança (DevSecOps)

# Ubuntu/Debian

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg```bash

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform# Ubuntu/Debian- Disponível para chips Intel e Apple Silicon (M1/M2/M3)- ✅ VPC isolada com 3 camadas (pública, privada, database)



# Fedorasudo apt-get update && sudo apt-get install docker.io docker-compose-plugin

sudo dnf install -y dnf-plugins-core

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo- ✅ Security Groups com regras restritivas

sudo dnf install terraform

```# Fedora



**Verificar:**sudo dnf install docker docker-compose-plugin#### 🐧 Linux- ✅ IAM Roles com princípio de menor privilégio

```bash

terraform version

```

# Adicionar usuário ao grupo docker```bash- ✅ VPC Flow Logs para auditoria

**Documentação:** https://developer.hashicorp.com/terraform/downloads

sudo usermod -aG docker $USER

---

newgrp docker# Ubuntu/Debian- ✅ S3 com criptografia e versionamento

### 3. AWS CLI (Opcional)

```

**🪟 Windows:**

- https://aws.amazon.com/cli/sudo apt-get update- ✅ IMDSv2 obrigatório nas instâncias EC2



**🍎 macOS:****Verificar:**

```bash

brew install awscli```bashsudo apt-get install docker.io docker-compose-plugin

```

docker --version

**🐧 Linux:**

```bashdocker compose version### 💰 Controle de Custos

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip```

sudo ./aws/install

```# Fedora- ✅ **Auto Scaling com limites** (min: 2, max: 10)



**Verificar:**---

```bash

aws --versionsudo dnf install docker docker-compose-plugin- ✅ **Scheduled Scaling** para padrões previsíveis (sextas-feiras)

```

### 2. Terraform

---

- ✅ Target Tracking Policies (CPU e Request Count)

## 🚀 Demo Completa

**🪟 Windows:**

### Passo 1: Iniciar LocalStack

```powershell# Adicionar usuário ao grupo docker- ✅ NAT Gateway otimizado

```bash

# Iniciar LocalStack em backgroundchoco install terraform

docker compose up -d

# OU baixar de: https://developer.hashicorp.com/terraform/downloadssudo usermod -aG docker $USER- ✅ VPC Endpoints para reduzir custos de tráfego

# Verificar se está rodando

docker ps```



# Verificar saúdenewgrp docker

curl http://localhost:4566/_localstack/health

```**🍎 macOS:**



**Saída esperada:** JSON com serviços `"available"` ou `"running"````bash```### 📊 Monitoramento



---brew tap hashicorp/tap



### Passo 2: Inicializar Terraformbrew install hashicorp/tap/terraform- ✅ CloudWatch Metrics customizados



```bash```

cd terraform/localstack

terraform init**Documentação oficial**: https://docs.docker.com/engine/install/- ✅ CloudWatch Logs centralizados

```

**🐧 Linux:**

**Saída esperada:** `Terraform has been successfully initialized!`

```bash- ✅ Health checks no ALB

---

# Ubuntu/Debian

### Passo 3: Validar Configuração

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg---- ✅ Alarmes de CPU, requests e custos

```bash

terraform validateecho "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

```

sudo apt update && sudo apt install terraform

**Saída esperada:** `Success! The configuration is valid.`



---

# Fedora### 2️⃣ LocalStack### 🏗️ Alta Disponibilidade

### Passo 4: Planejar Infraestrutura

sudo dnf install -y dnf-plugins-core

```bash

terraform plansudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo- ✅ Multi-AZ (3 Availability Zones)

```

sudo dnf install terraform

**Você verá:**

- ~40-50 recursos a serem criados```LocalStack emula serviços AWS localmente. Será executado via Docker Compose.- ✅ Application Load Balancer

- VPC, Subnets, ALB, Auto Scaling Group, Security Groups

- **Importante:** `min_size = 2` e `max_size = 10` (controle de custos!)



---**Verificar:**- ✅ Auto Scaling Group com health checks



### Passo 5: Aplicar Infraestrutura```bash



```bashterraform version**Documentação oficial**: https://docs.localstack.cloud/getting-started/installation/- ✅ Aurora PostgreSQL (preparado para multi-AZ)

terraform apply

``````



Digite `yes` quando solicitado.



**Tempo:** 2-5 minutos**Documentação:** https://developer.hashicorp.com/terraform/downloads



**Saída esperada:**#### Verificar instalação:## 📁 Estrutura do Projeto

```

Apply complete! Resources: XX added, 0 changed, 0 destroyed.---



Outputs:```bash

vpc_id = "vpc-XXXXXXXXX"

autoscaling_group_name = "loja-online-asg-XXXXXXXXX"### 3. AWS CLI (Opcional)

...

```docker --version```



---**🪟 Windows:**



### Passo 6: Verificar Recursos (Opcional)- https://aws.amazon.com/cli/docker compose version.



```bash

# Configurar alias

alias awslocal="aws --endpoint-url=http://localhost:4566"**🍎 macOS:**```├── terraform/



# Listar VPCs```bash

awslocal ec2 describe-vpcs

brew install awscli│   └── localstack/       # Configuração Terraform com LocalStack

# Listar Auto Scaling Groups

awslocal autoscaling describe-auto-scaling-groups```



# Listar instâncias EC2---│       ├── provider.tf   # Provider LocalStack

awslocal ec2 describe-instances

```**🐧 Linux:**



---```bash│       ├── variables.tf  # Variáveis configuráveis



### Passo 7: Ver Outputscurl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"



```bashunzip awscliv2.zip### 3️⃣ Terraform│       ├── data.tf       # Data sources

# Ver todos os outputs

terraform outputsudo ./aws/install



# Ver output específico```│       ├── vpc.tf        # VPC, subnets, networking

terraform output vpc_id

```



---**Verificar:**Terraform é a ferramenta de IaC que usaremos para provisionar a infraestrutura.│       ├── ec2.tf        # EC2, ALB, Auto Scaling



### Passo 8: Explorar Estado```bash



```bashaws --version│       ├── outputs.tf    # Outputs da infraestrutura

# Listar todos os recursos gerenciados

terraform state list```



# Ver detalhes de um recurso#### 🪟 Windows│       └── README.md     # Instruções detalhadas

terraform state show aws_autoscaling_group.main

```---



---```powershell│



## 🧹 Destruir Tudo## 🚀 Demo Completa



### ⚠️ IMPORTANTE: Sempre destrua ao final# Usando Chocolatey├── docker-compose.yml    # LocalStack container



```bash### Passo 1: Iniciar LocalStack

# Destruir todos os recursos Terraform

terraform destroychoco install terraform└── README.md

```

```bash

Digite `yes` quando solicitado.

# Iniciar LocalStack em background

```bash

# Voltar para raiz do projetodocker compose up -d

cd ../..

# OU baixar manualmente de: https://developer.hashicorp.com/terraform/downloads```

# Parar e remover containers

docker compose down# Verificar se está rodando



# (Opcional) Remover volumesdocker ps```

docker compose down -v

```



---# Verificar saúde## 🚀 Como Usar



## 📁 Estrutura do Projetocurl http://localhost:4566/_localstack/health



``````#### 🍎 macOS

estudo-caso-loja-online-iac/

├── README.md                    # 👈 Você está aqui

├── docker-compose.yml           # Configuração LocalStack

│**Saída esperada:** JSON com serviços `"available"` ou `"running"````bash### LocalStack (Simulação Local - Sem Custos AWS)

├── terraform/localstack/

│   ├── provider.tf              # AWS Provider + LocalStack endpoints

│   ├── variables.tf             # Variáveis (min_size, max_size, etc)

│   ├── vpc.tf                   # VPC, Subnets, Internet Gateway---# Usando Homebrew

│   ├── ec2.tf                   # Auto Scaling, ALB, Security Groups

│   ├── data.tf                  # Data sources (AMI, IAM policies)

│   ├── outputs.tf               # Outputs (VPC ID, ALB DNS, etc)

│   └── TERRAFORM.md             # 📚 Guia das estruturas Terraform### Passo 2: Inicializar Terraformbrew tap hashicorp/tap#### Pré-requisitos

│

├── diagramas/

│   ├── *.png                    # Diagramas de arquitetura

│   ├── scripts/*.py             # Scripts Python de geração```bashbrew install hashicorp/tap/terraform- Docker Desktop instalado e rodando

│   └── DIAGRAMS.md              # 📚 Como gerar diagramas

│cd terraform/localstack

└── apresentacao/

    ├── gerar-apresentacao.py    # Gerador do PowerPointterraform init```- Terraform >= 1.0

    └── *.pptx                   # Apresentações

``````



---- AWS CLI (opcional, para testes)



## 🆘 Troubleshooting**Saída esperada:** `Terraform has been successfully initialized!`



### LocalStack não inicia#### 🐧 Linux

```bash

docker compose logs localstack---

docker compose down && docker compose up -d

``````bash#### Passo a Passo Completo



### Terraform não conecta### Passo 3: Validar Configuração

```bash

# Verificar LocalStack# Ubuntu/Debian

curl http://localhost:4566/_localstack/health

```bash

# Verificar porta 4566

lsof -i :4566          # macOS/Linuxterraform validatewget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg**1. Iniciar LocalStack**

netstat -ano | findstr :4566  # Windows

``````



### Erro de state lockecho "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

```bash

terraform force-unlock <LOCK_ID>**Saída esperada:** `Success! The configuration is valid.`

```

sudo apt update && sudo apt install terraformVerifique se o Docker está rodando:

---

---

## 📚 Documentação Adicional

```bash

- 📖 **Guia Terraform:** [terraform/localstack/TERRAFORM.md](terraform/localstack/TERRAFORM.md)

- 📊 **Guia Diagramas:** [diagramas/DIAGRAMS.md](diagramas/DIAGRAMS.md)### Passo 4: Planejar Infraestrutura

- 🌐 **Terraform Docs:** https://developer.hashicorp.com/terraform/docs

- 🐳 **LocalStack Docs:** https://docs.localstack.cloud/# Fedoradocker ps

- ☁️ **AWS Docs:** https://docs.aws.amazon.com/

```bash

---

terraform plansudo dnf install -y dnf-plugins-core```

## 👨‍🏫 Sobre este Projeto

```

Projeto educacional desenvolvido para **MBA em Cybersecurity - Governance & Management**  

Disciplina: **Cloud Computing, DevOps e DevSecOps**sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo



**Professor:** Tharles Maicon Freire dos Santos  **Você verá:**

**Email:** tharles.freire@heyupcharly.com.br

- ~40-50 recursos a serem criadossudo dnf install terraformInicie o LocalStack na raiz do projeto:

---

- VPC, Subnets, ALB, Auto Scaling Group, Security Groups

## 📄 Licença

- **Importante:** `min_size = 2` e `max_size = 10` (controle de custos!)``````bash

Copyright © 2024 Prof. Tharles Maicon Freire dos Santos



Todos os direitos reservados. Reprodução ou divulgação total ou parcial deste projeto é expressamente proibida sem o consentimento formal, por escrito, do Professor (autor).

---docker compose up -d



### Passo 5: Aplicar Infraestrutura**Documentação oficial**: https://developer.hashicorp.com/terraform/downloads```



```bash

terraform apply

```#### Verificar instalação:Aguarde 10-20 segundos e verifique se está saudável:



Digite `yes` quando solicitado.```bash```bash



**Tempo:** 2-5 minutosterraform version# Ver logs



**Saída esperada:**```docker compose logs localstack

```

Apply complete! Resources: XX added, 0 changed, 0 destroyed.



Outputs:---# Verificar health

vpc_id = "vpc-XXXXXXXXX"

autoscaling_group_name = "loja-online-asg-XXXXXXXXX"curl http://localhost:4566/_localstack/health

...

```### 4️⃣ AWS CLI (Opcional, mas recomendado)



---# Deve retornar JSON com status dos serviços



### Passo 6: Verificar Recursos (Opcional)Útil para verificar recursos criados no LocalStack.```



```bash

# Configurar alias

alias awslocal="aws --endpoint-url=http://localhost:4566"#### 🪟 Windows**2. Inicializar Terraform**



# Listar VPCs```powershell

awslocal ec2 describe-vpcs

# Baixar instalador MSI de: https://aws.amazon.com/cli/```bash

# Listar Auto Scaling Groups

awslocal autoscaling describe-auto-scaling-groups```cd terraform/localstack



# Listar instâncias EC2terraform init

awslocal ec2 describe-instances

```#### 🍎 macOS```



---```bash



### Passo 7: Ver Outputsbrew install awscliSaída esperada: `Terraform has been successfully initialized!`



```bash```

# Ver todos os outputs

terraform output**3. Validar Configuração**



# Ver output específico#### 🐧 Linux

terraform output vpc_id

``````bash```bash



---curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"# Validar sintaxe



### Passo 8: Explorar Estadounzip awscliv2.zipterraform validate



```bashsudo ./aws/install

# Listar todos os recursos gerenciados

terraform state list```# Formatar código (opcional)



# Ver detalhes de um recursoterraform fmt

terraform state show aws_autoscaling_group.main

```**Documentação oficial**: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html



---# Ver o plano de execução



## 🧹 Destruir Tudo#### Verificar instalação:terraform plan



### ⚠️ IMPORTANTE: Sempre destrua ao final```bash```



```bashaws --version

# Destruir todos os recursos Terraform

terraform destroy```O `terraform plan` mostrará todos os recursos que serão criados (VPC, subnets, ALB, ASG, etc.)

```



Digite `yes` quando solicitado.

---**4. Aplicar Infraestrutura**

```bash

# Voltar para raiz do projeto

cd ../..

## 🚀 Guia de Demonstração```bash

# Parar e remover containers

docker compose downterraform apply



# (Opcional) Remover volumes### Passo 1: Iniciar o LocalStack```

docker compose down -v

```



---Primeiro, navegue até o diretório do projeto e inicie o LocalStack com Docker Compose:Digite `yes` quando solicitado.



## 📁 Estrutura do Projeto



``````bash⏱️ Tempo estimado: 2-5 minutos

estudo-caso-loja-online-iac/

├── README.md                    # 👈 Você está aqui# Navegar para o diretório do projeto

├── docker-compose.yml           # Configuração LocalStack

│cd estudo-caso-loja-online-iac**5. Verificar Recursos Criados**

├── terraform/localstack/

│   ├── provider.tf              # AWS Provider + LocalStack endpoints

│   ├── variables.tf             # Variáveis (min_size, max_size, etc)

│   ├── vpc.tf                   # VPC, Subnets, Internet Gateway# Iniciar LocalStack em background```bash

│   ├── ec2.tf                   # Auto Scaling, ALB, Security Groups

│   ├── data.tf                  # Data sources (AMI, IAM policies)docker compose up -d# Ver todos os outputs

│   ├── outputs.tf               # Outputs (VPC ID, ALB DNS, etc)

│   └── TERRAFORM.md             # 📚 Guia das estruturas Terraformterraform output

│

├── diagramas/# Verificar se o container está rodando

│   ├── *.png                    # Diagramas de arquitetura

│   ├── scripts/*.py             # Scripts Python de geraçãodocker ps# Ver URL do Load Balancer

│   └── DIAGRAMS.md              # 📚 Como gerar diagramas

│terraform output alb_url

└── apresentacao/

    ├── gerar-apresentacao.py    # Gerador do PowerPoint# Verificar logs (opcional)

    └── *.pptx                   # Apresentações

```docker compose logs -f localstack# Ver configuração de scaling



---terraform output scaling_configuration



## 🆘 Troubleshooting# Verificar saúde do LocalStack```



### LocalStack não iniciacurl http://localhost:4566/_localstack/health

```bash

docker compose logs localstack```**6. Testar com AWS CLI (Opcional)**

docker compose down && docker compose up -d

```



### Terraform não conecta**Saída esperada**: JSON mostrando serviços disponíveis (ec2, s3, iam, etc.) com status `"available"` ou `"running"`.```bash

```bash

# Verificar LocalStack# Configurar endpoint do LocalStack

curl http://localhost:4566/_localstack/health

---export AWS_ENDPOINT=http://localhost:4566

# Verificar porta 4566

lsof -i :4566          # macOS/Linux

netstat -ano | findstr :4566  # Windows

```### Passo 2: Navegar para o diretório Terraform# Listar VPCs



### Erro de state lockaws --endpoint-url=$AWS_ENDPOINT ec2 describe-vpcs

```bash

terraform force-unlock <LOCK_ID>```bash

```

cd terraform/localstack# Listar subnets

---

```aws --endpoint-url=$AWS_ENDPOINT ec2 describe-subnets

## 📚 Documentação Adicional



- 📖 **Guia Terraform:** [terraform/localstack/TERRAFORM.md](terraform/localstack/TERRAFORM.md)

- 📊 **Guia Diagramas:** [diagramas/DIAGRAMS.md](diagramas/DIAGRAMS.md)---# Listar Auto Scaling Groups

- 🌐 **Terraform Docs:** https://developer.hashicorp.com/terraform/docs

- 🐳 **LocalStack Docs:** https://docs.localstack.cloud/aws --endpoint-url=$AWS_ENDPOINT autoscaling describe-auto-scaling-groups

- ☁️ **AWS Docs:** https://docs.aws.amazon.com/

### Passo 3: Inicializar o Terraform

---

# Listar S3 buckets

## 👨‍🏫 Sobre este Projeto

Este comando baixa os providers necessários (AWS provider):aws --endpoint-url=$AWS_ENDPOINT s3 ls

Projeto educacional desenvolvido para **MBA em Cybersecurity - Governance & Management**  

Disciplina: **Cloud Computing, DevOps e DevSecOps**



**Professor:** Tharles Maicon Freire dos Santos  ```bash# Listar Security Groups

**Email:** tharles.freire@heyupcharly.com.br

terraform initaws --endpoint-url=$AWS_ENDPOINT ec2 describe-security-groups

---

```

## 📄 Licença

# Listar Load Balancers

Copyright © 2024 Prof. Tharles Maicon Freire dos Santos

**Saída esperada**: aws --endpoint-url=$AWS_ENDPOINT elbv2 describe-load-balancers

Todos os direitos reservados. Reprodução ou divulgação total ou parcial deste projeto é expressamente proibida sem o consentimento formal, por escrito, do Professor (autor).

```

Terraform has been successfully initialized!# Listar IAM Roles

```aws --endpoint-url=$AWS_ENDPOINT iam list-roles

```

---

**7. Explorar Estado do Terraform**

### Passo 4: Validar a configuração

```bash

Verifica se não há erros de sintaxe nos arquivos `.tf`:# Listar todos os recursos criados

terraform state list

```bash

terraform validate# Ver detalhes de um recurso específico

```terraform state show aws_vpc.main

terraform state show aws_autoscaling_group.backend

**Saída esperada**: terraform state show aws_lb.main

```

Success! The configuration is valid.# Ver todas as variáveis

```terraform show

```

---

**8. Testar Modificações (Opcional)**

### Passo 5: Planejar a infraestrutura

Edite `variables.tf` para alterar configurações:

Mostra o que será criado SEM aplicar as mudanças:

```bash

```bash# Exemplo: Alterar capacidade desejada

terraform plan# Em variables.tf, mude desired_capacity de 2 para 3

```

# Ver mudanças

**O que você verá**:terraform plan

- Recursos a serem criados: VPC, Subnets, ALB, Auto Scaling Group, Security Groups, etc.

- Total de recursos: ~40-50 recursos# Aplicar mudanças

- **🔍 Pontos importantes**:terraform apply

  - `min_size = 2` e `max_size = 10` → Controle de custos!```

  - Scheduled actions para sextas-feiras

  - 3 Availability Zones para alta disponibilidade**9. Destruir Infraestrutura**



---```bash

# Destruir todos os recursos

### Passo 6: Aplicar a infraestruturaterraform destroy



Cria os recursos no LocalStack:# Digite 'yes' quando solicitado

```

```bash

terraform apply**10. Parar LocalStack**

```

```bash

Digite `yes` quando solicitado.# Voltar para a raiz do projeto (se não estiver lá)

cd ../..

**⏱️ Tempo estimado**: 2-5 minutos

docker compose down

**Saída esperada**:

```# Ou para remover volumes também:

Apply complete! Resources: XX added, 0 changed, 0 destroyed.docker compose down -v

```

Outputs:

#### 🧪 Cenários de Teste

alb_dns_name = "loja-online-alb-XXXXXXXXX.elb.localhost.localstack.cloud"

autoscaling_group_name = "loja-online-asg-XXXXXXXXX"**Teste 1: Verificar Auto Scaling Limits**

vpc_id = "vpc-XXXXXXXXX"```bash

...# Ver configuração do ASG

```aws --endpoint-url=http://localhost:4566 autoscaling describe-auto-scaling-groups \

  --query 'AutoScalingGroups[0].[MinSize,MaxSize,DesiredCapacity]'

---

# Resultado esperado: [2, 10, 2]

### Passo 7: Verificar recursos criados (Opcional)# Confirma que max_size=10 previne escalabilidade descontrolada

```

#### Usando AWS CLI com LocalStack:

**Teste 2: Verificar Security Groups**

```bash```bash

# Configurar alias para facilitar# Listar regras do Security Group do ALB

alias awslocal="aws --endpoint-url=http://localhost:4566"aws --endpoint-url=http://localhost:4566 ec2 describe-security-groups \

  --filters "Name=group-name,Values=loja-online-prod-alb-sg" \

# Listar VPCs  --query 'SecurityGroups[0].IpPermissions'

awslocal ec2 describe-vpcs

# Verificar que apenas portas 80 e 443 estão abertas

# Listar Auto Scaling Groups```

awslocal autoscaling describe-auto-scaling-groups

**Teste 3: Verificar Isolamento de Rede**

# Listar Load Balancers```bash

awslocal elbv2 describe-load-balancers# Ver subnets privadas (sem internet direto)

terraform output private_subnet_ids

# Listar instâncias EC2

awslocal ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' --output table# Ver subnets de database (totalmente isoladas)

```terraform output database_subnet_ids

```

---

**Teste 4: Simular Mudança de Capacidade**

### Passo 8: Explorar os outputs```bash

# Editar variables.tf: desired_capacity = 3

O Terraform exibe informações importantes após o `apply`:terraform plan   # Ver diff

terraform apply  # Aplicar mudança

```bashterraform output # Verificar nova configuração

# Ver todos os outputs```

terraform output

#### ⚠️ Troubleshooting

# Ver um output específico

terraform output alb_dns_name**LocalStack não inicia:**

terraform output autoscaling_group_name```bash

```# Ver logs

docker compose logs localstack

---

# Restart

### Passo 9: Visualizar o estadodocker compose restart



Mostra todos os recursos gerenciados pelo Terraform:# Restart completo

docker compose down

```bashdocker compose up -d

# Listar todos os recursos```

terraform state list

**Erro "connection refused":**

# Ver detalhes de um recurso específico```bash

terraform state show aws_autoscaling_group.main# Verificar se porta 4566 está livre

```lsof -i :4566



---# Verificar se container está rodando

docker ps | grep localstack

## 🧹 Destruir a Infraestrutura```



### ⚠️ IMPORTANTE: Sempre destrua a infraestrutura ao final**Terraform state corrompido:**

```bash

```bashcd terraform/localstack

# Destruir todos os recursos criados pelo Terraformrm -rf .terraform terraform.tfstate*

terraform destroyterraform init

``````



Digite `yes` quando solicitado.**Recursos não são criados:**

```bash

**Saída esperada**:# Ver logs detalhados do LocalStack

```docker compose logs -f localstack

Destroy complete! Resources: XX destroyed.

```# Habilitar debug no docker-compose.yml (DEBUG=1 já está ativo)

```

---

#### 📊 Outputs Importantes

### Parar o LocalStack

Após `terraform apply`, você verá:

```bash

# Voltar para o diretório raiz do projeto```

cd ../..alb_url = "http://loja-online-prod-alb-XXXXXXXXX.us-east-1.elb.amazonaws.com"

vpc_id = "vpc-xxxxx"

# Parar e remover containersautoscaling_group_name = "loja-online-prod-backend-asg"

docker compose downscaling_configuration = {

  min_size = 2

# (Opcional) Remover volumes também  max_size = 10  # CONTROLE DE CUSTO!

docker compose down -v  desired_capacity = 2

```  friday_desired_capacity = 6

  weekend_desired_capacity = 2

---  cpu_target = 70

}

## 📁 Estrutura do Projeto```



```#### 🎯 O Que Você Está Testando

estudo-caso-loja-online-iac/

├── README.md                    # 👈 Você está aqui1. ✅ **VPC com 3 camadas** (pública, privada, database)

├── docker-compose.yml           # Configuração do LocalStack2. ✅ **Auto Scaling com limites** (previne custos descontrolados)

│3. ✅ **Scheduled Scaling** (sextas-feiras)

├── terraform/4. ✅ **Load Balancing** (distribuição de tráfego)

│   └── localstack/              # Código Terraform5. ✅ **Security Groups** (isolamento de rede)

│       ├── provider.tf          # Configuração do provider AWS + LocalStack6. ✅ **IAM Roles** (permissões mínimas)

│       ├── variables.tf         # Variáveis do projeto7. ✅ **Infrastructure as Code** (versionável, replicável)

│       ├── vpc.tf               # VPC, Subnets, Internet Gateway

│       ├── ec2.tf               # Auto Scaling, Launch Template, ALB📖 Veja [terraform/localstack/README.md](terraform/localstack/README.md) para mais detalhes.

│       ├── data.tf              # Data sources (AMI)

│       ├── outputs.tf           # Outputs do Terraform## 🎓 Objetivos de Aprendizado

│       ├── README.md            # Documentação do Terraform LocalStack

│       ├── LIMITACOES.md        # Limitações do LocalStack vs AWS real### DevSecOps

│       └── TERRAFORM.md         # 👈 Guia das estruturas Terraform- Infrastructure as Code (IaC) com Terraform

│- Security by Design

├── diagramas/                   # Diagramas de arquitetura (PNG)- Princípio de menor privilégio (IAM)

│   ├── *.png                    # Diagramas gerados- Network segmentation

│   ├── scripts/                 # Scripts Python para gerar diagramas- Auditoria e compliance (VPC Flow Logs)

│   ├── README.md                # Índice dos diagramas

│   └── DIAGRAMS.md              # 👈 Documentação de geração### Cloud Computing

│- Arquitetura multi-camadas na AWS

└── apresentacao/                # Apresentação PowerPoint- Auto Scaling e elasticidade

    ├── gerar-apresentacao.py    # Script para gerar PPT- Load Balancing

    └── *.pptx                   # Apresentações geradas- Otimização de custos

```

### DevOps

---- Automação de infraestrutura

- GitOps practices

## 🎯 Objetivo do Projeto- Monitoramento e observabilidade

- Continuous improvement

### Problema Original:

- Loja online com **picos de tráfego nas sextas-feiras**## 📊 Recursos Criados (no LocalStack)

- Auto Scaling **sem limites** → Custos dispararam para **R$ 32.000/mês**

- Falta de controle e previsibilidade### Networking

- 1 VPC

### Solução com Terraform:- 9 Subnets (3 públicas, 3 privadas, 3 database)

✅ **Controle de custos**: `max_size = 10` limita número de instâncias  - 3 NAT Gateways

✅ **Escalabilidade programada**: Scale up automático sextas às 08:00  - 1 Internet Gateway

✅ **Alta disponibilidade**: 3 Availability Zones  - Route Tables

✅ **Segurança**: Security Groups, subnets privadas  - VPC Flow Logs

✅ **Infraestrutura como Código**: Versionável, reproduzível, auditável  

### Compute

### Resultado:- Launch Template

- **Redução de 60% nos custos** (de R$ 32k para R$ 12k/mês)- Auto Scaling Group (2-10 instâncias)

- **Infraestrutura previsível e controlada**- Application Load Balancer

- **Deploy reproduzível em minutos**- Target Groups



---### Security

- Security Groups (ALB, EC2)

## 🆘 Troubleshooting- IAM Roles e Policies

- Instance Profiles

### LocalStack não inicia

```bash### Storage

# Verificar logs- S3 Bucket (ALB logs) - simplificado

docker compose logs localstack

### Monitoring

# Reiniciar- CloudWatch Metrics - básico

docker compose down- CloudWatch Logs - básico

docker compose up -d

```## 🔧 Configuração de Escalabilidade



### Terraform não conecta ao LocalStack### Padrão de Tráfego Resolvido

```bash

# Verificar se LocalStack está rodando**Problema Original:**

curl http://localhost:4566/_localstack/health- Sextas-feiras: Picos descontrolados → Custos altos

- Finais de semana: Baixo tráfego → Recursos ociosos

# Verificar porta 4566 está livre

lsof -i :4566  # macOS/Linux**Solução Implementada:**

netstat -ano | findstr :4566  # Windows

``````hcl

# Limites de Auto Scaling

### Erro "Error acquiring the state lock"min_size = 2   # Mínimo para HA

```bashmax_size = 10  # CONTROLE DE CUSTO

# Forçar desbloqueio (use com cuidado!)

terraform force-unlock <LOCK_ID># Scheduled Scaling

```- Sexta 08:00 UTC → desired_capacity = 6

- Sexta 23:00 UTC → desired_capacity = 2

---

# Target Tracking

## 📚 Recursos Adicionais- CPU target: 70%

- Request count: 1000 req/instância

- **Terraform Documentation**: https://developer.hashicorp.com/terraform/docs```

- **LocalStack Documentation**: https://docs.localstack.cloud/

- **AWS Documentation**: https://docs.aws.amazon.com/## 📈 Variáveis Principais

- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

| Variável | Default | Descrição |

---|----------|---------|-----------|

| `project_name` | `loja-online` | Nome do projeto |

## 👨‍🏫 Sobre este Projeto| `environment` | `prod` | Ambiente |

| `aws_region` | `us-east-1` | Região AWS |

Este é um projeto educacional desenvolvido para o curso de **MBA em Cybersecurity - Governance & Management**, disciplina **Cloud Computing, DevOps e DevSecOps**.| `min_size` | `2` | Instâncias mínimas |

| `max_size` | `10` | Instâncias máximas (LIMITE) |

**Professor**: Tharles Maicon Freire dos Santos  | `cpu_target_value` | `70` | Target CPU para scaling |

**Email**: tharles.freire@heyupcharly.com.br| `friday_desired_capacity` | `6` | Capacidade nas sextas |

| `weekend_desired_capacity` | `2` | Capacidade nos finais de semana |

---

Veja todas as variáveis em `terraform/localstack/variables.tf`

## 📄 Licença

## 🛡️ Segurança

Copyright © 2024 Prof. Tharles Maicon Freire dos Santos

### Boas Práticas Implementadas

Todos os direitos reservados. Reprodução ou divulgação total ou parcial deste projeto é expressamente proibida sem o consentimento formal, por escrito, do Professor (autor).- ✅ Subnets isoladas por função

- ✅ Database em subnet sem internet
- ✅ Security Groups com least privilege
- ✅ IAM roles específicas por recurso
- ✅ Criptografia em repouso (S3, EBS)
- ✅ S3 buckets com bloqueio de acesso público

### Recursos Comentados no LocalStack
- VPC Flow Logs (funcionalidade limitada)
- VPC Endpoints
- IMDSv2 metadata options
- S3 lifecycle policies avançadas

### Melhorias para Produção AWS Real
- [ ] AWS WAF no CloudFront/ALB
- [ ] AWS GuardDuty
- [ ] AWS Config rules
- [ ] Secrets Manager para credenciais
- [ ] Certificate Manager (HTTPS)
- [ ] AWS Backup
- [ ] VPC Flow Logs
- [ ] IMDSv2 obrigatório

## 📝 Comandos Terraform Úteis

```bash
# Validar sintaxe
terraform validate

# Formatar código
terraform fmt -recursive

# Planejar mudanças
terraform plan

# Aplicar mudanças
terraform apply

# Destruir infraestrutura
terraform destroy

# Ver estado
terraform show

# Listar recursos
terraform state list

# Ver output específico
terraform output alb_url
```

## 🐛 Troubleshooting

### Erro de credenciais (LocalStack)
```bash
# LocalStack não precisa de credenciais reais
# Use credenciais fake: access_key="test", secret_key="test"
```

### LocalStack não inicia
```bash
docker compose down
docker compose up -d
docker compose logs localstack
```

### State lock
```bash
# Remover lock (cuidado!)
terraform force-unlock <lock-id>
```

## 📚 Referências

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [LocalStack Documentation](https://docs.localstack.cloud/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS Auto Scaling Best Practices](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html)

## ⚠️ Notas Importantes

- Este projeto usa **LocalStack** para simular serviços AWS localmente
- Nenhum custo AWS é gerado ao usar LocalStack
- Para ambiente de produção real, adapte as configurações conforme necessário
- Alguns recursos estão simplificados para funcionar no LocalStack
- Para usar em AWS real, será necessário adaptar o provider e habilitar recursos comentados

## 👨‍🏫 Autor

**Prof. Tharles Maicon Freire dos Santos**  
MBA Cybersecurity - Governance & Management  
Email: tharles.freire@heyupcharly.com.br

## 📄 Licença

Este projeto é material didático para fins educacionais.

---

**🎯 Objetivo:** Demonstrar Infrastructure as Code com Terraform e conceitos de DevSecOps usando LocalStack para simulação local sem custos AWS.