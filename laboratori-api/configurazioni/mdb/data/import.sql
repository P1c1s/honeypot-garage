-- =========================================
-- CREAZIONE UTENTE MySQL E ASSEGNAZIONE PRIVILEGI
-- =========================================
CREATE USER IF NOT EXISTS 'pluto'@'%' IDENTIFIED BY 'pluto';
GRANT ALL PRIVILEGES ON *.* TO 'pluto'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- =========================================
-- CREAZIONE DATABASE
-- =========================================
CREATE DATABASE IF NOT EXISTS azienda;
USE azienda;

-- =========================================
-- TABELLA POSIZIONI
-- =========================================
CREATE TABLE posizioni (
    id_posizione INT AUTO_INCREMENT PRIMARY KEY,
    titolo VARCHAR(50) NOT NULL,
    stipendio_base DECIMAL(10,2) NOT NULL
);

-- =========================================
-- TABELLA DIPENDENTI
-- =========================================
CREATE TABLE dipendenti (
    id_dipendente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    id_posizione INT,
    data_assunzione DATE,
    stipendio_mensile DECIMAL(10,2),
    FOREIGN KEY (id_posizione) REFERENCES posizioni(id_posizione)
);

-- =========================================
-- TABELLA BILANCIO MENSILE
-- =========================================
CREATE TABLE bilancio_mensile (
    id_spesa INT AUTO_INCREMENT PRIMARY KEY,
    tipo_spesa VARCHAR(50) NOT NULL,
    id_dipendente INT DEFAULT NULL,
    data_riferimento DATE NOT NULL,
    importo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_dipendente) REFERENCES dipendenti(id_dipendente)
);

-- =========================================
-- POPOLAMENTO POSIZIONI
-- =========================================
INSERT INTO posizioni (titolo, stipendio_base) VALUES
('Amministratore Delegato', 3500.00),
('Direttore Marketing', 2200.00),
('Direttore IT', 2400.00),
('Sviluppatore Senior', 1800.00),
('Sviluppatore Junior', 1500.00),
('Contabile', 1600.00),
('Assistente', 1200.00),
('HR Manager', 2000.00),
('Project Manager', 2100.00),
('Supporto Clienti', 1300.00);

-- =========================================
-- POPOLAMENTO DIPENDENTI
-- =========================================
INSERT INTO dipendenti (nome, cognome, id_posizione, data_assunzione, stipendio_mensile) VALUES
('Mario','Rossi',4,'2019-02-15',1800.00),
('Luisa','Bianchi',2,'2018-06-01',2200.00),
('Giovanni','Verdi',6,'2020-03-20',1600.00),
('Anna','Neri',5,'2021-11-10',1500.00),
('Paolo','Gialli',1,'2015-09-05',3550.00),
('Elena','Blu',4,'2020-08-01',1800.00),
('Francesco','Russo',5,'2022-01-20',1550.00),
('Sofia','Ferrari',3,'2017-05-15',2400.00),
('Alessandro','Costa',9,'2016-09-10',2100.00),
('Martina','Marini',8,'2019-07-01',2000.00);

-- =========================================
-- POPOLAMENTO BILANCIO MENSILE (12 MESI 2023)
-- =========================================

-- Loop manuale mese per mese
-- Gennaio 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-01-31',1800.00),
('Stipendio',2,'2023-01-31',2200.00),
('Stipendio',3,'2023-01-31',1600.00),
('Stipendio',4,'2023-01-31',1500.00),
('Stipendio',5,'2023-01-31',3550.00),
('Stipendio',6,'2023-01-31',1800.00),
('Stipendio',7,'2023-01-31',1550.00),
('Stipendio',8,'2023-01-31',2400.00),
('Stipendio',9,'2023-01-31',2100.00),
('Stipendio',10,'2023-01-31',2000.00),
('Affitto',NULL,'2023-01-31',3000.00),
('Utenze',NULL,'2023-01-31',800.00),
('Materiali',NULL,'2023-01-31',500.00);

-- Febbraio 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-02-28',1800.00),
('Stipendio',2,'2023-02-28',2200.00),
('Stipendio',3,'2023-02-28',1600.00),
('Stipendio',4,'2023-02-28',1500.00),
('Stipendio',5,'2023-02-28',3550.00),
('Stipendio',6,'2023-02-28',1800.00),
('Stipendio',7,'2023-02-28',1550.00),
('Stipendio',8,'2023-02-28',2400.00),
('Stipendio',9,'2023-02-28',2100.00),
('Stipendio',10,'2023-02-28',2000.00),
('Affitto',NULL,'2023-02-28',3000.00),
('Utenze',NULL,'2023-02-28',850.00),
('Materiali',NULL,'2023-02-28',600.00);

-- Marzo 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-03-31',1800.00),
('Stipendio',2,'2023-03-31',2200.00),
('Stipendio',3,'2023-03-31',1600.00),
('Stipendio',4,'2023-03-31',1500.00),
('Stipendio',5,'2023-03-31',3550.00),
('Stipendio',6,'2023-03-31',1800.00),
('Stipendio',7,'2023-03-31',1550.00),
('Stipendio',8,'2023-03-31',2400.00),
('Stipendio',9,'2023-03-31',2100.00),
('Stipendio',10,'2023-03-31',2000.00),
('Affitto',NULL,'2023-03-31',3000.00),
('Utenze',NULL,'2023-03-31',820.00),
('Materiali',NULL,'2023-03-31',550.00);

-- Aprile 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-04-30',1800.00),
('Stipendio',2,'2023-04-30',2200.00),
('Stipendio',3,'2023-04-30',1600.00),
('Stipendio',4,'2023-04-30',1500.00),
('Stipendio',5,'2023-04-30',3550.00),
('Stipendio',6,'2023-04-30',1800.00),
('Stipendio',7,'2023-04-30',1550.00),
('Stipendio',8,'2023-04-30',2400.00),
('Stipendio',9,'2023-04-30',2100.00),
('Stipendio',10,'2023-04-30',2000.00),
('Affitto',NULL,'2023-04-30',3000.00),
('Utenze',NULL,'2023-04-30',830.00),
('Materiali',NULL,'2023-04-30',500.00);

-- Maggio 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-05-31',1800.00),
('Stipendio',2,'2023-05-31',2200.00),
('Stipendio',3,'2023-05-31',1600.00),
('Stipendio',4,'2023-05-31',1500.00),
('Stipendio',5,'2023-05-31',3550.00),
('Stipendio',6,'2023-05-31',1800.00),
('Stipendio',7,'2023-05-31',1550.00),
('Stipendio',8,'2023-05-31',2400.00),
('Stipendio',9,'2023-05-31',2100.00),
('Stipendio',10,'2023-05-31',2000.00),
('Affitto',NULL,'2023-05-31',3000.00),
('Utenze',NULL,'2023-05-31',840.00),
('Materiali',NULL,'2023-05-31',500.00);

-- Giugno 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-06-30',1800.00),
('Stipendio',2,'2023-06-30',2200.00),
('Stipendio',3,'2023-06-30',1600.00),
('Stipendio',4,'2023-06-30',1500.00),
('Stipendio',5,'2023-06-30',3550.00),
('Stipendio',6,'2023-06-30',1800.00),
('Stipendio',7,'2023-06-30',1550.00),
('Stipendio',8,'2023-06-30',2400.00),
('Stipendio',9,'2023-06-30',2100.00),
('Stipendio',10,'2023-06-30',2000.00),
('Affitto',NULL,'2023-06-30',3000.00),
('Utenze',NULL,'2023-06-30',850.00),
('Materiali',NULL,'2023-06-30',550.00);

-- LUGLIO 2023
INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
('Stipendio',1,'2023-07-31',1800.00),
('Stipendio',2,'2023-07-31',2200.00),
('Stipendio',3,'2023-07-31',1600.00),
('Stipendio',4,'2023-07-31',1500.00),
('Stipendio',5,'2023-07-31',3550.00),
('Stipendio',6,'2023-07-31',1800.00),
('Stipendio',7,'2023-07-31',1550.00),
('Stipendio',8,'2023-07-31',2400.00),
('Stipendio',9,'2023-07-31',2100.00),
('Stipendio',10,'2023-07-31',2000.00),
('Affitto',NULL,'2023-07-31',3000.00),
('Utenze',NULL,'2023-07-31',850.00),
('Materiali',NULL,'2023-07-31',550.00);

WHILE @anno <= 2025 DO
    SET @giorno := LAST_DAY(CONCAT(@anno,'-',LPAD(@mese,2,'0'),'-01'));
    
    INSERT INTO bilancio_mensile (tipo_spesa, id_dipendente, data_riferimento, importo) VALUES
    ('Stipendio',1,@giorno,1800.00),
    ('Stipendio',2,@giorno,2200.00),
    ('Stipendio',3,@giorno,1600.00),
    ('Stipendio',4,@giorno,1500.00),
    ('Stipendio',5,@giorno,3550.00),
    ('Stipendio',6,@giorno,1800.00),
    ('Stipendio',7,@giorno,1550.00),
    ('Stipendio',8,@giorno,2400.00),
    ('Stipendio',9,@giorno,2100.00),
    ('Stipendio',10,@giorno,2000.00),
    ('Affitto',NULL,@giorno,3000.00),
    ('Utenze',NULL,@giorno,800 + FLOOR(RAND()*100)),  -- piccola variazione casuale
    ('Materiali',NULL,@giorno,500 + FLOOR(RAND()*100)); -- piccola variazione casuale
    
    -- Passaggio al mese successivo
    SET @mese := @mese + 1;
    IF @mese > 12 THEN
        SET @mese := 1;
        SET @anno := @anno + 1;
    END IF;
END WHILE;