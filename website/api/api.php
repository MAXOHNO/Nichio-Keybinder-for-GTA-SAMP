
<?php

    class API {

        function Select() {

            require("mysql.php");

            $response = array(
                "response" => "empty",
                "login" => "false",
            );

            function getUUIDbyEmail($conn, $email) {
                $stmt = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
                $stmt->bindParam("em", $email);
                $stmt->execute();
                $row = $stmt->fetch();

                $uuid = $row["UUID"];
                return $uuid;
            }

            function getRealIpAddr(){
                if ( !empty($_SERVER['HTTP_CLIENT_IP']) ) {
                    // Check IP from internet.
                    $ip = $_SERVER['HTTP_CLIENT_IP'];
                } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']) ) {
                    // Check IP is passed from proxy.
                    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
                } else {
                    // Get IP address from remote address.
                    $ip = $_SERVER['REMOTE_ADDR'];
                }
                return $ip;
            } 

            // user login, wenn erfolgreich, $response["login"] = true
            if (isset($_GET["email"]) && isset($_GET["password"])) {

                $getemail = explode(":", $_GET["email"]);
                // hier wird email gesetzt lol
                $email = $getemail[0];
                if (isset($getemail[1])) {
                    $desk = $getemail[1];
                }
                $pw = $_GET["password"];

                $stmt = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
                $stmt->bindParam("em", $email);
                $stmt->execute();

                $count = $stmt->rowCount();

                if ($count == 1) {

                    $row = $stmt->fetch();
                    
                    if ($row["PASSWORD"] == $pw) {

                        $response["login"] = true;

                        $stmt = $conn->prepare("UPDATE users SET DESKTOP = :dsk WHERE EMAIL = :em");
                        $stmt->bindParam("dsk", $desk);
                        $stmt->bindParam("em", $email);
                        $stmt->execute();

                    }

                } 
            }

            // request verarbeitung
            if (isset($_GET["request"])) {
                if ($response["login"] == true) {

                    // format: request=getWaffendealerpakete:getDrogendealerpakete:getKills
                    $requests = explode(":", $_GET["request"]);

                    for ($i = 0; $i < count($requests); $i++) {

                        $request = $requests[$i];

                        $stmt = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
                        $stmt->bindParam("em", $email);
                        $stmt->execute();
                        $row = $stmt->fetch();

                        $uuid = $row["UUID"];

                        $stmt = $conn->prepare("SELECT * FROM settings WHERE UUID = :uuid");
                        $stmt->bindParam("uuid", $uuid);
                        $stmt->execute();
                        $row = $stmt->fetch();

                        if ($request == "getWaffendealerpakete") {
                            $response["getWaffendealerpakete"] = $row["WAFFENDEALERPAKETE"];

                        } else if ($request == "getDrogendealerpakete") {
                            $response["getDrogendealerpakete"] = $row["DROGENDEALERPAKETE"];

                        } else if ($request == "getTarget") {
                            $response["getTarget"] = $row["TARGET"];

                        } else if ($request == "getHelfer") {
                            $response["getHelfer"] = $row["HELFER"];

                        } else if ($request == "getKills") {
                            $response["getKills"] = $row["KILLS"];

                        } else if ($request == "getKillspruch") {
                            $response["getKillspruch"] = $row["KILLSPRUCH"];

                        } else if ($request == "getGangspruch") {
                            $response["getGangspruch"] = $row["GANGSPRUCH"];

                        } else if ($request == "getPickspruch") {
                            $response["getPickspruch"] = $row["PICKSPRUCH"];

                        } else if ($request == "getJaspruch") {
                            $response["getJaspruch"] = $row["JASPRUCH"];

                        } else if ($request == "getNeinspruch") {
                            $response["getNeinspruch"] = $row["NEINSPRUCH"];

                        } else if ($request == "getOnline") {
                            $stmt = $conn->prepare("SELECT INGAMENAME from users WHERE LAST_ONLINE > :past");
                                $past = time() - 2;
                            $stmt->bindParam("past", $past);
                            $stmt->execute();

                            $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

                            $userString = "";
                            for ($i = 0; $i < count($result); $i++) {
                                $userString = $userString . $result[$i]["INGAMENAME"] . "&";
                            }

                            $response["getOnline"] = $userString;


                        } else if ($request == "getNewMSG") {

                            if (isset($_GET["chatTimestamp"])) {
                                $stmt = $conn->prepare("SELECT * FROM chat WHERE TIMESTAMP > :ts ORDER BY TIMESTAMP ASC");
                                $stmt->bindParam("ts", $_GET["chatTimestamp"]);
                                $stmt->execute();

                                $chat = $stmt->fetchAll(PDO::FETCH_ASSOC);

                                $author = $conn->prepare("SELECT * FROM users WHERE UUID = :uuid");
                                $author->bindParam("uuid", $chat[0]["UUID"]);
                                $author->execute();
                                $author = $author->fetch();
                                $author = $author["INGAMENAME"];


                                $response["getNewMSG"] = $chat[0]["MESSAGE"];
                                $response["getNewMSGAuthor"] = $author;
                                $response["getNewMSGTimestamp"] = doubleval($chat[0]["TIMESTAMP"]);
                            }
 
                        }  else if ($request == "sendMSG") {

                            if (isset($_GET["msg"])) {

                                $stmt = $conn->prepare("INSERT INTO chat (UUID, MESSAGE, TIMESTAMP) VALUES (:uuid, :msg, :ts)");

                                $timestamp = microtime(true);
                                $response["test"] = $timestamp;
                                $message = $_GET["msg"];
                                // ** get Username by UUID

                                $uuid = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
                                $uuid->bindParam("em", $email);
                                $uuid->execute();
                                $uuid = $uuid->fetch();

                                $uuid = $uuid["UUID"];
                                // **

                                $stmt->bindParam("ts", $timestamp );
                                $stmt->bindParam("uuid", $uuid);
                                $stmt->bindParam("msg", $message);
                                $stmt->execute();


                                $chat = $stmt->fetchAll(PDO::FETCH_ASSOC);

                            }
 
                        } else if ($request == "setKills") {

                            if (isset($_GET["kills"])) {

                                $stmt = $conn->prepare("UPDATE settings SET KILLS = :k WHERE UUID = :uuid");
                                $stmt->bindParam("k", $_GET["kills"]);
                                $uuid = getUUIDbyEmail($conn, $email);
                                $stmt->bindParam("uuid", $uuid);
                                $stmt->execute();

                            }
                        }

                    }
                }
            }

            if (isset($response["login"]) && $response["login"] == true) {

                if (isset($_GET["useLotto"])) {
                    $stmt = $conn->prepare("UPDATE stats SET LOTTOS = LOTTOS + 1 WHERE UUID = :uuid");
                    $uuid = getUUIDbyEmail($conn, $email);
                    $stmt->bindParam("uuid", $uuid);
                    $stmt->execute();
                }

                if (isset($_GET["useDrogen"])) {
                    $stmt = $conn->prepare("UPDATE stats SET USEDROGEN = USEDROGEN + 1 WHERE UUID = :uuid");
                    $uuid = getUUIDbyEmail($conn, $email);
                    $stmt->bindParam("uuid", $uuid);
                    $stmt->execute();
                }

                if (isset($_GET["useLotto"])) {
                    $stmt = $conn->prepare("UPDATE stats SET USESPICE = USESPICE + 1 WHERE UUID = :uuid");
                    $uuid = getUUIDbyEmail($conn, $email);
                    $stmt->bindParam("uuid", $uuid);
                    $stmt->execute();
                }

                if (isset($_GET["useWT"])) {
                    $stmt = $conn->prepare("UPDATE stats SET USEWT = USEWT + :wt WHERE UUID = :uuid");

                    $uuid = getUUIDbyEmail($conn, $email);
                    $wt = $_GET["useWT"];

                    $stmt->bindParam("uuid", $uuid);
                    $stmt->bindParam("wt", $wt);
                    $stmt->execute();
                }
            }

            // user loggen fürs dashboard falls query gesetzt ist
            if (isset($_GET["query"])) {

                $query = $_GET["query"];
                // format = COMPUTERNAME+USERNAME+INGAMENAME
                $split = explode(":", $query);

                if (count($split) >= 4) {
                    
                    // example api here
                    $email = $split[0];
                    $cpn = $split[1];
                    $usn = $split[2];
                    $ign = $split[3];
                    $ip = getRealIpAddr();

                    $lo = time();

                    $statement = $conn->prepare("SELECT * FROM users WHERE EMAIL = :em");
                    $statement->bindParam("em", $email);
                    $statement->execute();
                    $count = $statement->rowCount();


                    if ($count == 1) {
                        $statement = $conn->prepare("UPDATE users SET 
                            INGAMENAME = :ign,
                            IP = :ip,
                            LAST_ONLINE = :lo,
                            PLAYTIME = :pt,
                            USERNAME = :us,
                            COMPUTERNAME = :cpn
                            WHERE EMAIL = :em");

                        if ($ign == "") {
                            // falls kein IGN gesetzt ist im GET, wird einfach der alte Name gefetcht und eingesetzt ins replace, alternative wäre ganzes prepare statement umschreiben, zu viel arbeit lol
                            $oldname = $conn->prepare("SELECT INGAMENAME FROM users WHERE EMAIL = :em");
                            $oldname->bindParam("em", $email);
                            $oldname->execute();
                            $oldname_res = $oldname->fetchAll();

                            $on = $oldname_res[0]["INGAMENAME"];

                            $statement->bindParam("ign", $on);
                        } else {
                            $statement->bindParam("ign", $ign);
                        }

                        // bekomme alte playtime, neue ist dann alte playtime + 1 (in Sekunden)
                        $oldtime = $conn->prepare("SELECT PLAYTIME FROM users WHERE EMAIL = :em");
                        $oldtime->bindParam("em", $email);
                        $oldtime->execute();
                        $oldtime_res = $oldtime->fetchAll();

                        $ot = $oldtime_res[0]["PLAYTIME"];
                        $pt = $ot + 1;
                        $statement->bindParam("pt", $pt);

                        $statement->bindParam("ip", $ip);
                        $statement->bindParam("lo", $lo);
                        $statement->bindParam("cpn", $cpn);
                        $statement->bindParam("em", $email);
                        $statement->bindParam("us", $usn);

                        $statement->execute();
                        $response["response"] = $email;
                    }

                } 

            }

            return json_encode($response);
        }
    }

    $API = new API;

    header('Content-Type: application/json');
    echo $API->Select();

?>