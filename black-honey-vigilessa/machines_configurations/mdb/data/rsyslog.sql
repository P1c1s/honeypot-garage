--  Create a new user rsyslog with Xg9mbighkQj0 as password
CREATE USER IF NOT EXISTS 'rsyslog'@'%' IDENTIFIED BY 'Xg9mbighkQj0';
GRANT ALL PRIVILEGES ON *.* TO 'rsyslog'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

--  Create a new databaase rsyslogdb
DROP DATABASE IF EXISTS rsyslogdb;
CREATE DATABASE rsyslogdb;
USE rsyslogdb;

--  Create a new table SystemEvents where are stored logging data
CREATE TABLE SystemEvents (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Message TEXT NOT NULL,
    Facility VARCHAR(255),
    FromHost VARCHAR(255),
    Priority INT,
    DeviceReportedTime DATETIME,
    ReceivedAt DATETIME,
    InfoUnitID VARCHAR(255),
    SysLogTag VARCHAR(255)
);
