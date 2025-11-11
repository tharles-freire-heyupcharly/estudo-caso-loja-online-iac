#!/usr/bin/env python3
"""
Script para gerar todos os diagramas de uma vez
"""

import subprocess
import sys
from pathlib import Path

def run_script(script_path):
    """Executa um script Python e retorna o status"""
    try:
        result = subprocess.run(
            [sys.executable, str(script_path)],
            capture_output=True,
            text=True,
            check=True
        )
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Erro ao executar {script_path.name}:")
        print(e.stderr)
        return False

def main():
    """Gera todos os diagramas"""
    scripts_dir = Path(__file__).parent
    
    scripts = [
        "01-diagrama-geral.py",
        "02-diagrama-frontend.py",
        "03-diagrama-backend.py",
        "04-diagrama-database.py",
        "05-diagrama-escalabilidade.py"
    ]
    
    print("🚀 Gerando todos os diagramas...\n")
    
    success_count = 0
    for script in scripts:
        script_path = scripts_dir / script
        if script_path.exists():
            if run_script(script_path):
                success_count += 1
        else:
            print(f"⚠️  Script não encontrado: {script}")
    
    print(f"\n{'='*50}")
    print(f"✅ {success_count}/{len(scripts)} diagramas gerados com sucesso!")
    print(f"📂 Localização: {scripts_dir.parent}")
    print(f"{'='*50}\n")

if __name__ == "__main__":
    main()
