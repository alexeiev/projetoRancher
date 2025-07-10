#!/usr/bin/env python3

import subprocess
import time
import random
import sys

inventory_file = "ansible/inventory/hosts"

messages = [
    "⏳ Iniciando comunicação com as VMs...",
    "🐑 Contando carneirinhos enquanto esperamos...",
    "🎵 Tocando um jazz imaginário no terminal...",
    "🤖 Perguntando para as máquinas se estão acordadas...",
    "🚀 Preparando os motores de dobra espacial...",
    "🦾 Enviando sinal via modem 56k...",
    "📡 Procurando sinal nas antenas parabólicas...",
    "🍵 Hora de fazer um café enquanto isso...",
    "🔍 Conferindo se alguém deixou o cabo de rede desconectado...",
]

def check_ansible_connectivity():
    try:
        result = subprocess.run(
            ["ansible", "-i", inventory_file, "all", "-u", "{{ vm_user }}", "-m", "ping"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        if "SUCCESS" in result.stdout:
            return True
        else:
            return False
    except FileNotFoundError:
        print("❌ Ansible não encontrado. Verifique sua instalação.")
        sys.exit(1)

def main():
    print("🎛️  Verificando disponibilidade das VMs...\n")
    attempt = 1
    while not check_ansible_connectivity():
        message = random.choice(messages)
        print(f"[Tentativa {attempt}] {message}")
        time.sleep(5)
        attempt += 1

    print("\n✅ Todas as VMs estão disponíveis! Ansible, agora é contigo!\n")

if __name__ == "__main__":
    main()