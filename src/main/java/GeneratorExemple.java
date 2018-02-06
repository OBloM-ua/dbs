
import java.sql.*;

public class GeneratorExemple {


    public static void main(String[] args) {
        System.out.println("-------- Oracle JDBC Connection Testing ------");
        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Oracle JDBC Driver?");
            e.printStackTrace();
            return;
        }

        System.out.println("Oracle JDBC Driver Registered!");

        Connection connection = null;
        try {

            connection = DriverManager.getConnection(
                    "jdbc:oracle:thin:@131.130.122.23:1521:lab", "a01468396", "7123042");

        } catch (SQLException e) {

            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;

        }
        try {
            if (connection != null) {
                System.out.println("You made it, take control your database now!");
//                Auftrag.insertTablesAuftrag(connection);
//                Produkt.insertTablesProdukt(connection);
                Klient.insertTablesKlient(connection);
            } else
                System.out.println("Failed to make connection!");

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("FAILED SQL EXEPTION");
        }

    }

}

