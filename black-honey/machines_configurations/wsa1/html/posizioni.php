<?php
header("Content-Type: application/json");
require_once 'connessione.php';

$sql = "SELECT id, nome_posizione, descrizione FROM posizioni";
$result = $conn->query($sql);

if (!$result) {
    echo json_encode(["error" => "Errore nella query: " . $conn->error]);
    exit;
}

$posizioni = [];

while ($row = $result->fetch_assoc()) {
    $posizioni[] = $row;
}

echo json_encode($posizioni);
?>
