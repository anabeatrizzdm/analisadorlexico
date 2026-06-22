# Analisador Léxico/Sintático — Compiladores

Projeto que **atende todos os roteiros 2 a 10**: constrói a linguagem completa
(`program`, declaração de variável, `designator`, `if/else`, `while`) e integra o
**registro e tratamento de erros** com localização (linha/coluna).

---

## 1. Como compilar e executar

Pré-requisitos: `java` e `javac` (JDK 8+) instalados.

```bash
# Compilar (gera o parser com CUP, o scanner com JFlex e compila tudo)
bash build.sh

# Executar sobre o arquivo de exemplo (programa do Roteiro 8)
./run.sh                      # usa entrada.txt
./run.sh exemplos/erro_lexico.txt   # usa outro arquivo
```

Manualmente, a execução é:
```bash
java -cp .:lib/java-cup-11b-runtime.jar Main entrada.txt
```

---

## 2. Estrutura dos arquivos

```
parser/Parser.cup     -> gramática (CUP). Gera parser/parser.java e parser/sym.java
scanner/Scanner.flex  -> analisador léxico (JFlex). Gera scanner/Scanner.java
erros/Erro.java       -> um erro (linha, coluna, texto)   [Roteiro 9]
erros/ListaErros.java -> acumula e imprime os erros        [Roteiro 9]
Main.java             -> liga scanner + parser e reporta o resultado
build.sh / run.sh     -> scripts de build e execução
entrada.txt           -> programa de exemplo (Roteiro 8)
exemplos/             -> entradas que disparam cada tipo de erro
lib/                  -> JFlex e CUP (jars)
```

Pacotes: `scanner`, `parser`, `erros` (exatamente como nos Roteiros 9 e 10).

---

## 3. O que cada roteiro contribuiu

| Roteiro | Conteúdo                                   | Onde está |
|---------|--------------------------------------------|-----------|
| 2       | `IDENT` / `designator` (`a`, `vet[4]`, `obj.campo`) | regra `designator` |
| 3       | Declaração de variável (`int a;`, `float b, x;`)    | `varDecl`, `varDecl_op`, `type` |
| 6       | `if`                                       | regra `if` |
| 7       | `if / else`                                | regras `if` e `else` |
| 8       | `while` + estrutura `program { ... }`      | regras `while`, `program`, `statement` |
| 9       | Registro de erros com localização          | `Erro`, `ListaErros`, `defineErro` no scanner |
| 10      | Tratamento de erro com `error` e `syntax_error()` | `parser code`, produções `error` |

---

## 4. Saída esperada (entrada.txt = exemplo do Roteiro 8)

```
Declaracao variavel:a
Declaracao variavel:vet
Declaracao variavel:b, x
Atribuicao reconhecida: 2.0
= 3.0
= 5.0
while(true){
= 1.5
}
if(true){
= 4.0
}
else{
= 5.0
}
Arquivo sem erros de sintaxe!
```

(`designator` sempre vale `1.0`, conforme os roteiros; por isso `4 + a` dá `5.0`
e `i < 10` é `true`.)

---

## 5. Tratamento de erros — exemplos prontos (pasta `exemplos/`)

| Arquivo                              | Erro detectado |
|--------------------------------------|----------------|
| `erro_divisao_por_zero.txt`          | "Erro semantico - Divisao por zero." / "Mod por zero." |
| `erro_lexico.txt`                    | "Lexico - Simbolo desconhecido: @" |
| `erro_expressao_incompleta.txt`      | "Expressao incompleta" (e o parser se recupera) |
| `erro_if_incompleto.txt`             | "IF incompleto" (e o parser se recupera) |
| `erro_sem_operador_relacional.txt`   | erro no operador relacional |

Quando há erros, o programa lista cada um no formato
`linha:L, coluna:C, <mensagem>`. Quando não há, imprime
`Arquivo sem erros de sintaxe!`.

---

## 6. Decisões importantes (leia antes de entregar)

1. **Duas linhagens nos roteiros.** Os roteiros 2–8 constroem a linguagem
   completa (sem pacotes, operador relacional como um único token-string). Os
   roteiros 9–10 reescrevem com **pacotes**, classes `Erro`/`ListaErros`,
   **tokens relacionais separados** (`MAIOR`, `MENOR`, ...) e o símbolo especial
   `error` — porém com uma gramática **reduzida** (só `if/else/expr`).
   As **atividades do Roteiro 10 pedem explicitamente** para reintegrar `while`
   e `designator` no parser com tratamento de erro. Portanto, este projeto é a
   **versão integrada**: gramática completa **+** tratamento de erros.

2. **Símbolo inicial = `program`.** Como a linguagem final tem o invólucro
   `program p ... { ... }`, todo arquivo de entrada deve começar com `program`.
   Os trechos soltos dos roteiros 9/10 (um `if` sem `program` em volta) foram
   adaptados para dentro de um `program` nos exemplos.

3. **Condição avaliada.** Para reproduzir a saída do Roteiro 8 (`while(true)`,
   `if(true)`), `condicao` avalia o operador relacional e imprime `true`/`false`.
   Os tokens relacionais separados do Roteiro 10 são convertidos em string pela
   regra `op_Relacional`, mantendo também a recuperação de erro ("Operador
   relacional desconhecido").

4. **Recuperação de erro tem limites.** O símbolo `error` do CUP recupera bem em
   posições como fim de expressão (`;`) e início de `if`, mas em alguns pontos
   (ex.: faltar o operador relacional dentro de um `if`) o CUP não consegue
   continuar e o parse encerra — o erro ainda é registrado com a localização.
   Isso é uma característica inerente da recuperação por `error`, reconhecida nos
   próprios roteiros.

Se o seu professor espera a versão **reduzida** dos roteiros 9/10 (que aceita um
`if` solto, sem `program`), me avise: é uma troca pequena de símbolo inicial e de
algumas regras.
