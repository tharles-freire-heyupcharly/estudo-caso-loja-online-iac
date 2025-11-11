#!/usr/bin/env python3
"""
Diagrama Frontend - Camada de Apresentação
Foco na entrega de conteúdo aos usuários
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import CloudFront, Route53, ELB
from diagrams.aws.security import CertificateManager, WAF
from diagrams.aws.storage import S3
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet

graph_attr = {
    "fontsize": "20",
    "bgcolor": "white",
    "pad": "0.5",
    "labelloc": "t",  # Título no topo (top)
    "labeljust": "c",  # Título centralizado
    "fontname": "Helvetica-Bold",  # Fonte em negrito
}

with Diagram(
    "Arquitetura Frontend - CDN e Distribuição",
    filename="../02-diagrama-frontend",
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=graph_attr
):
    
    users = Users("Usuários\nGlobais")
    internet = Internet("Internet")
    
    with Cluster("Camada de Entrada"):
        dns = Route53("Route53\nDNS")
        waf = WAF("WAF\nFirewall")
        cdn = CloudFront("CloudFront\nCDN")
        ssl = CertificateManager("ACM\nSSL/TLS")
    
    with Cluster("Load Balancing"):
        alb = ELB("Application\nLoad Balancer")
        
        with Cluster("Health Checks"):
            health = ELB("Target\nHealth")
    
    with Cluster("Conteúdo Estático"):
        s3_static = S3("S3\nAssets Estáticos")
        s3_logs = S3("S3\nAccess Logs")
    
    # Fluxo Frontend
    users >> internet >> dns
    dns >> Edge(label="HTTPS") >> waf
    waf >> cdn
    cdn >> Edge(label="Cache Miss") >> alb
    cdn >> Edge(label="Cache Hit") >> s3_static
    
    ssl >> Edge(style="dashed") >> cdn
    alb >> health
    cdn >> Edge(label="Logs", color="gray") >> s3_logs

print("✅ Diagrama Frontend criado!")
