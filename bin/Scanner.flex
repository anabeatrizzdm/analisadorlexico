/* ============================================================
 *  Scanner.flex
 *  Analisador Lexico (Scanner) gerado a partir do JFlex
 *  Disciplina: Compiladores - Analise Lexica / Sintatica
 *
 *  Reconhece:
 *     - Identificadores               (ex: abc123, ponto01)
 *     - Numeros inteiros               (ex: 123)
 *     - Operadores aritmeticos         (+  -  *  /  %)
 *     - Parenteses                     ( )
 *     - Ponto e virgula                ( ; )
 *     - Comentarios de linha           ( // ... )
 *     - Espacos em branco / fim de linha (ignorados)
 *
 *  Integra com o JCup atraves da diretiva %cup, retornando
 *  objetos Symbol cujo "id" vem da classe sym (gerada pelo
 *  JCup a partir do arquivo Parser.cup).
 * ============================================================ */

import java_cup.runtime.Symbol;

%%

%class Scanner
%unicode
%cup
%line
%column
%public

%{
    /* Construtor adicional - permite instanciar o Scanner a
     * partir de um InputStream (entrada via teclado ou arquivo) */
    public Scanner(java.io.InputStream in) {
        this(new java.io.InputStreamReader(in,
             java.nio.charset.Charset.forName("UTF-8")));
    }
%}

digito      = [0-9]
letra       = [A-Za-zÀ-ÖØ-öø-ÿ_]
ident       = {letra} ({letra}|{digito})*
inteiro     = {digito}+
fimDeLinha  = \r|\n|\r\n
espaco      = {fimDeLinha} | [ \t\f]
comentario  = "//" [^\r\n]*

%%

/* ---------- ignorados ---------- */
{comentario}    { /* despreza comentario de linha */ }
{espaco}        { /* despreza espacos em branco */ }

/* ---------- numeros ---------- */
{inteiro}       {
                    int aux = Integer.parseInt(yytext());
                    return new Symbol(sym.INTEIRO, yyline, yycolumn, Integer.valueOf(aux));
                }

/* ---------- identificadores (reservado p/ uso futuro) ---------- */
{ident}         { return new Symbol(sym.IDENT, yyline, yycolumn, yytext()); }

/* ---------- operadores e simbolos ---------- */
"+"             { return new Symbol(sym.MAIS,     yyline, yycolumn); }
"-"             { return new Symbol(sym.MENOS,    yyline, yycolumn); }
"*"             { return new Symbol(sym.VEZES,    yyline, yycolumn); }
"/"             { return new Symbol(sym.DIVIDE,   yyline, yycolumn); }
"%"             { return new Symbol(sym.MOD,      yyline, yycolumn); }
"("             { return new Symbol(sym.ABREPAR,  yyline, yycolumn); }
")"             { return new Symbol(sym.FECHAPAR, yyline, yycolumn); }
";"             { return new Symbol(sym.PTVIRG,   yyline, yycolumn); }

/* ---------- caractere invalido ---------- */
[^]             {
                    System.out.println("Erro lexico: caractere invalido '" + yytext() +
                                        "' na linha " + (yyline + 1) +
                                        ", coluna " + (yycolumn + 1));
                }

/* ---------- fim de arquivo ---------- */
<<EOF>>         { return new Symbol(sym.EOF, yyline, yycolumn, "EOF"); }
