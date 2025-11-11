# 📊 Diagramas de Arquitetura AWS

Este diretório contém **5 diagramas** da infraestrutura AWS com ícones oficiais, gerados usando a biblioteca Python **Diagrams**.

## 🎯 Diagramas Disponíveis

### 1. Diagrama Geral (`01-diagrama-geral.png`)
Visão completa end-to-end da arquitetura.

**Componentes:** VPC, Subnets (3 AZs), ALB, Auto Scaling Group, Security Groups, Internet Gateway, NAT Gateway

---

### 2. Diagrama Frontend (`02-diagrama-frontend.png`)
Camada de distribuição de conteúdo e CDN.

**Componentes:** Route53, CloudFront, WAF, ALB, S3, Certificate Manager

---

### 3. Diagrama Backend (`03-diagrama-backend.png`)
Camada de processamento da aplicação.

**Componentes:** EC2 Instances, Auto Scaling, Launch Template, Lambda, SQS, SNS, Systems Manager

---

### 4. Diagrama Database (`04-diagrama-database.png`)
Camada de persistência e cache.

**Componentes:** RDS Aurora PostgreSQL (Multi-AZ), Read Replicas, ElastiCache Redis, S3 Backups, DMS

---

### 5. Diagrama Escalabilidade (`05-diagrama-escalabilidade.png`)
Estratégia de Auto Scaling e controle de custos.

**Componentes:** Auto Scaling Policies, CloudWatch Metrics, Scheduled Actions (sextas-feiras)

**Destaque:** 
- `min_size = 2` (custo mínimo)
- `max_size = 10` (**controle de custos**)
- Scale up: Sextas 08:00 → 6 instâncias
- Scale down: Sextas 23:00 → 2 instâncias

---

## 📋 Pré-requisitos

### 1. Python 3.8+

**🪟 Windows:**
- https://www.python.org/downloads/
- Marcar "Add Python to PATH" na instalação

**🍎 macOS:**
```bash
brew install python3
```

**🐧 Linux:**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3 python3-pip python3-venv

# Fedora
sudo dnf install python3 python3-pip
```

**Verificar:**
```bash
python3 --version
```

---

### 2. Graphviz

Necessário para renderizar os diagramas.

**🪟 Windows:**
```powershell
choco install graphviz
# OU baixar de: https://graphviz.org/download/
# Adicionar ao PATH: C:\Program Files\Graphviz\bin
```

**🍎 macOS:**
```bash
brew install graphviz
```

**🐧 Linux:**
```bash
# Ubuntu/Debian
sudo apt install graphviz

# Fedora
sudo dnf install graphviz
```

**Verificar:**
```bash
dot -V
```

---

### 3. Biblioteca Python Diagrams

```bash
# Criar ambiente virtual (recomendado)
python3 -m venv .venv

# Ativar ambiente virtual
source .venv/bin/activate  # macOS/Linux
.venv\Scripts\activate     # Windows

# Instalar diagrams
pip install diagrams==1.0.2
```

**Documentação:** https://diagrams.mingrammer.com/

---

## 🚀 Como Gerar os Diagramas

### Opção 1: Gerar Todos de Uma Vez

```bash
cd diagramas/scripts
python3 gerar-todos.py
```

**Saída esperada:**
```
🎨 Iniciando geração de todos os diagramas...

✅ 01-diagrama-geral.py executado com sucesso!
✅ 02-diagrama-frontend.py executado com sucesso!
✅ 03-diagrama-backend.py executado com sucesso!
✅ 04-diagrama-database.py executado com sucesso!
✅ 05-diagrama-escalabilidade.py executado com sucesso!

🎉 Todos os diagramas foram gerados!
📂 Arquivos PNG em: /diagramas/
```

---

### Opção 2: Gerar Individual

```bash
cd diagramas/scripts

python3 01-diagrama-geral.py
python3 02-diagrama-frontend.py
python3 03-diagrama-backend.py
python3 04-diagrama-database.py
python3 05-diagrama-escalabilidade.py
```

Cada script gera um arquivo PNG no diretório `/diagramas/`.

---

## 📝 Estrutura de um Script

Exemplo básico:

```python
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2, AutoScaling
from diagrams.aws.network import ELB

# Configuração do diagrama
graph_attr = {
    "fontsize": "20",
    "fontname": "Helvetica-Bold",
    "bgcolor": "white",
    "labelloc": "t",  # Título no topo
}

# Criar diagrama
with Diagram(
    "Minha Arquitetura AWS",
    filename="../meu-diagrama",  # Salva como meu-diagrama.png
    outformat="png",
    show=False,
    direction="LR",  # Left to Right (ou TB = Top to Bottom)
    graph_attr=graph_attr
):
    # Componentes
    alb = ELB("Load Balancer")
    
    with Cluster("Auto Scaling"):
        asg = AutoScaling("ASG")
        instances = [EC2("EC2-1"), EC2("EC2-2"), EC2("EC2-3")]
    
    # Conectar
    alb >> asg >> instances
```

---

## 🎨 Personalizações

### Alterar Título
```python
with Diagram("Novo Título", ...):
```

### Alterar Tamanho da Fonte
```python
graph_attr = {
    "fontsize": "24",  # Maior
}
```

### Alterar Direção
```python
direction="TB"  # Top to Bottom
direction="LR"  # Left to Right
```

### Labels nas Conexões
```python
alb >> Edge(label="HTTPS") >> instances
alb >> Edge(color="red", style="dashed") >> instances
```

---

## 📦 Componentes AWS Disponíveis

### Compute
```python
from diagrams.aws.compute import (
    EC2, Lambda, ECS, EKS, AutoScaling
)
```

### Network
```python
from diagrams.aws.network import (
    ELB, ALB, NLB, VPC, Route53, CloudFront, APIGateway
)
```

### Database
```python
from diagrams.aws.database import (
    RDS, Aurora, DynamoDB, ElastiCache
)
```

### Storage
```python
from diagrams.aws.storage import (
    S3, EBS, EFS
)
```

### Security
```python
from diagrams.aws.security import (
    IAM, Cognito, SecretsManager, WAF
)
```

### Management
```python
from diagrams.aws.management import (
    Cloudwatch, SystemsManager
)
```

**Lista completa:** https://diagrams.mingrammer.com/docs/nodes/aws

---

## 🐛 Troubleshooting

### Erro: "Graphviz não encontrado"
```bash
# Verificar instalação
dot -V

# Windows: Adicionar ao PATH
# Painel de Controle > Sistema > Variáveis de Ambiente
# Adicionar: C:\Program Files\Graphviz\bin
```

### Erro: "Module 'diagrams' not found"
```bash
# Verificar ambiente virtual ativo
which python3  # macOS/Linux
where python   # Windows

# Reinstalar
pip install diagrams==1.0.2
```

### Diagrama não aparece
```bash
# Verificar se PNG foi gerado
ls ../*.png

# Verificar permissões de escrita
chmod 755 ../
```

---

## 💡 Dicas

1. **Sempre use ambiente virtual** - Evita conflitos de dependências
2. **Commit os PNGs no Git** - Facilita visualização no GitHub
3. **Use nomes descritivos** - `alb = ELB("Load Balancer")` não `lb = ELB("LB")`
4. **Agrupe com Cluster** - Componentes relacionados ficam visualmente juntos
5. **Mantenha simples** - Um diagrama por conceito (não coloque tudo em um)

---

## 📚 Recursos Adicionais

- **Diagrams Docs:** https://diagrams.mingrammer.com/
- **Diagrams GitHub:** https://github.com/mingrammer/diagrams
- **AWS Icons:** https://aws.amazon.com/architecture/icons/
- **Graphviz Docs:** https://graphviz.org/documentation/

---

## 👨‍🏫 Sobre

Criado para **MBA em Cybersecurity - Governance & Management**

**Professor:** Tharles Maicon Freire dos Santos  
**Email:** tharles.freire@heyupcharly.com.br
