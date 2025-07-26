<?php
include 'connessione.php';

$sql = "SELECT * FROM allocazione_costi_reparti ORDER BY anno DESC, mese DESC";
$result = $conn->query($sql);
$data = [];

if ($result) {
  while($row = $result->fetch_assoc()) {
    $data[] = $row;
  }
}

header('Content-Type: application/json');
echo json_encode($data);
$conn->close();
?>
