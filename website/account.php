<?php
    if (isset($_POST["log"])) {
        $token = bin2hex(random_bytes(32));
        setcookie("session", $token, time() + (3600*24*60*60) );
    }
?>

<head>
    <link rel="stylesheet" href="style.css">
    <link rel="icon" href="http://nichio.de/icon.png">

    <style>

        .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
        }

        .switch input { 
        opacity: 0;
        width: 0;
        height: 0;
        }

        .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #3ACB97;
        -webkit-transition: .4s;
        transition: .4s;
        }

        .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
        }

        input:checked + .slider {
        background-color: #2196F3;
        }

        input:focus + .slider {
        box-shadow: 0 0 1px #2196F3;
        }

        input:checked + .slider:before {
        -webkit-transform: translateX(26px);
        -ms-transform: translateX(26px);
        transform: translateX(26px);
        }

        /* Rounded sliders */
        .slider.round {
        border-radius: 34px;
        }

        .slider.round:before {
        border-radius: 50%;
        }
    </style>

    <script>

        var state = "login";
        var loginform = document.getElementById("loginform");
        var registerform = document.getElementById("registerform");

        function toggleLogin() {

            if (state == "login") {
                state = "register";
                document.getElementById("registerform").style.display = "table-cell";
                document.getElementById("loginform").style.display = "none";
            } else {
                state = "login";
                document.getElementById("loginform").style.display = "table-cell";
                document.getElementById("registerform").style.display = "none";
            }
        }

    </script>
</head>

<?php
    require("mysql.php");
    require("builder.php");

    if (isset($_SESSION["UUID"])) {
        //header("Location: dashboard.php");
        //return;
    }

    drawNavbar();
?>

<center>

<?php
    if (isset($_SESSION["UUID"])) {
        ?>
            <form action="account.php" method="POST">
                <table class="mainfont">

                    <?php
                        $stmt = $conn->prepare("SELECT * FROM settings WHERE UUID = :uuid");
                        $stmt->bindParam("uuid", $_SESSION["UUID"]);
                        $stmt->execute();

                        $row = $stmt->fetch();
                    ?>

                    <tr>
                        <td>
                            Waffenpakete:
                        </td>

                        <td style="padding-right: 50px">
                            <input type="text" name="wdp" required value="<?php echo $row["WAFFENDEALERPAKETE"];?>" > </input>
                        </td>

                        <td>
                            Drogenpakete:
                        </td>

                        <td>
                            <input type="text" name="ddp" required value="<?php echo $row["DROGENDEALERPAKETE"];?>" > </input>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding-right: 20px">
                            /ja-Spruch:
                        </td>

                        <td>
                            <input type="text" name="js"  value="<?php echo $row["JASPRUCH"];?>" > </input>
                        </td>

                        <td style="padding-right: 20px">
                            /auf-Spruch:
                        </td>

                        <td>
                            <input type="text" name="ns" required value="<?php echo $row["NEINSPRUCH"];?>" > </input>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding-right: 20px">
                            /pick-Spruch:
                        </td>

                        <td>
                            <input type="text" name="ps" required value="<?php echo $row["PICKSPRUCH"];?>" > </input>
                        </td>

                        <td style="padding-right: 20px">
                            Gang-Spruch:
                        </td>

                        <td>
                            <input type="text" name="gs" required value="<?php echo $row["GANGSPRUCH"];?>" > </input>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding-right: 20px">
                            Kill-Spruch:
                        </td>

                        <td>
                            <input type="text" name="ks" required value="<?php echo $row["KILLSPRUCH"];?>" > </input>
                        </td>

                        <td style="padding-right: 20px">
                            Kills:
                        </td>

                        <td>
                            <input type="text" name="k" required value="<?php echo $row["KILLS"];?>" > </input>
                        </td>

                    </tr>

                    <tr>
                        <td colspan="4" style="padding-top: 30px">
                            <button type="submit" name="save" style="width: 100%; color: black" class="mainfont"> Save </button>
                        </td>
                    </tr>

                </table>

            </form>

            <table class="mainfont">

                <?php
                    $stmt = $conn->prepare("SELECT * FROM stats WHERE UUID = :uuid");
                    $stmt->bindParam("uuid", $_SESSION["UUID"]);
                    $stmt->execute();

                    $row = $stmt->fetch();
                ?>

                <tr>
                    <td class="statsTDText">
                        <b> Verbrauchte Drogen: </b>
                    </td>

                    <td class="statsTDNumber" style="padding-right: 100px">
                        <?php echo $row["USEDROGEN"]; ?>
                    </td>

                    <td class="statsTDText">
                        <b> Verbrauchtes Spice: </b>
                    </td>

                    <td class="statsTDNumber">
                        <?php echo $row["USESPICE"]; ?>
                    </td>
                </tr>

                <tr>
                    <td class="statsTDText">
                        <b> Verbrauchte WT: </b>
                    </td>

                    <td class="statsTDNumber">
                        <?php echo $row["USEWT"]; ?>
                    </td>

                    <td class="statsTDText">
                        <b> Gesamtverbrauch: </b>
                    </td>

                    <td class="statsTDNumber">
                        $<?php echo $row["USEWT"] * 25 + $row["USEDROGEN"] * 400 + $row["USESPICE"] * 1500; ?>
                    </td>
                </tr>

            </table>
        <?php
    } else {
        ?>

            <table class="mainfont" style="padding-top: 10px; padding-bottom: 15px; padding-left: 70px; padding-right: 70px;" >
                <tr>
                    <td style="padding-left: 10px; padding-right: 10px">
                        Login
                    </td>
                    
                    <td style="padding-left: 10px">
                        <!-- Rounded switch -->
                        <center>
                            <label class="switch">
                            <input onclick="toggleLogin()" type="checkbox">
                            <span class="slider round"></span>
                            </label>
                        </center>
                    </td>

                    <td>
                        Register
                    </td>
                </tr>
            </table>

            <form action="account.php" method="POST">

                <table class="mainfont" style="margin-top: 20px">

                    <tr>
                        <td>
                            Email:
                        </td>

                        <td>
                            <input type="text" name="email" required> </input>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding-right: 20px">
                            Password:
                        </td>

                        <td>
                            <input type="password" name="pw" required> </input>
                        </td>

                    </tr>

                    <tr>
                        <td colspan="2" style="padding-top: 30px" id="loginform">
                            <button type="submit" name="log" style="width: 100%; color: black" class="mainfont"> Login </button>
                        </td>

                        <td colspan="2" style="padding-top: 30px; display: none" id="registerform">
                            <button type="submit" name="reg" style="width: 100%; color: black" class="mainfont"> Register </button>
                        </td>
                    </tr>

                </table>
            </form>

        <?php
    }
?>

<?php
    if (isset($_POST["log"])) {
        // todo regex stuff email & pw < 32 chars

        $email = $_POST["email"];
        $pw = $_POST["pw"];

        $stmt = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
        $stmt->bindParam("em", $email);
        $stmt->execute();

        $count = $stmt->rowCount();

        if ($count == 1) {

            $row = $stmt->fetch();

            if (md5($pw) == $row["PASSWORD"]) {

                

                $stmt = $conn->prepare("UPDATE users SET LOGINTOKEN = :tkn WHERE UUID = :uuid");
                $stmt->bindParam("uuid", $row["UUID"]);
                $stmt->bindParam("tkn", $token);
                $stmt->execute();

                $_SESSION["UUID"] = $row["UUID"];

                //header("Location: dashboard.php");
                echo '<meta http-equiv="refresh" content="0" />';
            } else {
                echo "Wrong password :/";
            }

            

        } else {
            echo "Account not found, sorry.";
        }
    }
    
    if (isset($_POST["reg"])) {
        // todo regex stuff email & pw < 32 chars

        $email = $_POST["email"];
        $pw = $_POST["pw"];

        if (!isset($pw) || !isset($email)) {
            echo "pls fill out email and password <3";
            return;
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            echo "pls enter a correct email";
            return;
        }

        if (!(strlen($pw) > 7 && strlen($pw) < 32)) {
            echo "pls enter strong password between 8 and 32 characters";
            return;
        }

        $stmt = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
        $stmt->bindParam("em", $email);
        $stmt->execute();

        $count = $stmt->rowCount();

        if ($count == 0) {

            $stmt = $conn->prepare("INSERT INTO users (EMAIL, PASSWORD, UUID) VALUES (:em, :pw, :uuid)");
            $stmt->bindParam("em", $email);
            $hashed_pw = md5($pw);
            $stmt->bindParam("pw", $hashed_pw);

            $isUnique = false;
            while (!($isUnique)) {
                $uuid = genUUID();
                $test = $conn->prepare("SELECT * FROM users WHERE UUID = :uuid");
                $test->bindParam("uuid", $uuid);
                $test->execute();
                $count = $test->rowCount();

                if ($count == 0) {
                    $isUnique = true;
                }
            }

            $stmt->bindParam("uuid", $uuid);
            $stmt->execute();



            $stmt = $conn->prepare("INSERT INTO settings (UUID) VALUES (:uuid)");
            $stmt->bindParam("uuid", $uuid);
            $stmt->execute();

            $stmt = $conn->prepare("INSERT INTO stats (UUID) VALUES (:uuid)");
            $stmt->bindParam("uuid", $uuid);
            $stmt->execute();

            $_SESSION["UUID"] = $uuid;
                
            //header("Location: dashboard.php");
            echo '<meta http-equiv="refresh" content="0" />';

        } else {
            echo "Email is already taken, sorry.";
        }
    }

    if (isset($_POST["save"])) {
        // todo regex stuff email & pw < 32 chars

        $stmt = $conn->prepare("UPDATE settings SET
                WAFFENDEALERPAKETE = :wdp,
                DROGENDEALERPAKETE = :ddp,
                KILLS = :k,
                KILLSPRUCH = :ks,
                GANGSPRUCH = :gs,
                PICKSPRUCH = :ps,
                JASPRUCH = :js,
                NEINSPRUCH = :ns
                WHERE UUID = :uuid");
        $stmt->bindParam("wdp", $_POST["wdp"]);
        $stmt->bindParam("ddp", $_POST["ddp"]);
        $stmt->bindParam("k", $_POST["k"]);
        $stmt->bindParam("ks", $_POST["ks"]);
        $stmt->bindParam("gs", $_POST["gs"]);
        $stmt->bindParam("ps", $_POST["ps"]);
        $stmt->bindParam("js", $_POST["js"]);
        $stmt->bindParam("ns", $_POST["ns"]);
        $stmt->bindParam("uuid", $_SESSION["UUID"]);
        $stmt->execute();

        echo "<META HTTP-EQUIV='refresh' CONTENT='0'>";
    }
?>

</center>