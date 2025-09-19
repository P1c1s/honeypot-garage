<?php
header('Content-Type: application/json');
require_once "connessione.php";

try {
    // Aggrega le spese per anno
    $sql = "
        SELECT 
            YEAR(data_riferimento) AS anno,
            SUM(CASE WHEN tipo_spesa = 'Stipendio' THEN importo ELSE 0 END) AS totale_stipendi,
            SUM(CASE WHEN tipo_spesa != 'Stipendio' THEN importo ELSE 0 END) AS altre_spese,
            SUM(importo) AS totale
        FROM bilancio_mensile
        GROUP BY YEAR(data_riferimento)
        ORDER BY anno
    ";

    $result = $conn->query($sql);

    if(!$result) throw new Exception("Errore nella query: " . $conn->error);

    $bilanci_annuali = [];
    while($row = $result->fetch_assoc()) {
        $bilanci_annuali[] = $row;
    }

    echo json_encode($bilanci_annuali, JSON_UNESCAPED_UNICODE);

} catch(Exception $e) {
    echo json_encode(["error" => $e->getMessage()]);
}

$conn->close();
?>
