<?php

require_once ('functions.inc');

////prevent access if they haven't submitted the form
//if (!isset($_POST['submit'])) {
//    die(header("Location: login.php"));
//}

$name = $_POST['gameName'];
$walletSize = $_POST['walletSize'];
$multiplier = $_POST['multiplier'];

$_SESSION['formAttempt'] = true;

if (isset($_SESSION['error'])) {
    unset($_SESSION['error']);
}
$_SESSION['error'] = array();
$returnValue = array();

$required = array("gameName","walletSize", "multiplier");

//Check required fields
foreach ($required as $requiredField) {
    if (!isset($_POST[$requiredField]) || $_POST[$requiredField] == "") {
        $_SESSION['error'][] = $requiredField . " is required.";
        $returnValue['error'][] = $requiredField . "is required.";
    }
}

//Check if that user already submitted data for the given game, (no player can go twice on the same game)
//...
//...

$mysqli = new mysqli(DBHOST, DBUSER, DBPASS, DB);
if ($mysqli->connect_errno) {
    error_log("Cannot connect to MySQL: " . $mysqli->connect_errno);
    print "<div>error in make-game-process.php line 35</div>";
    return false;
}

$safeName = $mysqli->real_escape_string($name);
$query = "SELECT * FROM Population WHERE email = '{$safeUser}'";

if (!$result = $mysqli->query($query)) {
    error_log("Cannot retrieve account for {$user}");
    return false;
}

//Will be only one row, so no while() loop needed
$row = $result->fetch_assoc();
$dbPassword = $row['password'];

if (crypt($incomingPassword, $dbPassword) != $dbPassword) {
    error_log("Passwords for {$user} don't match");
    return false;
}
$this->userId = $row['userId'];
$this->name = $row['name'];
$this->email = $row['email'];
$this->registrationType = $row['registrationType'];
$this->isLoggedIn = true;

$this->_setSession();

return true;


//insert form data into database PublicGoodData
//...
?>