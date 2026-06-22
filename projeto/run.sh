#!/bin/bash
# Executa a analise sobre um arquivo de entrada.
# Uso: ./run.sh [arquivo]   (padrao: entrada.txt)
cd "$(dirname "$0")"
ARQ="${1:-entrada.txt}"
java -cp .:lib/java-cup-11b-runtime.jar Main "$ARQ"
