CREATE DATABASE Bilcenter;
USE Bilcenter;

-- Skapa tabellen för "Kunder"
CREATE TABLE Kunder (
    KundID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Epost VARCHAR(100) UNIQUE NOT NULL,
    Telefonnummer VARCHAR(20),
    Adress TEXT
);

-- Skapa tabellen för "Ägare"
CREATE TABLE Ägare (
    ÄgareID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Personnummer VARCHAR(20) UNIQUE NOT NULL,
    Adress TEXT
);

-- Skapa tabellen för "Bilar"
CREATE TABLE Bilar (
    FordonID INT AUTO_INCREMENT PRIMARY KEY,
    Modell VARCHAR(50) NOT NULL,
    År INT NOT NULL,
    Motorstyrka INT NOT NULL,
    Registreringsnummer VARCHAR(20) UNIQUE NOT NULL,
    ÄgareID INT,
    Servicehistorik TEXT,
    Skulder DECIMAL(10,2) DEFAULT 0.00,
    Lagerstatus INT NOT NULL,
    FOREIGN KEY (ÄgareID) REFERENCES Ägare(ÄgareID) ON DELETE SET NULL
);




-- Skapa tabellen för beställningar
CREATE TABLE Beställningar (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT NOT NULL,
    Datum DATE NOT NULL,
    Totalbelopp DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID) ON DELETE CASCADE
);

-- Skapa tabellen för orderrader
CREATE TABLE Orderrader (
    OrderradID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    FordonID INT NOT NULL,
    Pris DECIMAL(10,2) NOT NULL,
    Status ENUM('Beställd', 'Levererad', 'Avbruten') DEFAULT 'Beställd',
    FOREIGN KEY (OrderID) REFERENCES Beställningar(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (FordonID) REFERENCES Bilar(FordonID) ON DELETE CASCADE
);


DROP TRIGGER IF EXISTS Uppdatera_Servicehistorik;


-- Skapa en trigger för att logga ändringar i servicehistoriken
DELIMITER $$

CREATE TRIGGER Uppdatera_Servicehistorik
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    UPDATE Bilar
    SET Servicehistorik = CONCAT(IFNULL(Servicehistorik, ''), CHAR(10), 
                                'Ny beställning: ', NEW.OrderID, ' på ', NOW())
    WHERE FordonID = NEW.FordonID;
END$$

DELIMITER ;


-- Skapa en trigger för att minska lagerstatusen med 1 för den bil som är beställd
DELIMITER $$

CREATE TRIGGER Uppdatera_Lagerstatus
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    -- Minska lagerstatusen med 1 för den bil som är beställd
    UPDATE Bilar
    SET Lagerstatus = Lagerstatus - 1
    WHERE FordonID = NEW.FordonID;
END$$

DELIMITER ;



-- Skapa en lagrad procedur för att räkna ut total försäljning under en viss period
DELIMITER $$
CREATE PROCEDURE TotalFörsäljning(IN startDatum DATE, IN slutDatum DATE)
BEGIN
    SELECT SUM(Totalbelopp) AS TotalFörsäljning FROM Beställningar
    WHERE Datum BETWEEN startDatum AND slutDatum;
END$$
DELIMITER ;

DROP ROLE IF EXISTS 'Admin';


-- Begränsa åtkomst (endast admin kan ändra biluppgifter)
CREATE ROLE Admin;
GRANT ALL PRIVILEGES ON Bilcenter.* TO 'admin'@'localhost';

-- Ge privilegier till användare för att uppdatera eller ta bort på tabellen
CREATE ROLE user;
GRANT UPDATE, DELETE ON Bilar TO 'user'@'localhost';


-- Ta bort privilegier från en användare
REVOKE UPDATE, DELETE ON Bilar FROM 'user'@'localhost';



-- Lägg till kunder
INSERT INTO Kunder (Namn, Epost, Telefonnummer, Adress) VALUES
('Anders Svensson', 'anders.svensson@hotmail.com', '0701234567', 'Stockholm, Sverige'),
('Emma Karlsson', 'emma.karlsson@outlook.com', '0739876543', 'Göteborg, Sverige'),
('Lars Olofsson', 'lars.olofsson@gmail.com', '0739876987', 'Kalmar, Sverige'),
('Emma Lind', 'emma.lind@gmail.com', '0739876713', 'Piteå, Sverige'),
('Johan Lind', 'johan.lind@yahoo.com', '0724567890', 'Malmö, Sverige');

-- Lägg till ägare
INSERT INTO Ägare (Namn, Personnummer, Adress) VALUES
('Lina Svensson', '750101-1234', 'Stockholm, Sverige'),
('Roger Karlsson', '820202-5678', 'Örebro, Sverige'),
('Oskar Ljung', '740202-5678', 'Karlshamn, Sverige'),
('Gösta Eriksson', '900303-9876', 'Kalmar, Sverige');


-- Lägg till bilar
INSERT INTO Bilar (Modell, År, Motorstyrka, Registreringsnummer, ÄgareID, Servicehistorik, Skulder, Lagerstatus) VALUES
('Volvo XC60', 2020, 250, 'ABC123', 1, 'Service utförd 2023-06-10', 1000.00, 5),
('BMW X5', 2019, 300, 'DEF456', 2, 'Byte av bromsar 2023-08-15', 500.00, 2),
('Audi A6', 2021, 280, 'GHI789', 3, 'Oljebyte 2024-01-10', 0.00, 4),
('Audi A8', 2025, 570, 'BLI789', 4, 'Oljebyte 2025-01-20', 0.00, 1);

-- Lägg till beställningar
INSERT INTO Beställningar (KundID, Datum, Totalbelopp) VALUES
(1, '2024-03-01', 450000.00),
(2, '2024-03-05', 550000.00),
(3, '2024-03-10', 600000.00),
(3, '2024-03-10', 600000.00),
(4, '2025-04-23', 1044900.00);

-- Lägg till orderrader
INSERT INTO Orderrader (OrderID, FordonID, Pris, Status) VALUES
(1, 1, 450000.00, 'Beställd'),
(2, 2, 550000.00, 'Levererad'),
(3, 3, 600000.00, 'Beställd'),
(4, 4, 1044900.00, 'Beställd');

-- INNER JOIN – Kunder som har beställningar
SELECT Kunder.Namn, Beställningar.OrderID, Beställningar.Totalbelopp 
FROM Kunder
INNER JOIN Beställningar ON Kunder.KundID = Beställningar.KundID;

-- LEFT JOIN – Visa alla kunder, även de utan beställningar
SELECT Kunder.Namn, Beställningar.OrderID
FROM Kunder
LEFT JOIN Beställningar ON Kunder.KundID = Beställningar.KundID;

-- GROUP BY – Antal beställningar per kund
SELECT KundID, COUNT(OrderID) AS AntalBeställningar
FROM Beställningar
GROUP BY KundID;

-- HAVING – Visa kunder med enbart 2 beställningar eller mer
SELECT KundID, COUNT(OrderID) AS AntalBeställningar 
FROM Beställningar 
GROUP BY KundID 
HAVING COUNT(OrderID) >= 2;

-- Backup av databasen, TERMINAL!
-- mysqldump -u root -p Bilcenter > bilcenter_backup.sql

-- Återställ databasen från backup
-- mysql -u root -p Bilcenter < bilcenter_backup.sql





