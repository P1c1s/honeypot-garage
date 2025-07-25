-- Creazione dell'utente MySQL e concessione dei privilegi
CREATE USER IF NOT EXISTS 'pluto'@'%' IDENTIFIED BY 'pluto';
GRANT ALL PRIVILEGES ON *.* TO 'pluto'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Creazione del database e delle tabelle
CREATE DATABASE IF NOT EXISTS azienda_finanza;
USE azienda_finanza;

-- Tabella delle aziende
CREATE TABLE aziende (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    settore VARCHAR(100),
    paese VARCHAR(50),
    data_fondazione DATE
);

-- Tabella dei bilanci annuali
CREATE TABLE bilanci_annuali (
    id INT AUTO_INCREMENT PRIMARY KEY,
    azienda_id INT,
    anno INT,
    ricavi DECIMAL(15,2),
    costi DECIMAL(15,2),
    utile_netto DECIMAL(15,2),
    totale_attivo DECIMAL(15,2),
    totale_passivo DECIMAL(15,2),
    FOREIGN KEY (azienda_id) REFERENCES aziende(id)
);

-- Dati fittizi per la tabella aziende
INSERT INTO aziende (nome, settore, paese, data_fondazione) VALUES
('TechNova S.p.A.', 'Tecnologia', 'Italia', '2001-06-15'),
('GreenEnergy S.r.l.', 'Energia', 'Germania', '1999-03-12'),
('MediPharma Ltd.', 'Farmaceutico', 'UK', '1985-09-01'),
('AgroWorld Inc.', 'Agricoltura', 'USA', '2010-01-20'),
('AutoMotiveX', 'Automobilistico', 'Francia', '1975-07-30');

-- Dati fittizi per la tabella bilanci_annuali
INSERT INTO bilanci_annuali (azienda_id, anno, ricavi, costi, utile_netto, totale_attivo, totale_passivo) VALUES
(1, 2022, 15000000.00, 10000000.00, 5000000.00, 20000000.00, 8000000.00),
(1, 2023, 17000000.00, 11000000.00, 6000000.00, 22000000.00, 9000000.00),
(2, 2022, 8000000.00, 5000000.00, 3000000.00, 12000000.00, 4000000.00),
(2, 2023, 8500000.00, 5200000.00, 3300000.00, 12500000.00, 4200000.00),
(3, 2022, 20000000.00, 15000000.00, 5000000.00, 30000000.00, 10000000.00),
(3, 2023, 21000000.00, 16000000.00, 5000000.00, 31000000.00, 10500000.00),
(4, 2022, 5000000.00, 3000000.00, 2000000.00, 8000000.00, 2500000.00),
(4, 2023, 6000000.00, 3200000.00, 2800000.00, 8500000.00, 2700000.00),
(5, 2022, 25000000.00, 18000000.00, 7000000.00, 40000000.00, 15000000.00),
(5, 2023, 26000000.00, 18500000.00, 7500000.00, 42000000.00, 15500000.00);