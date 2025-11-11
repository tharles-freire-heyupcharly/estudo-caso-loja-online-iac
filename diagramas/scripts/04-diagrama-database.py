#!/usr/bin/env python3
"""
Diagrama Database - Camada de Persistência
Foco em bancos de dados e armazenamento
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.database import RDS, Elasticache, DatabaseMigrationService
from diagrams.aws.storage import S3, EBS
from diagrams.aws.compute import EC2
from diagrams.aws.network import PrivateSubnet
from diagrams.aws.security import IAM
from diagrams.aws.management import Cloudwatch

graph_attr = {
    "fontsize": "20",
    "bgcolor": "white",
    "pad": "0.5",
    "labelloc": "t",  # Título no topo (top)
    "labeljust": "c",  # Título centralizado
    "fontname": "Helvetica-Bold",  # Fonte em negrito
}

with Diagram(
    "Arquitetura Database - Camada de Dados",
    filename="../04-diagrama-database",
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=graph_attr
):
    
    with Cluster("Camada de Aplicação"):
        app_servers = [
            EC2("App 1"),
            EC2("App 2"),
            EC2("App 3")
        ]
    
    with Cluster("Camada de Cache"):
        with Cluster("ElastiCache Redis Cluster"):
            cache_primary = Elasticache("Redis\nPrimary")
            cache_replica = Elasticache("Redis\nReplica")
    
    with Cluster("Camada de Banco de Dados"):
        with Cluster("RDS PostgreSQL Multi-AZ"):
            db_primary = RDS("RDS Primary\nAZ-1a")
            db_standby = RDS("RDS Standby\nAZ-1b")
        
        with Cluster("Read Replicas"):
            db_read1 = RDS("Read Replica\nAZ-1a")
            db_read2 = RDS("Read Replica\nAZ-1c")
    
    with Cluster("Armazenamento"):
        s3_backup = S3("S3\nBackups")
        s3_uploads = S3("S3\nUser Uploads")
        ebs = EBS("EBS\nVolumes")
    
    with Cluster("Manutenção"):
        dms = DatabaseMigrationService("DMS\nMigrações")
        monitoring = Cloudwatch("CloudWatch\nDB Metrics")
    
    # Fluxo de Dados
    for app in app_servers:
        app >> Edge(label="Read", color="blue") >> cache_primary
        app >> Edge(label="Write", color="red") >> db_primary
        app >> Edge(label="Read Heavy", color="green") >> db_read1
        app >> Edge(label="Upload", style="dashed") >> s3_uploads
    
    cache_primary >> Edge(label="Replicação") >> cache_replica
    
    db_primary >> Edge(label="Sync Replication\nMulti-AZ", color="red") >> db_standby
    db_primary >> Edge(label="Async Replication", color="green") >> [db_read1, db_read2]
    
    db_primary >> Edge(label="Automated Backup", style="dotted") >> s3_backup
    db_primary >> Edge(label="Snapshots") >> ebs
    
    dms >> Edge(style="dashed") >> db_primary
    [db_primary, cache_primary] >> monitoring

print("✅ Diagrama Database criado!")
