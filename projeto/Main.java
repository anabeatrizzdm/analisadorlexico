/* ============================================================
 *  Main.java
 *  Acopla o Scanner (JFlex) ao parser (JCup), executa a analise
 *  sobre TODO o arquivo de entrada (um programa por arquivo) e,
 *  ao final, imprime a lista de erros encontrados ou a mensagem
 *  "Arquivo sem erros de sintaxe!".
 *
 *  Uso:
 *    java Main entrada.txt
 * ============================================================ */

import java.io.FileReader;
import scanner.Scanner;
import parser.parser;
import erros.ListaErros;

public class Main {

    public static void main(String[] argv) {

        if (argv.length == 0) {
            System.out.println("Uso: java Main <arquivo de entrada>");
            return;
        }

        String caminho = argv[0];

        ListaErros listaErros = new ListaErros();

        try {
            FileReader fr = new FileReader(caminho);
            Scanner scanner = new Scanner(fr, listaErros);
            parser p = new parser(scanner);
            p.parse();
            fr.close();
        } catch (java.io.FileNotFoundException e) {
            System.out.println("Nao foi possivel abrir o arquivo: " + caminho);
            return;
        } catch (Exception e) {
            /* O parser pode lancar excecao quando nao consegue se recuperar
             * de um erro de sintaxe. Os erros ja foram registrados na
             * listaErros e serao impressos logo abaixo. */
        }

        if (listaErros.hasErros()) {
            System.out.println("Erros encontrados:");
            listaErros.dump();
        } else {
            System.out.println("Arquivo sem erros de sintaxe!");
        }
    }
}
