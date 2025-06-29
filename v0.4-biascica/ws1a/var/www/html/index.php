<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo 'ole';
$servername = "mdb"; // Cambia con l'indirizzo corretto
$username = "pluto";
$password = "pluto";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

echo "Connected successfully";
$conn->close();
?>
    <!-- CREATE USER 'pippo'@'ip_del_server' IDENTIFIED BY 'pippo'; -->

