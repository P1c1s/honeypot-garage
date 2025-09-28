<?php
header("Content-Type: application/json");
require_once 'connessione.php';

$sql = "
    SELECT 
        id,
        data_entrata,
        importo,
        descrizione
    FROM entrate
    ORDER BY data_entrata DESC
";

$result = $conn->query($sql);

if (!$result) {
    echo json_encode(["error" => "Errore nella query: " . $conn->error]);
    exit;
}

$entrate = [];

while ($row = $result->fetch_assoc()) {
    $entrate[] = $row;
}

echo json_encode($entrate);
?>
