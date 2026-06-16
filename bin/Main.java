/* ============================================================
 *  Main.java
 *  Classe responsavel por acoplar o Scanner (JFlex) ao Parser
 *  (JCup) e executar a analise sintatica.
 *
 *  Uso:
 *    java Main                -> le expressoes do teclado (stdin)
 *    java Main entrada.txt    -> le expressoes de um arquivo
 *
 *  Cada linha do arquivo de entrada e tratada como uma analise
 *  independente, para que um erro em uma linha nao impeca a
 *  analise das demais linhas (facilita os testes em lote).
 * ============================================================ */

import java.io.*;

public class Main {

    public static void main(String[] argv) {

        if (argv.length > 0) {
            rodarArquivo(argv[0]);
        } else {
            rodarInterativo();
        }
    }

    /* Le e analisa o arquivo linha a linha (uma analise por linha) */
    private static void rodarArquivo(String caminho) {
        System.out.println("===========================================");
        System.out.println(" Analisando arquivo: " + caminho);
        System.out.println("===========================================");

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(new FileInputStream(caminho), "UTF-8"))) {

            String linha;
            int n = 1;
            while ((linha = br.readLine()) != null) {
                if (linha.trim().isEmpty() || linha.trim().startsWith("//")) continue;

                System.out.println("\n[Linha " + n + "] Entrada: " + linha);
                analisar(linha);
                n++;
            }
        } catch (IOException e) {
            System.out.println("Nao foi possivel abrir o arquivo: " + caminho);
        }

        System.out.println("\n===========================================");
        System.out.println(" Fim da analise.");
        System.out.println("===========================================");
    }

    /* Modo interativo: le do teclado ate o EOF (Ctrl+D / Ctrl+Z) */
    @SuppressWarnings("deprecation")
    private static void rodarInterativo() {
        System.out.println("Digite expressoes terminadas em ';' (Ctrl+D ou Ctrl+Z para finalizar):");
        try {
            Scanner scanner = new Scanner(System.in);
            parser p = new parser(scanner);
            p.parse();
        } catch (Exception e) {
            System.out.println("Erro durante a analise: " + e.getMessage());
        }
        System.out.println("Fim da analise.");
    }

    /* Roda o Scanner + Parser sobre uma unica linha/expressao */
    private static void analisar(String linha) {
        try {
            InputStream in = new ByteArrayInputStream(linha.getBytes("UTF-8"));
            Scanner scanner = new Scanner(in);
            parser p = new parser(scanner);
            p.parse();
        } catch (Exception e) {
            System.out.println("  => Erro de sintaxe: " + e.getMessage());
        }
    }
}
