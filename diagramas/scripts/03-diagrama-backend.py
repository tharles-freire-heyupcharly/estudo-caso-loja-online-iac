#!/usr/bin/env python3
"""
Diagrama Backend - Camada de Aplicação
Foco nos servidores e processamento
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2, AutoScaling, Lambda
from diagrams.aws.network import ELB, PrivateSubnet
from diagrams.aws.security import IAM, SecretsManager
from diagrams.aws.integration import SQS, SNS
from diagrams.aws.management import Cloudwatch, SystemsManager
from diagrams.aws.storage import S3

graph_attr = {
    "fontsize": "20",
    "bgcolor": "white",
    "pad": "0.5",
    "labelloc": "t",  # Título no topo (top)
    "labeljust": "c",  # Título centralizado
    "fontname": "Helvetica-Bold",  # Fonte em negrito
}

with Diagram(
    "Arquitetura Backend - Processamento de Aplicação",
    filename="../03-diagrama-backend",
    outformat="png",
    show=False,
    direction="TB",
    graph_attr=graph_attr
):
    
    alb = ELB("Application\nLoad Balancer")
    
    with Cluster("Auto Scaling Group"):
        with Cluster("AZ-1a"):
            app1 = EC2("App Server\nNode.js")
        
        with Cluster("AZ-1b"):
            app2 = EC2("App Server\nNode.js")
        
        with Cluster("AZ-1c"):
            app3 = EC2("App Server\nNode.js")
        
        asg = AutoScaling("Auto Scaling\nMin: 2, Max: 10")
    
    with Cluster("Segurança"):
        iam = IAM("IAM Role\nEC2 Profile")
        secrets = SecretsManager("Secrets\nManager")
        ssm = SystemsManager("Systems\nManager")
    
    with Cluster("Processamento Assíncrono"):
        queue = SQS("SQS\nFila de Pedidos")
        notification = SNS("SNS\nNotificações")
        worker = Lambda("Lambda\nProcessador")
    
    with Cluster("Observabilidade"):
        logs = Cloudwatch("CloudWatch\nLogs")
        metrics = Cloudwatch("CloudWatch\nMetrics")
    
    s3_code = S3("S3\nDeployments")
    
    # Fluxo Backend
    alb >> Edge(label="Port 3000") >> [app1, app2, app3]
    asg >> Edge(style="dotted") >> [app1, app2, app3]
    
    iam >> [app1, app2, app3]
    secrets >> Edge(style="dashed", label="DB Credentials") >> app1
    ssm >> Edge(style="dashed") >> app2
    
    app1 >> queue
    queue >> worker
    worker >> notification
    
    app1 >> logs
    app2 >> metrics
    s3_code >> Edge(label="Deploy", color="green") >> app3

print("✅ Diagrama Backend criado!")
