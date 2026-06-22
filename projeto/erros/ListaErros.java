package erros;

import java.util.ArrayList;
import java.util.List;

/* ============================================================
 *  ListaErros.java
 *  Acumula todos os erros (lexicos e sintaticos) encontrados
 *  durante a analise de um programa. Ao final, o Main pergunta
 *  se ha erros (hasErros) e, se houver, imprime todos (dump).
 *
 *  Construido nos Roteiros 9 e 10.
 * ============================================================ */
public class ListaErros {

    private List<Erro> erros = null;

    public ListaErros() {
        this.erros = new ArrayList<Erro>();
    }

    /* Usado quando sabemos de fato a linha e a coluna exata */
    public void defineErro(int linha, int coluna, String texto) {
        Erro e = new Erro(linha, coluna, texto);
        this.erros.add(e);
    }

    /* Sobrecarga - normalmente chamado pelo syntax_error() do parser,
     * que so conhece o local (texto fica null e e preenchido depois) */
    public void defineErro(int linha, int coluna) {
        Erro e = new Erro(linha, coluna);
        this.erros.add(e);
    }

    /* Adiciona o texto no primeiro erro sem descricao, ou seja,
     * naqueles erros que o syntax_error() preencheu apenas o local */
    public void defineErro(String texto) {
        for (Erro e : this.erros) {
            if (e.getTexto() == null) {
                e.setTexto(texto);
                return;
            }
        }
    }

    /* Imprime erro por erro */
    public void dump() {
        for (Erro e : this.erros) {
            e.imprime();
        }
    }

    public boolean hasErros() {
        if (this.erros.size() > 0) {
            return true;
        } else {
            return false;
        }
    }
}
