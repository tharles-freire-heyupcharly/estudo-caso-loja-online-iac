#!/usr/bin/env python3
"""
Diagrama de Escalabilidade - Auto Scaling e Performance
Foco em como o sistema escala baseado em demanda
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import AutoScaling, EC2
from diagrams.aws.network import ELB
from diagrams.aws.management import Cloudwatch
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.client import Users

graph_attr = {
    "fontsize": "20",
    "bgcolor": "white",
    "pad": "0.5",
    "labelloc": "t",  # Título no topo (top)
    "labeljust": "c",  # Título centralizado
    "fontname": "Helvetica-Bold",  # Fonte em negrito
}

with Diagram(
    "Estratégia de Escalabilidade - Auto Scaling",
    filename="../05-diagrama-escalabilidade",
    outformat="png",
    show=False,
    direction="TB",
    graph_attr=graph_attr
):
    
    users_low = Users("Segunda-Feira\n(Baixa Demanda)")
    users_friday = Users("Sexta-Feira\n(Alta Demanda)")
    users_weekend = Users("Fim de Semana\n(Manutenção)")
    
    with Cluster("Políticas de Auto Scaling"):
        
        with Cluster("Scaling Baseado em Métricas"):
            cpu_policy = Cloudwatch("CPU > 70%\n→ Scale Out")
            memory_policy = Cloudwatch("Memory > 80%\n→ Scale Out")
            requests_policy = Cloudwatch("Requests/Min > 1000\n→ Scale Out")
        
        with Cluster("Scaling Agendado"):
            schedule_friday = AutoScaling("Sexta 18h-22h\nDesired: 6 instâncias")
            schedule_weekend = AutoScaling("Sábado/Domingo\nDesired: 2 instâncias")
            schedule_normal = AutoScaling("Segunda-Quinta\nDesired: 3 instâncias")
    
    with Cluster("Configuração ASG"):
        asg_config = AutoScaling("Auto Scaling Group\nMin: 2 | Max: 10 | Desired: 3")
    
    alb = ELB("Application\nLoad Balancer")
    
    with Cluster("Estado Atual - Instâncias Ativas"):
        with Cluster("Cenário: Sexta-Feira 20h"):
            active_instances = [
                EC2("Instance 1\nAZ-1a"),
                EC2("Instance 2\nAZ-1b"),
                EC2("Instance 3\nAZ-1c"),
                EC2("Instance 4\nAZ-1a"),
                EC2("Instance 5\nAZ-1b"),
                EC2("Instance 6\nAZ-1c"),
            ]
    
    with Cluster("Monitoramento"):
        metrics = Cloudwatch("CloudWatch\nMetrics")
        dashboard = Grafana("Dashboard\nGrafana")
    
    # Fluxo de Escalabilidade
    users_friday >> Edge(label="Alto Tráfego", color="red") >> alb
    alb >> active_instances
    
    for instance in active_instances:
        instance >> metrics
    
    metrics >> cpu_policy
    metrics >> memory_policy
    metrics >> requests_policy
    
    [cpu_policy, memory_policy, requests_policy] >> Edge(label="Trigger") >> asg_config
    [schedule_friday, schedule_weekend, schedule_normal] >> Edge(label="Agendar", style="dashed") >> asg_config
    
    metrics >> dashboard
    
    # Anotações
    users_low >> Edge(label="2-3 instâncias", color="green", style="dotted") >> schedule_normal
    users_weekend >> Edge(label="2 instâncias", color="blue", style="dotted") >> schedule_weekend

print("✅ Diagrama de Escalabilidade criado!")
