import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.List;

public class Produkt {

    public static void insertTablesProdukt(Connection conn) throws SQLException {
        Statement stmt;
        String sqlStatment;
        for (int i = 0; i < 1000; i++) {
            stmt = conn.createStatement();
            sqlStatment = "INSERT INTO PRODUKT(PRODUKTID, PREIS, NAME, HERSTELLER, AUFTRAGID) VALUES (" + i + "," + getPreisSumme() + ",'" + getProdukt() + "', '" + getHersteller() + "',  " + getAuftragId() + ")";
            System.out.println(sqlStatment);
            stmt.executeUpdate(sqlStatment);
        }
        System.out.println("Record Auftrag inserted into table!");
    }

    private static String getProdukt() {
        List<String> produkts = Arrays.asList("apple", "brot", "kebap", "kartoffel", "joghur", "tabak", "vodka");
        int i = (int) (Math.random() * 6);
        String s = produkts.get(i);

        return s;
    }

    private static String getHersteller() {
        List<String> produkts = Arrays.asList("hoffer", "billa", "spar", "peny", "clever");
        int i = (int) (Math.random() * 4);
        String s = produkts.get(i);

        return s;
    }

    private static int getPreisSumme() {
        int i = 1 + (int) (Math.random() * 100);

        return i;
    }
    private static int getAuftragId() {
        int i = (int) (Math.random() * 99);

        return i;
    }

}
