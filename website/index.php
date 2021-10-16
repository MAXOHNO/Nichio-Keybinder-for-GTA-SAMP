<head>
    <link rel="stylesheet" href="style.css">
    <link rel="icon" href="http://nichio.de/icon.png">
</head>

<?php
    require("mysql.php");
    require("builder.php");


    if (isset($_SESSION["UUID"])) {
        //header("Location: dashboard.php");
        //return;
    }

    drawNavbar();

    if (isset($_SESSION["UUID"])) {
        
    }
?>

<center style="padding-top: 100px">
    <img src="icon100px.png" style="width: 100px; margin-top: 0;"><a style="color: black; font-size: 90px; font-family: Cambria" class="mainfont">ichio</a>
</center>
