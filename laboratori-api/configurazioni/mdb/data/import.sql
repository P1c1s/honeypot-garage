-- Creazione dell'utente MySQL e concessione dei privilegi
CREATE USER IF NOT EXISTS 'pluto'@'%' IDENTIFIED BY 'pluto';
GRANT ALL PRIVILEGES ON *.* TO 'pluto'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Creazione del database aziendale realistico
CREATE DATABASE IF NOT EXISTS azienda_completa;
USE azienda_completa;

-- Tabella dei reparti
CREATE TABLE reparti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    descrizione TEXT
);

-- Tabella delle posizioni
CREATE TABLE posizioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titolo VARCHAR(100) UNIQUE NOT NULL,
    descrizione TEXT
);

-- Tabella dei dipendenti con chiavi esterne verso reparti e posizioni
CREATE TABLE dipendenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    data_nascita DATE,
    posizione_id INT,
    reparto_id INT,
    data_assunzione DATE,
    salario DECIMAL(10,2),
    FOREIGN KEY (posizione_id) REFERENCES posizioni(id),
    FOREIGN KEY (reparto_id) REFERENCES reparti(id)
);

-- Tabella dei bilanci mensili
CREATE TABLE bilanci_mensili (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mese INT,
    anno INT,
    ricavi DECIMAL(15,2),
    costi DECIMAL(15,2),
    utile DECIMAL(15,2)
);

-- Tabella dei bilanci annuali
CREATE TABLE bilanci_annuali (
    id INT AUTO_INCREMENT PRIMARY KEY,
    anno INT,
    ricavi_totali DECIMAL(15,2),
    costi_totali DECIMAL(15,2),
    utile_netto DECIMAL(15,2),
    totale_attivo DECIMAL(15,2),
    totale_passivo DECIMAL(15,2)
);

-- Tabella degli stipendi mensili
CREATE TABLE stipendi_mensili (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dipendente_id INT,
    mese INT,
    anno INT,
    stipendio_lordo DECIMAL(10,2),
    tasse DECIMAL(10,2),
    stipendio_netto DECIMAL(10,2),
    FOREIGN KEY (dipendente_id) REFERENCES dipendenti(id)
);

-- Tabella di allocazione dei costi per reparto
CREATE TABLE allocazione_costi_reparti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mese INT,
    anno INT,
    reparto_id INT,
    costo_allocato DECIMAL(12,2),
    FOREIGN KEY (reparto_id) REFERENCES reparti(id)
);

-- Dati fittizi per i reparti
INSERT INTO reparti (nome, descrizione) VALUES
('IT', 'Reparto tecnologico e sviluppo software'),
('Finanza', 'Gestione contabile e finanziaria dell`azienda'),
('Management', 'Supervisione e direzione strategica'),
('Marketing', 'Promozione e branding dei prodotti'),
('Risorse Umane', 'Gestione del personale e risorse umane');

-- Dati fittizi per le posizioni
INSERT INTO posizioni (titolo, descrizione) VALUES
('Ingegnere Software', 'Responsabile dello sviluppo e manutenzione dei software'),
('Contabile', 'Gestione della contabilità aziendale'),
('Direttore Operativo', 'Responsabile delle operazioni aziendali'),
('Designer UX', 'Progetta interfacce utente intuitive ed efficaci'),
('HR Specialist', 'Gestione risorse umane e pratiche di assunzione'),
('Analista Dati', 'Analizza e interpreta dati aziendali'),
('Responsabile Marketing', 'Gestione delle strategie di comunicazione e marketing'),
('Tecnico IT', 'Supporto tecnico e infrastruttura informatica');

-- Dati fittizi per i dipendenti
INSERT INTO dipendenti (nome, cognome, data_nascita, posizione_id, reparto_id, data_assunzione, salario) VALUES
('Luca', 'Rossi', '1985-04-10', 1, 1, '2015-09-01', 3800.00),
('Maria', 'Bianchi', '1990-08-22', 2, 2, '2018-03-15', 3200.00),
('Giovanni', 'Verdi', '1978-12-03', 3, 3, '2010-01-01', 6500.00),
('Sara', 'Neri', '1992-06-19', 4, 4, '2020-06-10', 2900.00),
('Elena', 'Russo', '1987-11-05', 5, 5, '2016-11-25', 3100.00),
('Marco', 'Conti', '1982-02-14', 6, 2, '2017-04-12', 4000.00),
('Francesca', 'De Luca', '1993-09-28', 7, 4, '2021-05-20', 3500.00),
('Alessandro', 'Ferrari', '1988-07-07', 8, 1, '2019-02-01', 3300.00);

-- Dati fittizi per i bilanci mensili
INSERT INTO bilanci_mensili (mese, anno, ricavi, costi, utile) VALUES
(1, 2024, 120000.00, 90000.00, 30000.00),
(2, 2024, 110000.00, 85000.00, 25000.00),
(3, 2024, 130000.00, 95000.00, 35000.00);

-- Dati fittizi per i bilanci annuali
INSERT INTO bilanci_annuali (anno, ricavi_totali, costi_totali, utile_netto, totale_attivo, totale_passivo) VALUES
(2022, 1350000.00, 1050000.00, 300000.00, 2200000.00, 800000.00),
(2023, 1420000.00, 1100000.00, 320000.00, 2300000.00, 850000.00);

-- Dati fittizi per stipendi mensili
INSERT INTO stipendi_mensili (dipendente_id, mese, anno, stipendio_lordo, tasse, stipendio_netto) VALUES
(1, 1, 2024, 3800.00, 800.00, 3000.00),
(2, 1, 2024, 3200.00, 700.00, 2500.00),
(3, 1, 2024, 6500.00, 1600.00, 4900.00),
(4, 1, 2024, 2900.00, 600.00, 2300.00),
(5, 1, 2024, 3100.00, 650.00, 2450.00);

-- Dati fittizi per allocazione dei costi tra reparti
INSERT INTO allocazione_costi_reparti (mese, anno, reparto_id, costo_allocato) VALUES
(1, 2024, 1, 22000.00),
(1, 2024, 2, 15000.00),
(1, 2024, 3, 18000.00),
(1, 2024, 4, 12000.00),
(1, 2024, 5, 13000.00),
(2, 2024, 1, 21000.00),
(2, 2024, 2, 14000.00),
(2, 2024, 3, 17000.00),
(2, 2024, 4, 11500.00),
(2, 2024, 5, 12500.00);
