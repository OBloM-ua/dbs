<?php
$user = 'a1506252';
$pass = 'dbs16';
$database = 'lab';

// establish database connection
$conn = oci_connect($user, $pass, $database);
if (!$conn) exit;
?>

<html>
<head>
</head>
<body>
<div>
    <form id='searchform' action='kunde.php' method='get'>
        <a href='index.php'>HOME</a> ---
        <a href='kunde.php'>Kunde</a> ---
        <a href='agent.php'>Agent</a> ---
        <a href='bucht.php'>Bucht</a> ---
        <a href='land.php'>Land</a> ---
        <a href='transportmittel.php'>Transportmittel</a> ---
        <a href='reiseziel.php'>Reiseziel</a> ---
        <br>
        Suche nach kunde:
        <input id='search' name='search' type='text' size='20' placeholder="Enter reisepassnummer"/>
        <input id='submit' type='submit' value='Los!'/>
    </form>
</div>
<?php
// check if search view of list view
if (isset($_GET['search'])) {
    $sql = "SELECT * FROM kunde WHERE reisepassnr LIKE '%" . $_GET['search'] . "%'";
} else {
    $sql = "SELECT * FROM kunde";
}

// execute sql statement
$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>


<table style='border: 1px solid #DDDDDD'>
    <thead>
    <tr>
        <th>reisepassnr</th>
        <th>personalausweis</th>
        <th>agentnr</th>
        <th>geburtstag</th>
    </tr>
    </thead>
    <tbody>
    <?php
    // fetch rows of the executed sql query
    while ($row = oci_fetch_assoc($stmt)) {
        echo "<tr>";
        echo "<td>" . $row['REISEPASSNR'] . "</td>";
        echo "<td>" . $row['PERSONALAUSWEIS'] . "</td>";
        echo "<td><a href=agent.php?search=" . $row['AGENTNR'] . ">" . $row['AGENTNR'] . "</a></td>";
        echo "<td>" . $row['GEBURTSTAG'] . "</td>";


        echo "</tr>";
    }
    ?>
    </tbody>
</table>
<div>Insgesamt <?php echo oci_num_rows($stmt); ?> kund(en) gefunden!</div>
<?php oci_free_statement($stmt); ?>

<div>
    <form id='insertform' action='kunde.php' method='get'>
        Neuen Kunde einfuegen:
        <table style='border: 1px solid #DDDDDD'>
            <thead>
            <tr>
                <th>reisepassnr</th>
                <th>personalausweis</th>
                <th>agentnr</th>
                <th>geburtstag</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>
                    <input id='reisepassnr' name='reisepassnr' type='number' size='10' value=''/>
                </td>
                <td>
                    <input id='personalausweis' name='personalausweis' type='number' size='20' value=''/>
                </td>
                <td>
                    <input id='agentnr' name='agentnr' type='number' size='20' value=''/>
                </td>
                <td>
                    <input id='geburtstag' name='geburtstag' type='text' size='15' value='DD-MM-YYYY'/>
                </td>
            </tr>
            </tbody>
        </table>
        <input id='submit' type='submit' value='Insert!'/>
    </form>
</div>


<?php
//Handle insert
if (isset($_GET['reisepassnr'])) {
    //Prepare insert statementd
    $sql = "INSERT INTO kunde VALUES('" . $_GET['reisepassnr'] . "','" . $_GET['personalausweis'] . "','" . $_GET['agentnr'] . "',to_date('" . $_GET['geburtstag'] . "'" . ",'DD-MM-YYYY')" . ")";

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
    @oci_free_statement($insert);
}
?>

<div>
    <form id='searchabt' action='kunde.php' method='get'>
        Suche kunde zu bestimmtem reisepassnr:
        <input id='reisepassnrinput' name='reisepassnrinput' type='number' size='20' value=''/>
        <input id='submit' type='submit' value='Aufruf Stored Procedure!'/>
    </form>
</div>

<?php
//Handle Stored Procedure
if (isset($_GET['reisepassnrinput'])) {
    //Call Stored Procedure
    $reisepassnrinput = $_GET['reisepassnrinput'];
    $namenOUT = '';
    $sproc = oci_parse($conn, 'begin kunde_proc(:p1, :p2); end;');
    //Bind variables, p1=input (nachname), p2=output (abtnr)
    oci_bind_by_name($sproc, ':p1', $reisepassnrinput);
    oci_bind_by_name($sproc, ':p2', $namenOUT, 20);
    oci_execute($sproc);
    $conn_err = oci_error($conn);
    $proc_err = oci_error($sproc);

    if (!$conn_err && !$proc_err) {
        echo("<br><b> kunde mit reisepassnr      " . $reisepassnrinput . " gehoert zu agent mit steuernummer " . $namenOUT . "</b><br>");  // prints OUT parameter of stored procedure
    } else {
        //Print potential errors and warnings
        print($conn_err);
        print_r($proc_err);
    }
}


// clean up connections
@oci_free_statement($sproc);
oci_close($conn);
?>
</body>
</html>