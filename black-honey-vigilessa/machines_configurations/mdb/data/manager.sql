-- Creazione utente e permessi
CREATE USER IF NOT EXISTS 'pluto'@'%' IDENTIFIED BY 'pluto';
GRANT ALL PRIVILEGES ON *.* TO 'pluto'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- 1. Creazione database e uso
DROP DATABASE IF EXISTS azienda;
CREATE DATABASE azienda;
USE azienda;

-- 2. Creazione tabelle
CREATE TABLE posizioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_posizione VARCHAR(100) NOT NULL,
    descrizione TEXT
);

CREATE TABLE dipendenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    data_assunzione DATE NOT NULL,
    id_posizione INT,
    stipendio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_posizione) REFERENCES posizioni(id)
);

CREATE TABLE tipo_spesa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_tipo VARCHAR(100) NOT NULL,
    descrizione TEXT
);

CREATE TABLE entrate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_entrata DATE NOT NULL,
    importo DECIMAL(12,2) NOT NULL,
    descrizione VARCHAR(255) DEFAULT NULL
);

CREATE TABLE uscite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_uscita DATE NOT NULL,
    importo DECIMAL(12,2) NOT NULL,
    id_tipo_spesa INT,
    descrizione VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (id_tipo_spesa) REFERENCES tipo_spesa(id)
);

-- 3. Inserimento dati posizioni
INSERT INTO posizioni (nome_posizione, descrizione) VALUES
('Manager', 'Responsabile del coordinamento operativo e della supervisione delle attività aziendali'),
('Direttore', 'Figura apicale incaricata della definizione delle strategie e della gestione complessiva dell’azienda'),
('Amministratore', 'Supervisione delle pratiche amministrative, legali e burocratiche dell’organizzazione'),
('Developer', 'Progettazione, sviluppo e manutenzione di applicazioni e soluzioni software'),
('Designer', 'Ideazione e realizzazione di interfacce grafiche e user experience efficaci e funzionali'),
('Contabile', 'Gestione della contabilità generale, bilanci e adempimenti fiscali'),
('Supporto', 'Assistenza tecnica e gestione delle richieste dei clienti o degli utenti interni'),
('Sistemista', 'Installazione, configurazione e manutenzione di server, reti e infrastrutture IT');


-- 4. Inserimento dati dipendenti
INSERT INTO dipendenti (nome, cognome, data_assunzione, id_posizione, stipendio) VALUES
('Michela', 'Sicurezza', '2023-01-15', 1, 3500.00),
('Giorgia', 'Botteri', '2023-02-10', 2, 2400.00),
('Fabio', 'Zarfagna', '2024-03-05', 6, 2000.00),
('Lorenzo', 'Ricci', '2023-01-20', 8, 2200.00),
('Elisabetta', 'Dinosauro', '2024-04-01', 5, 2700.00),
('Pietro', 'Guerra', '2024-02-25', 2, 2100.00),
('Sara', 'Conti', '2023-03-18', 3, 2100.00),
('Federica', 'Triceratopo', '2023-01-30', 6, 2200.00),
('Chiara', 'Moretti', '2024-04-15', 7, 1800.00),
('Stefano', 'Fodera', '2024-05-01', 5, 2600.00),
('Matteo', 'Righi', '2023-05-01', 5, 1600.00),
('Milena', 'Poddia', '2024-05-01', 7, 1500.00),
('Alessia', 'Bella', '2024-04-01', 4, 2700.00);


-- 5. Inserimento tipi spesa
INSERT INTO tipo_spesa (nome_tipo, descrizione) VALUES
('Affitto', 'Spese di affitto locali'),
('Utenze', 'Spese per elettricità, acqua, gas'),
('Materiale Ufficio', 'Spese per cancelleria e materiale vario'),
('Marketing', 'Spese per campagne pubblicitarie'),
('Formazione', 'Spese per corsi e formazione dipendenti'),
('Manutenzione', 'Spese di manutenzione hardware e software'),
('Stipendi', 'Pagamento stipendi dipendenti');

-- 6. Stored procedure per inserimento stipendi, spese e entrate randomiche con descrizioni robuste

SET @start_date = '2024-01-01';
SET @end_date = CURDATE();

SET @stipendi_id = (SELECT id FROM tipo_spesa WHERE nome_tipo = 'Stipendi');

DELIMITER $$

DROP PROCEDURE IF EXISTS GeneraDatiRandom$$

CREATE PROCEDURE GeneraDatiRandom()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE d_id INT;
  DECLARE d_nome VARCHAR(100);
  DECLARE d_cognome VARCHAR(100);
  DECLARE d_data_ass DATE;
  DECLARE d_stip DECIMAL(10,2);

  DECLARE cur_dip CURSOR FOR SELECT id, nome, cognome, data_assunzione, stipendio FROM dipendenti;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur_dip;

  read_loop: LOOP
    FETCH cur_dip INTO d_id, d_nome, d_cognome, d_data_ass, d_stip;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET @data_inizio = IF(d_data_ass > @start_date, d_data_ass, @start_date);
    SET @anno_inizio = YEAR(@data_inizio);
    SET @mese_inizio = MONTH(@data_inizio);

    SET @anno_fine = YEAR(@end_date);
    SET @mese_fine = MONTH(@end_date);

    WHILE (@anno_inizio < @anno_fine OR (@anno_inizio = @anno_fine AND @mese_inizio <= @mese_fine)) DO
      SET @data_stipendio = STR_TO_DATE(CONCAT(@anno_inizio,'-',@mese_inizio,'-01'), '%Y-%m-%d');

      -- Inserimento stipendio se non esiste
      IF NOT EXISTS (
        SELECT 1 FROM uscite WHERE data_uscita = @data_stipendio AND importo = d_stip AND id_tipo_spesa = @stipendi_id
          AND descrizione = CONCAT('Stipendio ', d_nome, ' ', d_cognome)
      ) THEN
        INSERT INTO uscite (data_uscita, importo, id_tipo_spesa, descrizione)
        VALUES (@data_stipendio, d_stip, @stipendi_id, CONCAT('Stipendio ', d_nome, ' ', d_cognome));
      END IF;

      -- Spese randomiche (0-3)
      SET @num_spese = FLOOR(RAND() * 4);
      WHILE @num_spese > 0 DO
        SET @tipo_spesa_rand = (SELECT id FROM tipo_spesa ORDER BY RAND() LIMIT 1);
        SET @nome_tipo_spesa = (SELECT nome_tipo FROM tipo_spesa WHERE id = @tipo_spesa_rand);

        SET @importo_spesa = ROUND((RAND() * 1000) + 50, 2);

        -- Descrizione spesa con nome tipo e mese/anno
        SET @descrizione_spesa = CONCAT('Pagamento ', @nome_tipo_spesa, ' mese ', LPAD(@mese_inizio, 2, '0'), '/', @anno_inizio);

        INSERT INTO uscite (data_uscita, importo, id_tipo_spesa, descrizione)
        VALUES (@data_stipendio, @importo_spesa, @tipo_spesa_rand, @descrizione_spesa);

        SET @num_spese = @num_spese - 1;
      END WHILE;

      -- Entrate randomiche (0-3)
      SET @num_entrate = FLOOR(RAND() * 4);
      WHILE @num_entrate > 0 DO
        SET @importo_entrata = ROUND((RAND() * 3000) + 500, 2);

        -- Scelta casuale tipo descrizione entrata
        SET @tipo_descrizione_entrata = FLOOR(RAND() * 4) + 1;
        IF @tipo_descrizione_entrata = 1 THEN
          SET @descrizione_entrata = CONCAT('Vendite mese ', LPAD(@mese_inizio, 2, '0'), '/', @anno_inizio);
        ELSEIF @tipo_descrizione_entrata = 2 THEN
          SET @descrizione_entrata = CONCAT('Incasso fatture mese ', LPAD(@mese_inizio, 2, '0'), '/', @anno_inizio);
        ELSEIF @tipo_descrizione_entrata = 3 THEN
          SET @descrizione_entrata = CONCAT('Rimborso spese mese ', LPAD(@mese_inizio, 2, '0'), '/', @anno_inizio);
        ELSE
          SET @descrizione_entrata = CONCAT('Bonus progetto mese ', LPAD(@mese_inizio, 2, '0'), '/', @anno_inizio);
        END IF;

        INSERT INTO entrate (data_entrata, importo, descrizione)
        VALUES (@data_stipendio, @importo_entrata, @descrizione_entrata);

        SET @num_entrate = @num_entrate - 1;
      END WHILE;

      SET @mese_inizio = @mese_inizio + 1;
      IF @mese_inizio > 12 THEN
        SET @mese_inizio = 1;
        SET @anno_inizio = @anno_inizio + 1;
      END IF;

    END WHILE;

  END LOOP;

  CLOSE cur_dip;

END$$

DELIMITER ;

-- 7. Esecuzione procedura per popolare dati
CALL GeneraDatiRandom();
