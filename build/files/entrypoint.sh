#!/bin/sh

if [ $# -eq 0 ]; then
  # Nenhum comando passado, executar ação padrão
  sudo cp -f /home/$USER/id_rsa /home/$USER/.ssh/id_rsa >/dev/null 2>&1 \
  && sudo chmod 600 /home/$USER/.ssh/id_rsa \
  && sudo chown $USER:$USER /home/$USER/.ssh/id_rsa
  exec /bin/bash
else
  # Se comando foi passado, executa o comando
  sudo cp -f /home/$USER/id_rsa /home/$USER/.ssh/id_rsa >/dev/null 2>&1 \
  && sudo chmod 600 /home/$USER/.ssh/id_rsa \
  && sudo chown $USER:$USER /home/$USER/.ssh/id_rsa
  exec "$@"
fi
