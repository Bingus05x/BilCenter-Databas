-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: Bilcenter
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `beställningar`
--

DROP TABLE IF EXISTS `beställningar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beställningar` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `KundID` int NOT NULL,
  `Datum` date NOT NULL,
  `Totalbelopp` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`OrderID`),
  KEY `KundID` (`KundID`),
  CONSTRAINT `beställningar_ibfk_1` FOREIGN KEY (`KundID`) REFERENCES `kunder` (`KundID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beställningar`
--

LOCK TABLES `beställningar` WRITE;
/*!40000 ALTER TABLE `beställningar` DISABLE KEYS */;
INSERT INTO `beställningar` VALUES (1,1,'2024-03-01',450000.00),(2,2,'2024-03-05',550000.00),(3,3,'2024-03-10',600000.00),(4,3,'2024-03-10',600000.00),(5,4,'2025-04-23',1044900.00);
/*!40000 ALTER TABLE `beställningar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bilar`
--

DROP TABLE IF EXISTS `bilar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bilar` (
  `FordonID` int NOT NULL AUTO_INCREMENT,
  `Modell` varchar(50) NOT NULL,
  `År` int NOT NULL,
  `Motorstyrka` int NOT NULL,
  `Registreringsnummer` varchar(20) NOT NULL,
  `ÄgareID` int DEFAULT NULL,
  `Servicehistorik` text,
  `Skulder` decimal(10,2) DEFAULT '0.00',
  `Lagerstatus` int NOT NULL,
  PRIMARY KEY (`FordonID`),
  UNIQUE KEY `Registreringsnummer` (`Registreringsnummer`),
  KEY `ÄgareID` (`ÄgareID`),
  KEY `idx_registreringsnummer` (`Registreringsnummer`),
  CONSTRAINT `bilar_ibfk_1` FOREIGN KEY (`ÄgareID`) REFERENCES `ägare` (`ÄgareID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bilar`
--

LOCK TABLES `bilar` WRITE;
/*!40000 ALTER TABLE `bilar` DISABLE KEYS */;
INSERT INTO `bilar` VALUES (1,'Volvo XC60',2020,250,'ABC123',1,'Service utförd 2023-06-10\nNy beställning: 1 på 2025-03-25 13:52:43',1000.00,4),(2,'BMW X5',2019,300,'DEF456',2,'Byte av bromsar 2023-08-15\nNy beställning: 2 på 2025-03-25 13:52:43',500.00,1),(3,'Audi A6',2021,280,'GHI789',3,'Oljebyte 2024-01-10\nNy beställning: 3 på 2025-03-25 13:52:43',0.00,3),(4,'Audi A8',2025,570,'BLI789',4,'Oljebyte 2025-01-20\nNy beställning: 4 på 2025-03-25 13:52:43',0.00,0);
/*!40000 ALTER TABLE `bilar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kunder`
--

DROP TABLE IF EXISTS `kunder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kunder` (
  `KundID` int NOT NULL AUTO_INCREMENT,
  `Namn` varchar(100) NOT NULL,
  `Epost` varchar(100) NOT NULL,
  `Telefonnummer` varchar(20) DEFAULT NULL,
  `Adress` text,
  PRIMARY KEY (`KundID`),
  UNIQUE KEY `Epost` (`Epost`),
  KEY `idx_email` (`Epost`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kunder`
--

LOCK TABLES `kunder` WRITE;
/*!40000 ALTER TABLE `kunder` DISABLE KEYS */;
INSERT INTO `kunder` VALUES (1,'Anders Svensson','anders.svensson@hotmail.com','0701234567','Stockholm, Sverige'),(2,'Emma Karlsson','emma.karlsson@outlook.com','0739876543','Göteborg, Sverige'),(3,'Lars Olofsson','lars.olofsson@gmail.com','0739876987','Kalmar, Sverige'),(4,'Emma Lind','emma.lind@gmail.com','0739876713','Piteå, Sverige'),(5,'Johan Lind','johan.lind@yahoo.com','0724567890','Malmö, Sverige');
/*!40000 ALTER TABLE `kunder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderrader`
--

DROP TABLE IF EXISTS `orderrader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderrader` (
  `OrderradID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `FordonID` int NOT NULL,
  `Pris` decimal(10,2) NOT NULL,
  `Status` enum('Beställd','Levererad','Avbruten') DEFAULT 'Beställd',
  PRIMARY KEY (`OrderradID`),
  KEY `OrderID` (`OrderID`),
  KEY `FordonID` (`FordonID`),
  CONSTRAINT `orderrader_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `beställningar` (`OrderID`) ON DELETE CASCADE,
  CONSTRAINT `orderrader_ibfk_2` FOREIGN KEY (`FordonID`) REFERENCES `bilar` (`FordonID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderrader`
--

LOCK TABLES `orderrader` WRITE;
/*!40000 ALTER TABLE `orderrader` DISABLE KEYS */;
INSERT INTO `orderrader` VALUES (1,1,1,450000.00,'Beställd'),(2,2,2,550000.00,'Levererad'),(3,3,3,600000.00,'Beställd'),(4,4,4,1044900.00,'Beställd');
/*!40000 ALTER TABLE `orderrader` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Uppdatera_Servicehistorik` AFTER INSERT ON `orderrader` FOR EACH ROW BEGIN
    UPDATE Bilar
    SET Servicehistorik = CONCAT(IFNULL(Servicehistorik, ''), CHAR(10), 
                                'Ny beställning: ', NEW.OrderID, ' på ', NOW())
    WHERE FordonID = NEW.FordonID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Uppdatera_Lagerstatus` AFTER INSERT ON `orderrader` FOR EACH ROW BEGIN
    -- Minska lagerstatusen med 1 för den bil som är beställd
    UPDATE Bilar
    SET Lagerstatus = Lagerstatus - 1
    WHERE FordonID = NEW.FordonID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `reservdelar`
--

DROP TABLE IF EXISTS `reservdelar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservdelar` (
  `ReservdelID` int NOT NULL AUTO_INCREMENT,
  `Namn` varchar(100) NOT NULL,
  `Kategori` varchar(50) NOT NULL,
  `Pris` decimal(10,2) NOT NULL,
  `Lagerstatus` int NOT NULL DEFAULT '0',
  `FordonID` int DEFAULT NULL,
  PRIMARY KEY (`ReservdelID`),
  KEY `FordonID` (`FordonID`),
  CONSTRAINT `reservdelar_ibfk_1` FOREIGN KEY (`FordonID`) REFERENCES `bilar` (`FordonID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservdelar`
--

LOCK TABLES `reservdelar` WRITE;
/*!40000 ALTER TABLE `reservdelar` DISABLE KEYS */;
INSERT INTO `reservdelar` VALUES (1,'Bromsskivor','Bromssystem',1200.00,8,1),(2,'Oljefilter','Motor',250.00,30,2),(3,'Tändstift','Elektronik',100.00,46,NULL);
/*!40000 ALTER TABLE `reservdelar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservdelar_i_ordrar`
--

DROP TABLE IF EXISTS `reservdelar_i_ordrar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservdelar_i_ordrar` (
  `OrderradID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `ReservdelID` int NOT NULL,
  `Antal` int NOT NULL DEFAULT '1',
  `Pris` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderradID`),
  KEY `OrderID` (`OrderID`),
  KEY `ReservdelID` (`ReservdelID`),
  CONSTRAINT `reservdelar_i_ordrar_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `beställningar` (`OrderID`) ON DELETE CASCADE,
  CONSTRAINT `reservdelar_i_ordrar_ibfk_2` FOREIGN KEY (`ReservdelID`) REFERENCES `reservdelar` (`ReservdelID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservdelar_i_ordrar`
--

LOCK TABLES `reservdelar_i_ordrar` WRITE;
/*!40000 ALTER TABLE `reservdelar_i_ordrar` DISABLE KEYS */;
INSERT INTO `reservdelar_i_ordrar` VALUES (1,1,1,2,2400.00),(2,2,3,4,400.00);
/*!40000 ALTER TABLE `reservdelar_i_ordrar` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Uppdatera_Lagerstatus_Reservdel` AFTER INSERT ON `reservdelar_i_ordrar` FOR EACH ROW BEGIN
    UPDATE Reservdelar
    SET Lagerstatus = Lagerstatus - NEW.Antal
    WHERE ReservdelID = NEW.ReservdelID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ägare`
--

DROP TABLE IF EXISTS `ägare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ägare` (
  `ÄgareID` int NOT NULL AUTO_INCREMENT,
  `Namn` varchar(100) NOT NULL,
  `Personnummer` varchar(20) NOT NULL,
  `Adress` text,
  PRIMARY KEY (`ÄgareID`),
  UNIQUE KEY `Personnummer` (`Personnummer`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ägare`
--

LOCK TABLES `ägare` WRITE;
/*!40000 ALTER TABLE `ägare` DISABLE KEYS */;
INSERT INTO `ägare` VALUES (1,'Lina Svensson','750101-1234','Stockholm, Sverige'),(2,'Roger Karlsson','820202-5678','Örebro, Sverige'),(3,'Oskar Ljung','740202-5678','Karlshamn, Sverige'),(4,'Gösta Eriksson','900303-9876','Kalmar, Sverige');
/*!40000 ALTER TABLE `ägare` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-25 13:56:26
