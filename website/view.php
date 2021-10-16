<head>
    <link rel="stylesheet" href="style.css">
    <link rel="icon" href="http://nichio.de/icon.png">
</head>

<?php
    require("mysql.php");
    require("builder.php");

    $stmt = $conn->prepare("SELECT * FROM users WHERE PLAYTIME > 0 ORDER BY PLAYTIME DESC");
    $stmt->execute();

    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    function shorten($string, $maxLength) {
        if (strlen($string) <= $maxLength) {
            return substr($string, 0, $maxLength);
        } else {
            return substr($string, 0, $maxLength) . " ...";
        }
        
    }

    drawNavbar();
?>

<center>
<table class="mainfont">

    <tr>

        <?php
        /*<th>
            Email
        </th>*/
        ?>

        <th>
            Name
        </th>

        <th>
            Ingamename
        </th>

        <?php
        /*<th>
            IP-Address
        </th>*/
        ?>

        <th>
            Playtime
        </th>

        <th>
            Last Online
        </th>
    </tr>

    <?php
        for ($i = 0; $i < count($results); $i++) {

            if ($results[$i]["EMAIL"] != "") {

                ?>

                <tr>
                    
                    <?php
                    /*<td>
                        <?php echo shorten($results[$i]["EMAIL"], 32); ?>
                    </td>*/
                    ?>

                    <td>
                        <?php echo shorten($results[$i]["USERNAME"], 16); ?>
                    </td>

                    <td>
                        <?php echo shorten($results[$i]["INGAMENAME"], 16); ?>
                    </td>

                    <?php
                    /*<td>
                        <?php echo shorten($results[$i]["IP"], 16); ?>
                    </td>*/
                    ?>

                    <td>
                        <?php 
                        $pt = $results[$i]["PLAYTIME"];

                        if ($pt == "") {
                            $pt = 0;
                        }
                        
                        if ($pt <= 60) { // Wenn Weniger als 1 Minute, gib in Sekunden aus
                            echo $pt . "s";
                        } else if ($pt <= 7200) { // Wenn Weniger als 2 Stunden, gib in Minuten aus
                            echo intval( $pt / 60) . "min";
                        } else { // Sonst gib in Stunden aus
                            echo intval( $pt / 60 / 60) . "h";
                        }
                        ?>
                    </td>

                    <td>
                        <?php 
                            $last_time = $results[$i]["LAST_ONLINE"];
                            $curr_time = time();

                            if ($last_time == 0) {
                                echo "<a style='color: red'> Never </a>";
                            } else if ($last_time + 2 < $curr_time) {
                                echo date("d.m.Y H:i:s ", $results[$i]["LAST_ONLINE"]); 
                            } else {
                                echo "<a style='color: green'> Online </a>";
                            }

                        ?>
                    </td>
                </tr>

                <?php
            }

        }

    ?>

</table>
</center>