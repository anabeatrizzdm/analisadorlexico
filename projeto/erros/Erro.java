package erros;

/* ============================================================
 *  Erro.java
 *  Representa um erro encontrado durante a analise, guardando
 *  a sua localizacao (linha e coluna) e uma mensagem de texto.
 *
 *  Construido nos Roteiros 9 (Registro de Erros com Localizacao)
 *  e 10 (Tratamento de Erros - Especial error).
 * ============================================================ */
public class Erro {

    private int linha, coluna;
    private String texto;

    /* Sobrecarga do construtor - erro "vazio" */
    public Erro() {
        this.linha  = -1;
        this.coluna = -1;
        this.texto  = "";
    }

    /* Sobrecarga do construtor - linha, coluna e texto conhecidos */
    public Erro(int linha, int coluna, String texto) {
        this.linha  = linha;
        this.coluna = coluna;
        this.texto  = texto;
    }

    /* Sobrecarga do construtor - apenas o local e conhecido
     * (texto fica null para ser preenchido depois pelo syntax_error) */
    public Erro(int linha, int coluna) {
        this.linha  = linha;
        this.coluna = coluna;
        this.texto  = null; // "Erro nao definido"
    }

    /* Imprime o erro no formato:  linha:L, coluna:C, <texto> */
    public void imprime() {
        String aux = "";
        aux = "linha:" + this.linha + ", coluna:" + this.coluna + ", ";
        if (this.texto == null) aux += " erro indefinido!";
        else                    aux += this.texto;
        System.out.println(aux);
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }
}
