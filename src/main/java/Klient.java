import com.google.common.hash.Hashing;
import com.sun.org.apache.xml.internal.security.algorithms.implementations.SignatureDSA;
import com.sun.org.apache.xml.internal.security.signature.XMLSignatureException;
import sun.security.provider.SHA;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.List;


public class Klient {

    public static void insertTablesKlient(Connection conn) throws SQLException {
        Statement stmt;
        String sqlStatment;
        for (int i = 0; i < 1000; i++) {
            stmt = conn.createStatement();
            String pass = Hashing.sha256().hashInt(i).toString();
            sqlStatment = "INSERT INTO KLIENT(EMAIL, PASSWORD, NAME, ADRESSE) VALUES('"+getEmail()+"','"+ pass +"','"+getName()+"', 'Wien')";
            System.out.println(sqlStatment);
            stmt.executeUpdate(sqlStatment);
        }
        System.out.println("Record Auftrag inserted into table!");
    }


    private static String getName() {
        List<String> produkts = Arrays.asList("oleh", "ivan", "david", "nazar", "igor", "roman", "pavlo");
        int i = (int) (Math.random() * 6);
        String s = produkts.get(i);

        return s;
    }
    private static String getEmail() {
        int i = (int) (Math.random() * 99999);

        return getName() +i + "@gmail.com";
    }
}
