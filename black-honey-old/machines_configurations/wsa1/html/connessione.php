<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = "mdb.theboys.it";
$user = "pluto";
$pass = "pluto";
$dbname = "azienda";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
  die(json_encode(["error" => "Connessione fallita: " . $conn->connect_error]));
}
?>
