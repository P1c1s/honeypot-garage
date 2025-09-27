<?php
header("Content-Type: application/json");
require_once 'connessione.php';

$sql = "
    SELECT 
        d.id,
        d.nome,
        d.cognome,
        d.data_assunzione,
        d.stipendio,
        p.nome_posizione AS posizione
    FROM dipendenti d
    LEFT JOIN posizioni p ON d.id_posizione = p.id
";

$result = $conn->query($sql);

if (!$result) {
    echo json_encode(["error" => "Errore nella query: " . $conn->error]);
    exit;
}

$dipendenti = [];

while ($row = $result->fetch_assoc()) {
    $dipendenti[] = $row;
}

echo json_encode($dipendenti);
?>
