<?php
header('Content-Type: application/json');

// Includi la connessione al database
require_once "connessione.php";

try {
    // Query per recuperare tutti i dipendenti con il titolo della posizione
    $sql = "
        SELECT 
            d.id_dipendente,
            d.nome,
            d.cognome,
            p.titolo AS posizione,
            d.data_assunzione,
            d.stipendio_mensile
        FROM dipendenti d
        LEFT JOIN posizioni p ON d.id_posizione = p.id_posizione
        ORDER BY d.id_dipendente
    ";

    $result = $conn->query($sql);

    if(!$result) {
        throw new Exception("Errore nella query: " . $conn->error);
    }

    $dipendenti = [];

    while($row = $result->fetch_assoc()) {
        $dipendenti[] = $row;
    }

    echo json_encode($dipendenti, JSON_UNESCAPED_UNICODE);

} catch(Exception $e) {
    echo json_encode([
        "error" => $e->getMessage()
    ]);
}

// Chiudi la connessione
$conn->close();
?>
