<?php
$user = 'a01468396';
$pass = '7123042';
$database = 'lab';
// establish database connection
$conn = oci_connect($user, $pass, $database);
if (!$conn) exit;
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Produkt</title>
</head>

<body>

<div>
    <form id='searchform' action='produkt.php' method='get'>
        <a href='produkt.php'>Alle Auftrage</a> ---
        Suche nach Podukt Name:
        <input id='search' name='search' type='text' size='20' value='<?php echo isset($_GET['search'])?$_GET['search']:'' ?>'/>
        <input id='submit' type='submit' value='Los!'/>
        <a href='auftrag.php'>Alle Auftrage</a> |
        <a href='klient.php'>Alle Klients</a> |
        <a href='bezahlung.php'>Alle Bezahlungen</a> |
    </form>
</div>

<div>
    <form id='insertform' action='produkt.php' method='get'>
        Neue Produkt einfuegen:
        <table style='border: 1px solid #DDDDDD'>
            <thead>
            <tr>
                <th>Produktid</th>
                <th>Preis</th>
                <th>Name</th>
                <th>Hersteller</th>
                <th>AuftragId</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>
                    <input id='Produktid' name='Produktid' type='number' size='20'
                           value='<?php if (isset($_GET['EMAIL'])) echo $_GET['EMAIL']; ?>'/>
                </td>
                <td>
                    <input id='Preis' name='Preis' type='number' size='20'
                           value='<?php if (isset($_GET['PASSWORD'])) echo $_GET['PASSWORD']; ?>'/>
                </td>
                <td>
                    <input id='Name' name='Name' type='text' size='20'
                           value='<?php if (isset($_GET['NAME'])) echo $_GET['NAME']; ?>'/>
                </td>
                <td>
                    <input id='Hersteller' name='Hersteller' type='text' size='20'
                           value='<?php if (isset($_GET['ADRESSE'])) echo $_GET['ADRESSE']; ?>'/>
                </td>
                <td>
                    <input id='AuftragId' name='AuftragId' type='number' size='20'
                           value='<?php if (isset($_GET['ADRESSE'])) echo $_GET['ADRESSE']; ?>'/>
                </td>
            </tr>
            </tbody>
        </table>
        <input id='submit' type='submit' value='Insert!'/>
    </form>
</div>

<?php
//Handle insert
if (isset($_GET['Produktid'])) {
    //Prepare insert statementd
    $sql = "INSERT INTO PRODUKT VALUES('" . $_GET['Produktid'] . "','" . $_GET['Preis'] . "','" . $_GET['Name'] . "', '" . $_GET['Hersteller'] . "','". $_GET['AuftragId'] . "') ";
    //Parse and execute statement
    $insert = oci_parse($conn, $sql);
    oci_execute($insert);
    $conn_err = oci_error($conn);
    $insert_err = oci_error($insert);
    if (!$conn_err & !$insert_err) {
        print("Successfully inserted");
        print("<br>");
    } //Print potential errors and warnings
    else {
        print($conn_err);
        print_r($insert_err);
        print("<br>");
    }
    oci_free_statement($insert);
}
?>


<?php
// check if search view of list view
//  «oci_fetch_all», «oci_fetch_array», «oci_fetch_object», «oci_fetch_row» oder «oci_fetch»
if (isset($_GET['search'])) {
    $sql = "SELECT * FROM produkt WHERE name like '%" . $_GET['search'] . "%'";
} else {
    $sql = "SELECT * FROM produkt ORDER BY PRODUKTID ASC ";
}

// execute sql statement
$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>

<table style='border: 1px solid #DDDDDD'>
    <thead>
    <tr>
        <th>produktid</th>
        <th>preis</th>
        <th>name</th>
        <th>hersteller</th>
        <th>auftragid</th>
    </tr>
    </thead>
    <tbody>
    <?php
    // fetch rows of the executed sql query
    while ($row = oci_fetch_assoc($stmt)) {
        echo "<tr>";
        echo "<td>" . $row['PRODUKTID'] . "</td>";
        echo "<td>" . $row['PREIS'] . "</td>";
        echo "<td>" . $row['NAME'] . "</td>";
        echo "<td>" . $row['HERSTELLER'] . "</td>";
        echo "<td>" . $row['AUFTRAGID'] . "</td>";
        echo "</tr>";
    }
    ?>
    </tbody>
</table>

<div>Insgesamt <?php echo oci_num_rows($stmt); ?> Person(en) gefunden!</div>

<?php
// clean up connections
oci_free_statement($stmt);
oci_close($conn);
?>

</body>
</html>