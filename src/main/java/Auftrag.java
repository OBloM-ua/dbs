import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.List;


public class Auftrag {

    public static void insertTablesAuftrag(Connection conn) throws SQLException {
        Statement stmt;
        String sqlStatment;
        for (int i = 0; i < 100; i++) {
            stmt = conn.createStatement();
            sqlStatment = "INSERT INTO AUFTRAG(AUFTRAGID, PREISSUMME, PRODUKTENLISTE) VALUES(" + i + ", " + getPreisSumme() + " ,'" + getProduktList() + "' )";
            System.out.println(sqlStatment);
            stmt.executeUpdate(sqlStatment);
        }
        System.out.println("Record Auftrag inserted into table!");
    }

    private static int getPreisSumme() {
        int i = 1 + (int) (Math.random() * 100);

        return i;
    }

    private static List<String> getProduktList() {
        List<String> produkts = Arrays.asList("apple", "brot", "kebap", "kartoffel", "joghur", "tabak", "vodka");
        int i1 = (int) (Math.random() * 6);
        int i2 = (int) (Math.random() * 6);
        int i3 = (int) (Math.random() * 6);
        String s1 = produkts.get(i1);
        String s2 = produkts.get(i2);
        String s3 = produkts.get(i3);

        return Arrays.asList(s1, s2, s3);
    }


}
