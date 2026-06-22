// ============================================================
//  Scanner.flex
//  Analisador Lexico integrado (JFlex)
//
//  Reune o conjunto completo de tokens da linguagem
//  (Roteiros 2 a 8: program, declaracao de variavel, designator,
//   if/else, while) COM a infraestrutura de registro de erros
//   (Roteiros 9 e 10: pacotes, ListaErros, defineErro, captura
//   de erro lexico).
// ============================================================

// 1 secao - O codigo colocado aqui, na primeira secao,
// e copiado, sem alteracoes, para o programa do usuario
package scanner;
import java_cup.runtime.Symbol;
import parser.sym;
import erros.ListaErros;

%%

// 2 secao - opcoes para customizar o programa gerado
// e declaracoes de macros usadas nas definicoes dos lexemes
%class Scanner
%cupsym sym
%cup
%unicode      // permite usar caracteres unicode
%line         // permite usar yyline
%column       // permite usar yycolumn
%public

// codigo inserido na classe Scanner
%{
    // atributo: lista de erros compartilhada com o parser
    private ListaErros listaErros;

    // Redefinindo ("sobrecarga") o construtor de Scanner para
    // receber e inicializar a listaErros
    public Scanner(java.io.FileReader in, ListaErros listaErros) {
        this(in);
        this.listaErros = listaErros;
    }

    public ListaErros getListaErros() { return listaErros; }

    public void defineErro(int linha, int coluna, String texto) {
        listaErros.defineErro(linha, coluna, texto);
    }

    // sera usado pelo syntax_error() do parser (apenas o local)
    public void defineErro(int linha, int coluna) {
        listaErros.defineErro(linha, coluna);
    }

    // usado para completar o texto dos erros adicionados pelo syntax_error()
    public void defineErro(String texto) {
        listaErros.defineErro(texto);
    }

    // Wrapper para facilitar a criacao de Symbol incorporando
    // a linha e a coluna em todos os tokens
    private Symbol criaSimbolo(int code, Object value) {
        return new Symbol(code, yyline, yycolumn, value);
    }
    private Symbol criaSimbolo(int code) {
        return new Symbol(code, yyline, yycolumn, null);
    }
%}

%eofval{
    return criaSimbolo(sym.EOF);
%eofval}

// ---------- macros ----------
FimdeLinha  = \r|\n|\r\n
Espaco      = {FimdeLinha} | [ \t\f]
Inteiro     = 0 | [1-9][0-9]*
letra       = [a-zA-Z]
digito      = [0-9]
Ident       = {letra} ({letra}|{digito})*

OpMais        = "+"
OpMenos       = "-"
OpMult        = "*"
OpDiv         = "/"
OpMod         = "%"
PtoVirg       = ";"
Virg          = ","
Pto           = "."
Igual         = "="
OpMaior       = ">"
OpMenor       = "<"
OpMaiorIgual  = ">="
OpMenorIgual  = "<="
OpIgualIgual  = "=="
OpDiferente   = "!="
KwProgram     = "program"
KwIf          = "if"
KwElse        = "else"
KwWhile       = "while"
abrePar       = "("
fechaPar      = ")"
abreChave     = "{"
fechaChave    = "}"
abreColch     = "["
fechaColch    = "]"
comentario    = "//" [^\r\n]*

%%

// ---------- ignorados ----------
{comentario}      { /* despreza comentario de linha */ }
{Espaco}          { /* despreza espacos em branco */ }

// ---------- numeros ----------
{Inteiro}         { Double aux = Double.parseDouble(yytext());
                    return criaSimbolo(sym.NUMBER, aux); }

// ---------- palavras reservadas (antes de Ident) ----------
{KwProgram}       { return criaSimbolo(sym.KW_PROGRAM); }
{KwIf}            { return criaSimbolo(sym.KW_IF); }
{KwElse}          { return criaSimbolo(sym.KW_ELSE); }
{KwWhile}         { return criaSimbolo(sym.KW_WHILE); }

// ---------- operadores relacionais (multi antes de simples) ----------
{OpMaiorIgual}    { return criaSimbolo(sym.MAIORIGUAL); }
{OpMenorIgual}    { return criaSimbolo(sym.MENORIGUAL); }
{OpIgualIgual}    { return criaSimbolo(sym.IGUALIGUAL); }
{OpDiferente}     { return criaSimbolo(sym.DIF); }
{OpMaior}         { return criaSimbolo(sym.MAIOR); }
{OpMenor}         { return criaSimbolo(sym.MENOR); }

// ---------- operadores aritmeticos e simbolos ----------
{OpMais}          { return criaSimbolo(sym.MAIS); }
{OpMenos}         { return criaSimbolo(sym.MENOS); }
{OpMult}          { return criaSimbolo(sym.MULT); }
{OpDiv}           { return criaSimbolo(sym.DIV); }
{OpMod}           { return criaSimbolo(sym.MOD); }
{PtoVirg}         { return criaSimbolo(sym.PTVIRG); }
{Virg}            { return criaSimbolo(sym.VIRG); }
{Pto}             { return criaSimbolo(sym.PTO); }
{Igual}           { return criaSimbolo(sym.IGUAL); }
{abrePar}         { return criaSimbolo(sym.ABREPAR); }
{fechaPar}        { return criaSimbolo(sym.FECHAPAR); }
{abreChave}       { return criaSimbolo(sym.ABRECHAVE); }
{fechaChave}      { return criaSimbolo(sym.FECHACHAVE); }
{abreColch}       { return criaSimbolo(sym.ABRE_COLCH); }
{fechaColch}      { return criaSimbolo(sym.FECHA_COLCH); }

// ---------- identificadores ----------
{Ident}           { return criaSimbolo(sym.IDENT, yytext()); }

// ---------- erro lexico: caractere desconhecido ----------
[^]               { this.defineErro(yyline, yycolumn,
                        "Lexico - Simbolo desconhecido: " + yytext()); }
