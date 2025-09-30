<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = "[2a04:0:0:1::3]";
$user = "pluto";
$pass = "pluto";
$dbname = "azienda";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
  die(json_encode(["error" => "Connessione fallita: " . $conn->connect_error]));
}
?>
