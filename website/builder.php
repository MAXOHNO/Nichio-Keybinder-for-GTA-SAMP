<?php

    if (!isset($_SESSION)) { 
        session_start();
    }

    if (isset($_COOKIE["session"])) {
        $stmt = $conn->prepare("SELECT * FROM users WHERE LOGINTOKEN = :tkn");
        $stmt->bindParam("tkn", $_COOKIE["session"]);
        $stmt->execute();

        $row = $stmt->fetch();
        $_SESSION["UUID"] = $row["UUID"];
    }

    function getEmailByUUID() {
        
    }

    function genUUID($data = null) {
		// Generate 16 bytes (128 bits) of random data or use the data passed into the function.
		$data = $data ?? random_bytes(16);
		assert(strlen($data) == 16);

		// Set version to 0100
		$data[6] = chr(ord($data[6]) & 0x0f | 0x40);
		// Set bits 6-7 to 10
		$data[8] = chr(ord($data[8]) & 0x3f | 0x80);

		// Output the 36 character UUID.
		return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
	}

    function drawNavbar() {
        ?>
            <center>

            <table class="mainfont" style="padding-top: 20px; display: inline-block">

                <tr>
                    <td class="frontpageTD" style="padding-left: 50px">
                        <a style="text-decoration: none; color: white" href="index.php"> Frontpage </a>
                    </td>

                    <td class="frontpageTD">
                        <a style="text-decoration: none; color: white" href="account.php"> Account </a>
                    </td>

                    <td class="frontpageTD">
                        <a style="text-decoration: none; color: white" href="view.php"> Online </a>
                    </td>

                    <?php
                        if (isset($_SESSION["UUID"])) {
                            ?>

                                <td class="frontpageTD">
                                    <a style="text-decoration: none; color: white" href="logout.php"> Logout </a>
                                </td>

                            <?php
                        }
                    ?>

                </tr>

            </table>

            <table class="mainfont" style="margin-left: 50px; padding-top: 20px; display: inline-block">
                    <tr>
                        <td class="frontpageTD" style="padding-left: 20px; padding-right: 20px">
                            <a style="text-decoration: none; color: white" href="https://nichio.de/dl/installer.exe"> Download </a>
                        </td>
                    </tr>
            </table>

            </center>
        <?php
    }

?>