<?php
    session_start();
    session_destroy();
    setcookie("session", null, time() - 10000 );
    header("Location: index.php");
?>