<?php
header('Content-Type: application/json');
require_once "connessione.php";

try {
    // Recupera tutte le spese mensili, includendo nome e cognome se è uno stipendio
    $sql = "
        SELECT 
            b.id_spesa,
            b.tipo_spesa,
            b.data_riferimento,
            b.importo,
            d.nome,
            d.cognome
        FROM bilancio_mensile b
        LEFT JOIN dipendenti d ON b.id_dipendente = d.id_dipendente
        ORDER BY b.data_riferimento, b.id_spesa
    ";

    $result = $conn->query($sql);

    if(!$result) throw new Exception("Errore nella query: " . $conn->error);

    $bilanci = [];
    while($row = $result->fetch_assoc()) {
        // Se la spesa è uno stipendio, mostra nome e cognome, altrimenti null
        if($row['tipo_spesa'] !== 'Stipendio') {
            $row['nome'] = null;
            $row['cognome'] = null;
        }
        $bilanci[] = $row;
    }

    echo json_encode($bilanci, JSON_UNESCAPED_UNICODE);

} catch(Exception $e) {
    echo json_encode(["error" => $e->getMessage()]);
}

$conn->close();
?>
