<?php

$local = true;
if ($local) {
    // Localhost AHK Database Connection
    $host = "localhost";
    $db = "k144817_ahk";
    $user = "root";
    $password = "";
} else {
    // bats.li AHK Database Connection
    // :)
}

    try {
        $conn = new PDO("mysql:host=$host;dbname=$db", $user, $password);
        // set the PDO error mode to exception
        //$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // echo "Connected successfully";
    } catch(PDOException $e) {
        echo "Connection failed: " . $e->getMessage();
    }


?>
