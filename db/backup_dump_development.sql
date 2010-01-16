-- MySQL dump 10.11
--
-- Host: localhost    Database: fifa10_development
-- ------------------------------------------------------
-- Server version	5.0.45-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chronicles`
--

DROP TABLE IF EXISTS `chronicles`;
CREATE TABLE `chronicles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `closed` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `chronicles`
--

LOCK TABLES `chronicles` WRITE;
/*!40000 ALTER TABLE `chronicles` DISABLE KEYS */;
INSERT INTO `chronicles` VALUES (1,'FIFA 10 Manager Mode',0);
/*!40000 ALTER TABLE `chronicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nations`
--

DROP TABLE IF EXISTS `nations`;
CREATE TABLE `nations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `region_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `nations`
--

LOCK TABLES `nations` WRITE;
/*!40000 ALTER TABLE `nations` DISABLE KEYS */;
INSERT INTO `nations` VALUES (1,'Belgium',1),(2,'Brazil',6),(3,'Bulgaria',1),(4,'England',1),(5,'Equador',6),(6,'France',1),(7,'Germany',1),(8,'Ireland',1),(9,'Italy',1),(10,'Korea',3),(11,'Netherland',1),(12,'Northern Ireland',1),(13,'Norway',1),(14,'Poland',1),(15,'Portugal',1),(16,'Scotland',1),(17,'Serbia',1),(18,'South Africa',2),(19,'Wales',1),(20,'Burundi',2);
/*!40000 ALTER TABLE `nations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_attributes`
--

DROP TABLE IF EXISTS `player_attributes`;
CREATE TABLE `player_attributes` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) NOT NULL,
  `acceleration` int(11) NOT NULL,
  `positiveness` int(11) NOT NULL,
  `quickness` int(11) NOT NULL,
  `balance` int(11) NOT NULL,
  `control` int(11) NOT NULL,
  `cross` int(11) NOT NULL,
  `curve` int(11) NOT NULL,
  `dribble` int(11) NOT NULL,
  `goalmaking` int(11) NOT NULL,
  `fk_accuracy` int(11) NOT NULL,
  `head_accuracy` int(11) NOT NULL,
  `jump` int(11) NOT NULL,
  `long_pass` int(11) NOT NULL,
  `long_shot` int(11) NOT NULL,
  `mark` int(11) NOT NULL,
  `pk` int(11) NOT NULL,
  `positioning` int(11) NOT NULL,
  `reaction` int(11) NOT NULL,
  `short_pass` int(11) NOT NULL,
  `shot_power` int(11) NOT NULL,
  `sliding` int(11) NOT NULL,
  `speed` int(11) NOT NULL,
  `stamina` int(11) NOT NULL,
  `tackle` int(11) NOT NULL,
  `physical` int(11) NOT NULL,
  `tactics` int(11) NOT NULL,
  `vision` int(11) NOT NULL,
  `volley` int(11) NOT NULL,
  `gk_dive` int(11) NOT NULL,
  `gk_handling` int(11) NOT NULL,
  `gk_kick` int(11) NOT NULL,
  `gk_positioning` int(11) NOT NULL,
  `gk_reaction` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `player_attributes`
--

LOCK TABLES `player_attributes` WRITE;
/*!40000 ALTER TABLE `player_attributes` DISABLE KEYS */;
INSERT INTO `player_attributes` VALUES (1,1,32,57,21,51,22,14,12,13,8,11,12,58,27,11,12,24,55,66,27,29,11,41,63,10,76,78,40,12,80,84,83,90,75),(2,2,66,87,51,69,66,70,56,42,31,33,73,70,59,28,76,32,83,70,69,47,81,62,69,79,75,90,69,55,7,9,5,13,12),(3,3,71,84,52,80,73,45,51,58,39,27,87,88,73,29,88,54,88,78,74,59,87,74,76,94,85,80,69,51,21,20,30,20,22),(4,4,73,93,57,87,67,41,44,49,42,49,97,93,65,36,91,63,92,82,76,61,89,76,81,98,93,87,63,42,10,12,16,18,6),(5,5,90,83,89,78,83,83,78,88,53,52,77,84,81,51,82,59,82,92,85,75,94,90,94,87,71,79,73,54,13,14,12,5,8),(6,6,88,69,81,79,85,85,76,87,65,69,62,64,60,80,46,64,73,83,71,83,42,89,82,49,75,73,78,68,15,8,13,5,8),(7,7,70,86,62,75,86,83,74,76,67,67,75,69,93,85,65,77,94,80,91,88,42,68,68,57,75,93,94,85,13,10,8,9,8),(8,8,72,74,67,81,81,80,75,74,67,79,73,73,90,82,83,79,92,84,89,83,80,77,87,85,80,89,90,77,9,10,13,11,14),(9,9,79,58,85,70,88,89,87,83,78,82,66,65,82,73,26,81,87,73,86,77,45,77,66,46,61,84,90,81,10,9,12,9,8),(10,10,87,96,84,94,94,83,83,88,93,82,75,74,82,89,28,85,86,85,90,94,33,84,88,38,90,82,90,96,11,7,5,11,12),(11,11,73,61,83,82,93,77,77,86,93,71,90,86,64,80,13,80,92,94,89,90,19,74,62,25,78,77,89,94,7,8,8,12,8),(12,12,86,56,82,82,80,66,69,76,80,65,79,73,45,57,31,84,89,86,72,75,10,82,68,28,54,80,72,78,15,6,8,7,11),(13,13,89,59,92,79,86,81,76,86,69,75,45,52,59,83,30,63,60,69,70,81,33,87,72,30,62,60,74,76,5,12,13,6,12),(14,14,76,85,59,74,81,77,58,72,61,47,73,80,77,73,83,50,81,78,84,61,74,76,93,79,77,77,73,58,9,10,13,11,12),(15,15,79,81,78,77,85,82,80,73,50,85,67,69,80,79,78,73,91,90,86,76,81,83,81,85,76,90,83,60,6,13,9,6,11),(16,16,73,84,53,83,71,64,62,63,38,34,84,85,66,39,81,47,80,74,80,61,78,76,80,80,83,84,71,63,5,6,4,9,4),(17,17,68,81,53,68,60,60,32,39,28,25,77,83,55,25,80,34,76,74,71,42,81,63,78,82,75,74,56,46,7,8,5,11,6),(18,18,53,55,47,62,18,10,15,14,18,17,14,70,21,22,10,18,69,63,21,27,9,53,48,10,66,59,51,9,81,76,78,75,80),(19,19,86,81,84,83,85,70,79,85,58,79,54,68,80,65,63,79,81,77,84,83,60,84,79,69,78,77,85,71,9,8,7,9,8),(20,20,84,74,81,82,79,76,63,82,76,53,66,44,59,66,55,71,83,77,75,72,51,84,92,59,60,76,73,77,10,7,5,14,5),(21,21,85,40,79,68,75,71,58,77,74,67,64,66,39,74,20,66,75,60,61,78,21,83,68,24,61,62,57,70,3,5,6,5,3),(22,22,76,46,75,70,75,64,65,69,77,51,69,73,23,75,20,64,63,71,69,77,12,76,68,11,68,61,62,76,2,8,5,5,6),(23,23,85,64,71,71,70,75,68,61,55,59,37,57,61,42,52,61,68,69,64,51,41,87,69,47,59,68,67,47,7,7,9,6,5),(24,24,81,81,81,72,81,79,48,81,57,72,57,58,75,78,78,64,75,75,76,79,70,84,80,78,71,79,75,75,4,5,6,8,8),(25,25,69,81,49,67,59,70,41,43,22,24,73,79,53,29,79,35,77,64,62,43,83,72,75,80,78,77,56,31,7,6,10,10,10),(26,26,84,67,81,46,74,76,58,76,62,77,49,61,70,69,72,72,62,72,74,79,72,81,76,75,43,58,72,67,7,5,9,1,6),(27,27,50,62,52,55,26,15,12,25,14,12,15,67,26,23,23,21,61,69,35,25,23,53,68,25,60,58,63,15,76,69,53,68,76),(28,28,70,71,53,74,73,75,45,58,54,65,63,72,75,83,71,34,74,68,76,84,52,77,83,58,73,68,69,66,7,5,14,8,9),(29,29,80,38,75,52,80,76,75,77,68,82,50,64,65,75,20,61,69,56,73,79,13,77,71,14,48,68,72,67,7,6,5,7,6),(30,30,74,38,74,64,74,65,51,81,60,39,43,48,40,52,14,63,45,62,65,69,15,74,53,17,65,43,49,58,7,1,4,3,4),(31,31,60,65,57,56,57,38,38,30,23,38,65,64,24,35,62,28,52,64,49,38,72,65,64,68,57,59,47,29,4,9,2,5,5),(32,32,64,75,51,64,46,58,27,38,21,32,62,65,47,41,64,24,63,54,52,60,65,72,65,66,67,63,48,23,6,5,19,7,15),(33,33,72,52,69,49,68,45,45,62,42,72,44,55,65,56,34,40,49,65,69,74,48,68,72,56,49,50,67,59,1,2,3,5,6),(34,34,52,35,22,66,17,8,6,10,12,9,13,71,12,9,10,12,17,61,13,23,26,44,43,24,55,18,24,12,69,54,51,50,64),(35,35,71,57,55,31,65,45,43,56,55,43,47,38,60,63,40,52,53,54,66,72,32,65,66,49,49,42,63,50,1,4,7,4,1),(36,36,62,75,43,61,59,37,37,38,42,34,37,61,47,42,52,31,58,68,57,62,64,78,59,66,72,51,48,33,7,2,1,2,9),(37,37,78,32,56,30,57,36,45,45,53,47,61,27,31,54,10,48,46,54,43,71,11,74,39,11,62,49,21,44,2,8,4,8,4),(38,38,62,33,53,54,62,41,41,53,54,43,54,63,62,55,57,53,39,52,63,66,42,58,64,44,64,41,57,45,8,3,6,5,5),(39,39,56,78,67,75,41,31,37,19,19,39,25,76,38,24,79,33,57,65,31,17,85,68,78,69,75,51,52,24,4,1,3,6,2),(40,41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `player_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_positions`
--

DROP TABLE IF EXISTS `player_positions`;
CREATE TABLE `player_positions` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `player_positions`
--

LOCK TABLES `player_positions` WRITE;
/*!40000 ALTER TABLE `player_positions` DISABLE KEYS */;
INSERT INTO `player_positions` VALUES (1,2,3),(2,2,6),(3,3,8),(4,3,2),(5,4,8),(6,5,5),(7,5,11),(8,6,10),(9,6,12),(10,6,15),(11,7,12),(12,7,15),(13,8,8),(14,8,12),(15,9,9),(16,9,12),(17,9,14),(18,10,18),(19,10,14),(20,10,17),(21,11,15),(22,12,17),(23,12,15),(24,13,13),(25,13,11),(26,13,10),(27,14,10),(28,14,8),(29,14,4),(30,15,9),(31,15,10),(32,15,6),(33,16,8),(34,16,5),(35,16,3),(36,17,4),(37,17,5),(38,19,12),(39,19,11),(40,19,8),(41,20,11),(42,20,12),(43,20,9),(44,21,18),(45,21,13),(46,21,14),(47,22,15),(48,22,14),(49,23,11),(50,23,17),(51,24,4),(52,24,13),(53,24,7),(54,25,4),(55,26,5),(56,26,11),(57,26,4),(58,28,8),(59,28,10),(60,29,14),(61,29,12),(62,29,10),(63,30,14),(64,30,10),(65,31,4),(66,32,4),(67,32,5),(68,33,10),(69,33,11),(70,35,12),(71,36,9),(72,36,3),(73,36,4),(74,37,15),(75,38,10),(76,38,4),(77,38,6),(78,41,6),(79,41,13),(80,41,16);
/*!40000 ALTER TABLE `player_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_seasons`
--

DROP TABLE IF EXISTS `player_seasons`;
CREATE TABLE `player_seasons` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) NOT NULL,
  `season_id` int(11) NOT NULL,
  `order_number` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_player_seasons_on_season_id_and_order_number` (`season_id`,`order_number`),
  KEY `fk_player_seasons_players` (`player_id`),
  CONSTRAINT `fk_player_seasons_players` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`),
  CONSTRAINT `fk_player_seasons_seasons` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `player_seasons`
--

LOCK TABLES `player_seasons` WRITE;
/*!40000 ALTER TABLE `player_seasons` DISABLE KEYS */;
INSERT INTO `player_seasons` VALUES (1,1,1,1),(2,2,1,2),(3,3,1,3),(4,4,1,4),(5,5,1,5),(6,6,1,6),(7,7,1,7),(8,8,1,8),(9,9,1,9),(10,10,1,10),(11,11,1,11),(12,12,1,12),(13,13,1,13),(14,14,1,14),(15,15,1,15),(16,16,1,16),(17,17,1,17),(18,18,1,18),(19,19,1,19),(20,20,1,20),(21,21,1,21),(22,22,1,22),(23,23,1,23),(24,24,1,24),(25,25,1,25),(26,26,1,26),(27,27,1,27),(28,28,1,28),(29,29,1,29),(30,30,1,30),(31,31,1,31),(32,32,1,32),(33,33,1,33),(34,34,1,34),(35,35,1,35),(36,36,1,36),(37,37,1,37),(38,38,1,38),(39,1,2,1),(40,2,2,2),(41,3,2,3),(42,4,2,4),(43,5,2,5),(44,6,2,6),(45,7,2,7),(46,8,2,8),(47,9,2,9),(48,10,2,10),(49,11,2,11),(50,12,2,12),(51,13,2,13),(52,14,2,14),(53,15,2,15),(54,16,2,16),(55,17,2,17),(56,18,2,18),(57,19,2,19),(58,20,2,20),(59,21,2,21),(60,22,2,22),(61,23,2,23),(62,24,2,24),(63,25,2,25),(64,26,2,26),(65,27,2,27),(66,28,2,28),(67,29,2,29),(68,30,2,30),(69,31,2,32),(70,32,2,33),(71,33,2,34),(72,34,2,35),(73,35,2,36),(74,36,2,37),(75,37,2,38),(76,38,2,39),(77,39,2,31);
/*!40000 ALTER TABLE `player_seasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_values`
--

DROP TABLE IF EXISTS `player_values`;
CREATE TABLE `player_values` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) NOT NULL,
  `overall` int(11) NOT NULL,
  `value` int(11) default NULL,
  `note` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `player_values`
--

LOCK TABLES `player_values` WRITE;
/*!40000 ALTER TABLE `player_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `number` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `skill_move` int(11) NOT NULL,
  `is_right_dominant` tinyint(1) NOT NULL,
  `both_feet_level` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `birth_year` int(11) NOT NULL,
  `nation_id` int(11) NOT NULL,
  `overall` int(11) NOT NULL,
  `market_value` int(11) default NULL,
  `note` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES (1,'Van Der Sar','Edwin',1,1,1,1,3,197,89,1971,11,83,8000,NULL),(2,'Neville','Gary',2,4,2,1,3,179,79,1975,4,76,2700,NULL),(3,'Ferdinand','Rio',5,3,2,1,3,192,82,1979,4,86,15550,NULL),(4,'Vidic','Nemanja',15,3,2,1,3,189,84,1982,17,89,17055,NULL),(5,'Evra','Patrice',3,7,2,0,2,175,76,1981,6,85,7100,NULL),(6,'Valencia','Antonio Luis',25,13,4,1,4,181,73,1985,5,82,12703,NULL),(7,'Scholes','Paul',18,9,3,1,3,170,74,1975,4,84,12000,NULL),(8,'Carrick','Michael',16,9,3,1,4,185,74,1981,4,85,10000,NULL),(9,'Giggs','Ryan',11,11,5,0,3,180,70,1974,19,83,10000,NULL),(10,'Rooney','Wayne',10,15,5,1,4,177,79,1986,4,89,34090,NULL),(11,'Berbatov','Dimitar',9,18,5,1,3,189,80,1981,3,86,15000,NULL),(12,'Owen','Michael',7,18,3,1,4,173,70,1980,4,78,5100,NULL),(13,'Nani','',17,14,5,1,4,175,66,1987,15,82,10000,NULL),(14,'Fletcher','Darren',24,9,3,1,3,184,83,1984,11,80,6400,NULL),(15,'Hargreaves','Owen',4,8,2,1,4,180,73,1981,4,83,7700,NULL),(16,'O\'Shea','John',22,4,2,1,3,190,75,1981,8,80,4500,NULL),(17,'J. Evans','Jonny',23,3,2,1,3,188,77,1988,18,78,4400,NULL),(18,'Foster','Ben',12,1,1,0,2,188,80,1983,4,77,3500,NULL),(19,'Anderson','',8,9,5,0,3,176,69,1988,2,81,6800,NULL),(20,'Park','Ji Sung',13,10,5,1,3,175,70,1981,15,80,5700,NULL),(21,'Welbeck','Danny',19,15,4,1,3,185,73,1991,4,75,5400,NULL),(22,'Macheda','Federico',27,18,2,1,3,184,77,1992,9,75,5400,NULL),(23,'Mabe','Thembinkosi',32,14,3,0,3,170,65,1991,18,71,3600,NULL),(24,'Rafael','Da Silva',21,6,4,1,4,172,69,1990,2,78,4100,NULL),(25,'Brown','Wes',6,3,2,1,3,185,75,1980,4,78,3900,NULL),(26,'Fabio','Da Silva',20,7,4,1,3,172,69,1990,2,74,2800,NULL),(27,'Kuszczak','Tomasz',29,1,1,1,2,190,84,1982,14,73,2300,NULL),(28,'Gibson','Darron',28,9,2,1,4,183,80,1988,8,73,3300,NULL),(29,'Tosic','Zoran',14,11,2,0,3,171,69,1987,17,76,4300,NULL),(30,'Obertan','Gabriel',26,13,5,1,4,186,80,1989,6,69,3400,NULL),(31,'Cathcart','Craig',37,3,2,1,2,188,73,1989,18,65,1300,NULL),(32,'De Laet','Ritchie',30,3,2,1,4,188,76,1989,1,66,1400,NULL),(33,'Eikrem','Magnus Wolff',51,9,2,1,3,179,69,1990,13,64,1300,NULL),(34,'Zieler','Ron-Robert',38,1,1,1,2,188,77,1989,7,62,880,NULL),(35,'Hewson','Sam',33,9,2,1,2,180,81,1989,4,61,990,NULL),(36,'C. Evans','Corry',31,8,2,1,3,181,74,1990,18,61,930,NULL),(37,'Bryan','Antonio',50,18,2,1,3,180,75,1990,4,60,1300,NULL),(38,'James','Matthew',47,9,2,1,3,175,75,1991,4,58,700,NULL),(39,'Habarugira','Valery',82,3,2,1,3,180,65,1989,20,64,1000,NULL);
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
CREATE TABLE `positions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `category` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES (1,'GK','Goalkeeper'),(2,'SW','Defender'),(3,'CB','Defender'),(4,'RB','Defender'),(5,'LB','Defender'),(6,'RWB','Defender'),(7,'LWB','Defender'),(8,'CDM','Midfielder'),(9,'CM','Midfielder'),(10,'RM','Midfielder'),(11,'LM','Midfielder'),(12,'CAM','Midfielder'),(13,'RW','Forward'),(14,'LW','Forward'),(15,'CF','Forward'),(16,'RF','Forward'),(17,'LF','Forward'),(18,'ST','Forward');
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
CREATE TABLE `regions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,'Europe'),(2,'Africa'),(3,'Asia'),(4,'Oceania'),(5,'North'),(6,'America'),(7,'South'),(8,'America');
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20091213140109'),('20091213140924'),('20091214104031'),('20091214104312'),('20091214140704'),('20091218123850'),('20091219070150'),('20091222234521'),('20091225231523'),('20091227075745'),('20091230104100'),('20100113115430'),('20100113124614'),('20100114120528'),('20100115234855'),('20100116085624'),('20100116090112'),('20100116105859'),('20100116121347');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seasons`
--

DROP TABLE IF EXISTS `seasons`;
CREATE TABLE `seasons` (
  `id` int(11) NOT NULL auto_increment,
  `years` varchar(255) collate utf8_unicode_ci default NULL,
  `chronicle_id` int(11) default NULL,
  `team_id` int(11) default NULL,
  `closed` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `seasons`
--

LOCK TABLES `seasons` WRITE;
/*!40000 ALTER TABLE `seasons` DISABLE KEYS */;
INSERT INTO `seasons` VALUES (1,'2009-2010',1,1,1),(2,'2010-2011',1,1,0);
/*!40000 ALTER TABLE `seasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
CREATE TABLE `teams` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `year_founded` int(11) default NULL,
  `ground` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'Manchester United',1878,'Old Trafford'),(2,'Liverpool',1892,'Anfield'),(3,'Chelsea',1905,'Stamford Bridge'),(4,'Arsenal',1886,'Emirates Stadium'),(5,'Everton',1878,'Goodison Park'),(6,'Aston Villa',1874,'Villa Park'),(7,'Tottenham Hotspur',1882,'White Hart Lane'),(8,'Manchester City',1887,'City of Manchester Stadium'),(9,'Fulham',1879,'Craven Cottage'),(10,'West Ham United',1895,'Upton Park'),(11,'Wigan Athletic',1932,'DW Stadium'),(12,'Stoke City',1863,'Britannia Stadium'),(13,'Bolton Wanderers',1874,'Reebok Stadium'),(14,'Portsmouth',1898,'Fratton Park'),(15,'Blackburn Rovers',1875,'Ewood Park'),(16,'Sunderland',1879,'Stadium of Light'),(17,'Hull City',1904,'KC Stadium'),(18,'Wolverhampton',1877,'Molineux Stadium'),(19,'Birmingham City',1875,'St. Andrew\'s Stadium'),(20,'Burnley',1882,'Turf Moor'),(21,'Newcastle United',1892,'St. James\' Park'),(22,'Derby County',1884,'Pride Park Stadium'),(23,'Leeds United',1919,'Elland Road'),(24,'Norwich City',1902,'Carrow Road'),(25,'West Bromwich Albion',1878,'The Hawthorns'),(26,'Nottingham Forest',1865,'City Ground'),(27,'Cardiff City',1899,'Cardiff City Stadium'),(28,'Sheffield United',1889,'Bramall Lane');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-01-16 12:28:38
