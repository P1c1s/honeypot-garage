<?php
header("Content-Type: application/json");
require_once 'connessione.php';

// Query aggregata per entrate e uscite annuali
$sql = "
    SELECT 
        YEAR(data) AS anno,
        SUM(entrata) AS totale_entrate,
        SUM(uscita) AS totale_uscite,
        SUM(entrata) - SUM(uscita) AS saldo_annuale
    FROM (
        SELECT data_entrata AS data, importo AS entrata, 0 AS uscita FROM entrate
        UNION ALL
        SELECT data_uscita AS data, 0 AS entrata, importo AS uscita FROM uscite
    ) AS movimenti
    GROUP BY anno
    ORDER BY anno DESC
";

$result = $conn->query($sql);

if (!$result) {
    echo json_encode(["error" => "Errore nella query: " . $conn->error]);
    exit;
}

$bilanci = [];

while ($row = $result->fetch_assoc()) {
    $bilanci[] = [
        "anno" => $row['anno'],
        "entrate" => number_format($row['totale_entrate'], 2, '.', ''),
        "uscite" => number_format($row['totale_uscite'], 2, '.', ''),
        "saldo" => number_format($row['saldo_annuale'], 2, '.', '')
    ];
}

echo json_encode($bilanci);
?>
