<?php
include 'connessione.php';

$sql = "SELECT d.id, d.nome, d.cognome, p.nome AS posizione, r.nome AS reparto, d.salario
        FROM dipendenti d
        JOIN posizioni p ON d.posizione_id = p.id
        JOIN reparti r ON d.reparto_id = r.id";

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
