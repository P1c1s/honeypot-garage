<?php
header("Content-Type: application/json");
require_once 'connessione.php';

$sql = "
    SELECT 
        u.id,
        u.data_uscita,
        u.importo,
        ts.nome_tipo AS tipo_spesa,
        u.descrizione
    FROM uscite u
    LEFT JOIN tipo_spesa ts ON u.id_tipo_spesa = ts.id
    ORDER BY u.data_uscita DESC
";

$result = $conn->query($sql);

if (!$result) {
    echo json_encode(["error" => "Errore nella query: " . $conn->error]);
    exit;
}

$uscite = [];

while ($row = $result->fetch_assoc()) {
    $uscite[] = $row;
}

echo json_encode($uscite);
?>
