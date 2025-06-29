<?php
$servername = "mysql-server";
$username = "pippo";
$password = "pippo";

// Create connection
$conn = new mysqli($servername, $username, $password);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

// Create database
// $sql = "CREATE DATABASE myDB";
// if ($conn->query($sql) === TRUE) {
//   echo "Database created successfully";
// } else {
//   echo "Error creating database: " . $conn->error;
// }

$conn->close();
?>
    <!-- CREATE USER 'pippo'@'ip_del_server' IDENTIFIED BY 'pippo'; -->

