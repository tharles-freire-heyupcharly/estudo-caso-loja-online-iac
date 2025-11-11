#!/usr/bin/env python3
"""
Diagrama Geral da Arquitetura - Visão Completa
Mostra todos os componentes da infraestrutura
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC, InternetGateway, NATGateway, ELB
from diagrams.aws.compute import EC2, AutoScaling
from diagrams.aws.security import IAM
from diagrams.aws.storage import S3
from diagrams.aws.database import RDS
from diagrams.aws.management import Cloudwatch
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
    "Arquitetura Geral - Loja Online",
    filename="../01-diagrama-geral",
    outformat="png",
    show=False,
    direction="TB",
    graph_attr=graph_attr
):
    
    users = Users("Usuários\nda Loja")
    
    with Cluster("VPC 10.0.0.0/16 - 3 Availability Zones"):
        igw = InternetGateway("Internet\nGateway")
        
        with Cluster("Camada Pública"):
            alb = ELB("Application\nLoad Balancer")
            nat = NATGateway("NAT\nGateways")
        
        with Cluster("Camada Privada - Aplicação"):
            with Cluster("Auto Scaling Group (2-10 instâncias)"):
                app_servers = [
                    EC2("App 1"),
                    EC2("App 2"),
                    EC2("App 3")
                ]
        
        with Cluster("Camada de Dados"):
            db = RDS("RDS\nPostgreSQL")
            s3 = S3("S3\nAssets")
        
        with Cluster("Segurança & Monitoramento"):
            iam = IAM("IAM\nRoles")
            monitoring = Cloudwatch("CloudWatch\nMetrics & Logs")
    
    # Fluxo
    users >> Edge(label="HTTPS") >> igw
    igw >> alb
    alb >> Edge(label="Port 3000") >> app_servers
    
    for server in app_servers:
        server >> Edge(label="SQL", style="dashed") >> db
        server >> Edge(label="Upload", style="dashed") >> s3
        server >> Edge(color="blue") >> monitoring
    
    nat >> Edge(style="dotted") >> app_servers[0]
    iam >> Edge(style="dotted") >> app_servers[1]

print("✅ Diagrama Geral criado!")
