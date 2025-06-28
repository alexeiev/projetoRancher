#!/bin/sh

if [ $# -eq 0 ]; then
  # Nenhum comando passado, executar ação padrão
  exec /bin/bash
else
  # Se comando foi passado, executa o comando
  exec "$@"
fi
