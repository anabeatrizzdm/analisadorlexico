#!/bin/bash
# ============================================================
#  build.sh - gera o parser (CUP), o scanner (JFlex) e compila
# ============================================================
set -e
cd "$(dirname "$0")"

CUP=lib/java-cup-11b.jar
CUPRT=lib/java-cup-11b-runtime.jar
JFLEX=lib/jflex-full-1.9.1.jar

echo ">> Gerando parser (CUP)..."
java -jar "$CUP" -package parser -destdir parser -parser parser -symbols sym parser/Parser.cup

echo ">> Gerando scanner (JFlex)..."
java -jar "$JFLEX" -d scanner scanner/Scanner.flex

echo ">> Compilando..."
javac -cp "$CUPRT" erros/*.java parser/*.java scanner/*.java Main.java

echo ">> OK. Para executar:  java -cp .:$CUPRT Main entrada.txt"
