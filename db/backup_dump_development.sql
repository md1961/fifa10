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
  `name` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `closed` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `chronicles`
--

LOCK TABLES `chronicles` WRITE;
/*!40000 ALTER TABLE `chronicles` DISABLE KEYS */;
INSERT INTO `chronicles` VALUES (1,'FIFA 10 Manager Mode',0),(2,'Manchester United (in Real)',0),(3,'FIFA 10 Live Season Premier League',0);
/*!40000 ALTER TABLE `chronicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
CREATE TABLE `matches` (
  `id` int(11) NOT NULL auto_increment,
  `date_match` date default NULL,
  `series_id` int(11) default NULL,
  `subname` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `opponent_id` int(11) NOT NULL,
  `ground` varchar(255) collate utf8_unicode_ci default NULL,
  `scores_own` int(11) default NULL,
  `scores_opp` int(11) default NULL,
  `pks_own` int(11) default NULL,
  `pks_opp` int(11) default NULL,
  `scorers_own` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `scorers_opp` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `season_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (1,'2011-01-08',4,'',17,'H',3,0,NULL,NULL,'Welbeck 7 88(2), Fletcher 86(1)','',2),(2,'2011-01-15',4,'',8,'A',3,0,NULL,NULL,'Rooney 13 59(24), Scholes 40','',2),(3,'2011-01-22',4,'',29,'H',1,0,NULL,NULL,'Scholes 57(3)','',2),(4,'2010-08-08',7,'',4,'N',2,0,NULL,NULL,'','',2),(5,'2010-08-14',4,'',16,'A',3,1,NULL,NULL,'','',2),(6,'2010-08-21',4,'',10,'H',1,0,NULL,NULL,'','',2),(7,'2010-08-28',4,'',17,'A',2,1,NULL,NULL,'','',2),(8,'2010-09-04',4,'',8,'H',0,2,NULL,NULL,'','',2),(9,'2010-09-11',4,'',29,'A',3,0,NULL,NULL,'','',2),(10,'2010-09-14',6,'R2',30,'A',4,0,NULL,NULL,'','',2),(11,'2010-09-18',4,'',21,'H',0,2,NULL,NULL,'','',2),(12,'2010-09-21',1,'GL #1/6',31,'A',3,0,NULL,NULL,'','',2),(13,'2010-09-28',1,'GL #2/6',33,'H',2,0,NULL,NULL,'','',2),(14,'2010-09-25',4,'',14,'A',3,0,NULL,NULL,'','',2),(15,'2010-10-02',4,'',5,'H',0,1,NULL,NULL,'','',2),(16,'2010-10-09',4,'',6,'A',2,1,NULL,NULL,'','',2),(17,'2010-10-12',6,'R3',14,'A',1,0,NULL,NULL,'','',2),(18,'2010-10-16',4,'',12,'A',0,0,NULL,NULL,'','',2),(19,'2010-10-23',4,'',11,'H',5,0,NULL,NULL,'','',2),(20,'2010-10-27',1,'GL #3/6',34,'H',1,0,NULL,NULL,'','',2),(21,'2010-10-30',4,'',7,'A',6,0,NULL,NULL,'','',2),(22,'2010-11-02',6,'R4',4,'A',1,0,NULL,NULL,'','',2),(23,'2010-11-06',4,'',3,'H',1,2,NULL,NULL,'','',2),(24,'2010-11-09',1,'GL #4/6',34,'A',1,1,NULL,NULL,'','',2),(25,'2010-11-13',4,'',2,'A',1,1,NULL,NULL,'','',2),(26,'2010-11-20',4,'',15,'A',4,0,NULL,NULL,'','',2),(27,'2010-11-27',4,'',35,'A',4,0,NULL,NULL,'','',2),(28,'2010-12-01',1,'GL #5/6',33,'A',2,3,NULL,NULL,'','',2),(29,'2010-12-04',4,'',9,'H',3,1,NULL,NULL,'','',2),(30,'2010-12-08',1,'GL #6/6',31,'H',2,2,NULL,NULL,'','',2),(31,'2010-12-11',4,'',4,'A',4,1,NULL,NULL,'','',2),(32,'2010-12-18',4,'',18,'H',3,1,NULL,NULL,'','',2),(33,'2010-12-21',6,'QF',3,'A',1,0,NULL,NULL,'Rooney 120','',2),(34,'2010-12-25',4,'',16,'H',1,1,NULL,NULL,'','',2),(35,'2011-01-01',4,'',10,'A',2,0,NULL,NULL,'','',2),(36,'2011-01-08',5,'R3',36,'A',4,0,NULL,NULL,'','',2),(38,'2011-01-11',6,'SF Leg1',5,'H',0,1,NULL,NULL,'','',2),(40,'2011-01-18',6,'SF Leg2',5,'A',4,0,NULL,NULL,'','',2),(41,'2011-01-29',5,'R4',14,'H',4,0,NULL,NULL,'Welbeck 7, Owen 24, Macheda 86 89','',2),(42,'2011-01-29',4,'',21,'A',4,1,NULL,NULL,'Berbatov 13 34 45(18), Valencia 86(2)','Ranger 6',2),(43,'2011-02-05',4,'',14,'H',1,0,NULL,NULL,'Carrick 64(3)','',2),(101,'2009-08-09',7,' ',3,'N',2,2,1,4,'Nani 10, Rooney 92','Carvalho 52, Lampard 71',3),(102,'2009-08-16',4,' ',19,'H',1,0,NULL,NULL,'Rooney 34(1)','',3),(103,'2009-08-19',4,' ',20,'A',0,1,NULL,NULL,'','Blake 19',3),(104,'2009-08-22',4,' ',11,'A',5,0,NULL,NULL,'Rooney 56 65(3), Berbatov 58(1), Owen 85(1), Nani 92(1)','',3),(105,'2009-08-29',4,' ',4,'H',2,1,NULL,NULL,'Rooney 59(PK, 4), OG(Diaby) 64','Arshavin 40',3),(106,'2009-09-12',4,' ',7,'A',3,1,NULL,NULL,'Giggs 25(1), Anderson 41(1), Rooney 78(5)','Defoe 1',3),(107,'2009-09-15',1,'GL#1',42,'A',1,0,NULL,NULL,'Scholes 77','',3),(108,'2009-09-20',4,' ',8,'H',4,3,NULL,NULL,'Rooney 5(6), Fletcher 48 80(2), Owen 95(2)','Barry 16, Bellamy 52 90',3),(109,'2009-09-23',6,' ',18,'H',1,0,NULL,NULL,'Welbeck 66','',3),(110,'2009-09-26',4,' ',12,'A',2,0,NULL,NULL,'Berbatov 62(2), O\'Shea 76(1)','',3),(111,'2009-09-30',1,'GL#2',43,'H',2,1,NULL,NULL,'Giggs 59, Carrick 78','Dzeko 55',3),(112,'2009-10-03',4,' ',16,'H',2,2,NULL,NULL,'Berbatov 51(3), OG(Ferdinand) 92','Bent 7, Jones 58',3),(113,'2009-10-17',4,' ',13,'H',2,1,NULL,NULL,'OG(Knight) 5, Valencia 33(1)','Taylor 75',3),(114,'2009-10-21',1,'GL#3',44,'A',1,0,NULL,NULL,'Valencia 86','',3),(115,'2009-10-25',4,' ',2,'A',0,2,NULL,NULL,'','Torres 65, Ngog 96',3),(116,'2009-10-31',4,' ',15,'H',2,0,NULL,NULL,'Berbatov 55(4), Rooney 87(7)','',3),(117,'2009-11-03',1,'GL#4',44,'H',3,3,NULL,NULL,'Owen 29, Scholes 84, OG(Schennikov) 92','Dzagoev 25, Krasic 31, Berezutski 47',3),(118,'2009-11-08',4,' ',3,'A',0,1,NULL,NULL,'','Terry 76',3),(119,'2009-11-21',4,' ',5,'H',3,0,NULL,NULL,'Fletcher 35(3), Carrick 67(1), Valencia 76(2)','',3),(120,'2009-11-25',1,'GL#5',42,'H',0,1,NULL,NULL,'','Tello 18',3),(121,'2009-11-28',4,' ',14,'A',4,1,NULL,NULL,'Rooney 25(PK) 48 54(PK, 10), Giggs 87(2)','Boateng 32(PK)',3),(122,'2009-12-01',6,'QF',7,'H',2,0,NULL,NULL,'Gibson 16 38','',3),(123,'2009-12-05',4,' ',10,'A',4,0,NULL,NULL,'Scholes 45(1), Gibson 61(1), Valencia 70(3), Rooney 72(11)','',3),(124,'2009-12-08',1,'GL#6',43,'A',3,1,NULL,NULL,'Owen 44 83 90','Dzeko 55',3),(125,'2009-12-12',4,' ',6,'H',0,1,NULL,NULL,'','Agbonlahor 21',3),(126,'2009-12-15',4,' ',18,'H',3,0,NULL,NULL,'Rooney 30(PK,12), Vidic 44(1), Valencia 66(4)','',3),(127,'2009-12-19',4,' ',9,'A',0,3,NULL,NULL,'','Murphy 22, Zamora 46, Duff 75',3),(128,'2009-12-26',4,' ',17,'A',3,1,NULL,NULL,'Rooney 47(13), Dawson 73(OG), Berbatov 82(5)','Fagan 59(PK)',3),(129,'2009-12-30',4,' ',11,'H',5,0,NULL,NULL,'Rooney 28(14), Carrick 32(2), Rafael 45(1), Berbatov 50(6), Valencia 75(5)','',3),(130,'2010-01-03',5,'R3',23,'H',0,1,NULL,NULL,'','Beckford 19',3),(131,'2010-01-09',4,' ',19,'A',1,1,NULL,NULL,'OG(Dann) 63','Jerome 39',3),(132,'2010-01-16',4,' ',20,'H',3,0,NULL,NULL,'Berbatov 64(7), Rooney 69(15), Diouf 90(1)','',3),(133,'2010-01-19',6,'SF #1',8,'A',1,2,NULL,NULL,'Giggs 17','Tevez 42 65',3),(134,'2010-01-23',4,' ',17,'H',4,0,NULL,NULL,'Rooney 8 82 86 93(19)',' ',3),(135,'2010-01-27',6,'SF #2',8,'H',3,1,NULL,NULL,'Scholes 52, Carrick 71, Rooney 92','Tevez 76',3),(136,'2010-01-30',4,' ',4,'A',3,1,NULL,NULL,'OG(Almunia) 33, Rooney 37(20), Park 52(1)','Vermaelen 80',3),(137,'2010-02-06',4,' ',14,'H',5,0,NULL,NULL,'Rooney 39(21), OG(Vanden Borre) 45, Carrick 59(3), Berbatov 62(8), OG(Wilson) 69',' ',3),(138,'2010-02-10',4,' ',6,'A',1,1,NULL,NULL,'OG(Collins) 23','Cuellar 19',3),(139,'2010-02-16',1,'R1 #1',41,'A',3,2,NULL,NULL,'Scholes 36, Rooney 66 74','Ronaldinho 3, Seedorf 85',3),(140,'2010-02-20',4,' ',5,'A',1,3,NULL,NULL,'Berbatov 16','Bilyaletdinov 19, Gosling 76, Rodwell 90',3),(141,'2010-02-23',4,' ',10,'H',NULL,NULL,NULL,NULL,' ',' ',3),(142,'2010-03-06',4,' ',18,'A',NULL,NULL,NULL,NULL,' ',' ',3),(143,'2010-03-10',1,'R1 #2',41,'H',NULL,NULL,NULL,NULL,' ',' ',3),(144,'2010-03-14',4,' ',9,'H',NULL,NULL,NULL,NULL,' ',' ',3),(145,'2010-03-20',4,' ',2,'H',NULL,NULL,NULL,NULL,' ',' ',3),(146,'2010-03-27',4,' ',13,'A',NULL,NULL,NULL,NULL,' ',' ',3),(147,'2010-03-30',1,'QF #1',45,'',NULL,NULL,NULL,NULL,' ',' ',3),(148,'2010-04-03',4,' ',3,'H',NULL,NULL,NULL,NULL,' ',' ',3),(149,'2010-04-06',1,'QF #2',45,'',NULL,NULL,NULL,NULL,' ',' ',3),(150,'2010-04-10',4,' ',15,'A',NULL,NULL,NULL,NULL,' ',' ',3),(151,'2010-04-17',4,' ',8,'A',NULL,NULL,NULL,NULL,' ',' ',3),(152,'2010-04-20',1,'SF #1',45,'',NULL,NULL,NULL,NULL,' ',' ',3),(153,'2010-04-24',4,' ',7,'H',NULL,NULL,NULL,NULL,' ',' ',3),(154,'2010-04-27',1,'SF #2',45,'',NULL,NULL,NULL,NULL,' ',' ',3),(155,'2010-05-01',4,' ',16,'A',NULL,NULL,NULL,NULL,' ',' ',3),(156,'2010-05-09',4,' ',12,'H',NULL,NULL,NULL,NULL,' ',' ',3),(157,'2010-05-22',1,'Final',45,'N',NULL,NULL,NULL,NULL,' ',' ',3),(158,'2011-02-12',4,'',5,'A',1,0,NULL,NULL,'Carrick 15(4)','',2),(159,'2011-02-19',4,'',6,'H',5,0,NULL,NULL,'Rooney 3 45(26), Valencia 14(3), Berbatov 18 72(20)','',2),(160,'2011-02-26',5,'R5',37,'H',2,0,NULL,NULL,'Macheda 17 60','',2),(161,'2010-02-28',6,'Final',6,'N',NULL,NULL,NULL,NULL,'','',3),(162,'2011-02-26',4,'',12,'H',3,0,NULL,NULL,'Berbatov 11(21), Welbeck 23 90(4)','',2),(163,'2011-03-01',1,'R1 Leg1',32,'H',0,2,NULL,NULL,'','Elano 13, Baros 71',2),(164,'2011-03-06',6,'Final',15,'N',2,0,NULL,NULL,'Rooney 33, Berbatov 49','',2),(165,'2011-03-10',4,'',11,'A',4,0,NULL,NULL,'Berbatov 47 64(23), Owen 71 77(5)','',2),(166,'2011-03-15',1,'R1 Leg2',32,'A',3,1,NULL,NULL,'Berbatov 39 80, Ferdinand 89','Baros 23',2),(167,'2011-03-19',5,'QF',9,'H',1,0,NULL,NULL,'Berbatov 99','',2),(168,'2011-03-19',4,'',7,'H',1,0,NULL,NULL,'Carrick 22(5)','',2),(169,'2011-03-26',4,'',3,'A',2,0,NULL,NULL,'Berbatov 19(24), Rooney 64(27)','',2),(170,'2011-04-02',4,'',2,'H',3,0,NULL,NULL,'Berbatov 20(25), Rooney 75 79(29)','',2),(171,'2011-03-29',1,'QF Leg1',10,'A',5,0,NULL,NULL,'Owen 8 36, Welbeck 13, Nani 61, Fletcher 90','',2),(172,'2011-04-05',1,'QF Leg2',10,'H',4,0,NULL,NULL,'Hargreaves 7, Mabe 45, Macheda 79 90','',2),(173,'2011-04-09',4,'',15,'A',0,0,NULL,NULL,'','',2),(174,'2011-04-10',5,'SF',10,'H',3,1,NULL,NULL,'Berbatov 7 82, Welbeck 68','Nouble 2',2),(175,'2011-04-16',4,'',35,'H',1,0,NULL,NULL,'Berbatov 24(26)','',2),(176,'2011-04-23',4,'',9,'A',4,2,NULL,NULL,'Berbatov 10(27), Owen 11 26 77(8)','Dempsey 29, Nevland 85',2),(177,'2011-04-30',4,'',4,'H',3,0,NULL,NULL,'Macheda 33(1), Carrick 75(6), Berbatov 90(28)','',2),(178,'2011-05-07',4,'',18,'A',2,0,NULL,NULL,'Macheda 39 78(3)','',2),(179,'2011-04-26',1,'SF Leg1',46,'H',1,0,NULL,NULL,'Welbeck 90','',2),(180,'2011-05-10',1,'SF Leg2',46,'A',3,0,NULL,NULL,'Rooney 18 36, Valencia 60','',2),(181,'2011-05-21',5,'Final',4,'N',1,1,2,4,'Welbeck 36','Van Persie 6',2),(182,'2011-05-25',1,'Final',47,'N',0,1,NULL,NULL,'','Ibrahimovic 31',2);
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nations`
--

DROP TABLE IF EXISTS `nations`;
CREATE TABLE `nations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `region_id` int(11) NOT NULL,
  `abbr` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `nations`
--

LOCK TABLES `nations` WRITE;
/*!40000 ALTER TABLE `nations` DISABLE KEYS */;
INSERT INTO `nations` VALUES (1,'Belgium',1,'BE'),(2,'Brazil',5,'BR'),(3,'Bulgaria',1,'BG'),(4,'England',1,'EL'),(5,'Ecuador',5,'EC'),(6,'France',1,'FR'),(7,'Germany',1,'DE'),(8,'Ireland',1,'IE'),(9,'Italy',1,'IT'),(10,'Korea',3,'KR'),(11,'Netherlands',1,'NL'),(12,'Northern Ireland',1,'ND'),(13,'Norway',1,'NO'),(14,'Poland',1,'PL'),(15,'Portugal',1,'PT'),(16,'Scotland',1,'SS'),(17,'Serbia',1,'RS'),(18,'South Africa',2,'ZA'),(19,'Wales',1,'WL'),(20,'Burundi',2,'BI'),(21,'Turkey',1,'TR'),(22,'Spain',1,'ES'),(23,'Andorra',1,'AD'),(24,'Albania',1,'AL'),(25,'Armenia',1,'AM'),(26,'Angola',2,'AO'),(27,'Argentina',6,'AR'),(28,'Austria',1,'AT'),(29,'Australia',2,'AU'),(30,'Bosnia And Herzegowina',1,'BA'),(31,'Benin',2,'BJ'),(32,'Bolivia',6,'BO'),(33,'Botswana',2,'BW'),(34,'Belarus',1,'BY'),(35,'Canada',5,'CA'),(36,'Congo',2,'CG'),(37,'Switzerland',1,'CH'),(38,'Ivory Coast',2,'CI'),(39,'Chile',6,'CL'),(40,'Cameroon',2,'CM'),(41,'China',3,'CN'),(42,'Colombia',6,'CO'),(43,'Costa Rica',5,'CR'),(44,'Cuba',5,'CU'),(45,'Czech',1,'CZ'),(46,'Denmark',1,'DK'),(47,'Dominican Republic',5,'DO'),(48,'Algeria',2,'DZ'),(49,'Estonia',1,'EE'),(50,'Egypt',2,'EG'),(51,'Western Sahara',2,'EH'),(52,'Ethiopia',2,'ET'),(53,'Finland',1,'FI'),(54,'Gabon',2,'GA'),(55,'Georgia',1,'GE'),(56,'Ghana',2,'GH'),(57,'Gambia',2,'GM'),(58,'Guinea',2,'GN'),(59,'Greece',1,'GR'),(60,'Guatemala',5,'GT'),(61,'Honduras',5,'HN'),(62,'Croatia',1,'HR'),(63,'Hungary',1,'HU'),(64,'Israel',1,'IL'),(65,'Iceland',1,'IS'),(66,'Jamaica',5,'JM'),(67,'Japan',3,'JP'),(68,'Kenya',2,'KE'),(69,'Lithuania',1,'LT'),(70,'Latvia',1,'LV'),(71,'Moldova',1,'MD'),(72,'Macedonia',1,'MK'),(73,'Mexico',5,'MX'),(74,'Namibia',2,'NA'),(75,'Niger',2,'NE'),(76,'Nigeria',2,'NG'),(77,'Nicaragua',5,'NI'),(78,'New Zealand',2,'NZ'),(79,'Peru',6,'PE'),(80,'Paraguay',6,'PY'),(81,'Romania',1,'RO'),(82,'Russia',1,'RU'),(83,'Sudan',2,'SD'),(84,'Sweden',1,'SE'),(85,'Slovenia',1,'SI'),(86,'Slovakia',1,'SK'),(87,'Senegal',2,'SN'),(88,'Somalia',2,'SO'),(89,'El Salvador',5,'SV'),(90,'Togo',2,'TG'),(91,'Tunisia',2,'TN'),(92,'Ukraine',1,'UA'),(93,'United States',5,'US'),(94,'Uruguay',6,'UY'),(95,'Venezuela',6,'VE'),(96,'Yugoslavia',1,'YU'),(97,'Zambia',2,'ZM'),(98,'Zaire',2,'ZR'),(99,'Zimbabwe',2,'ZW');
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `player_attributes`
--

LOCK TABLES `player_attributes` WRITE;
/*!40000 ALTER TABLE `player_attributes` DISABLE KEYS */;
INSERT INTO `player_attributes` VALUES (1,1,32,57,21,51,22,14,12,13,8,11,12,58,27,11,12,24,55,66,27,29,11,41,63,10,76,78,40,12,80,84,83,90,75),(2,2,66,87,51,69,66,70,56,42,31,33,73,70,59,28,76,32,83,70,69,47,81,62,69,79,75,90,69,55,7,9,5,13,12),(3,3,71,84,52,80,73,45,51,58,39,27,87,88,73,29,88,54,88,78,74,59,87,74,76,94,85,80,69,51,21,20,30,20,22),(4,4,73,93,57,87,67,41,44,49,42,49,97,93,65,36,91,63,92,82,76,61,89,76,81,98,93,87,63,42,10,12,16,18,6),(5,5,90,83,89,78,83,83,78,88,53,52,77,84,81,51,82,59,82,92,85,75,94,90,94,87,71,79,73,54,13,14,12,5,8),(6,6,88,69,81,79,85,85,76,87,65,69,62,64,60,80,46,64,73,83,71,83,42,89,82,49,75,73,78,68,15,8,13,5,8),(7,7,70,86,62,75,86,83,74,76,67,67,75,69,93,85,65,77,94,80,91,88,42,68,68,57,75,93,94,85,13,10,8,9,8),(8,8,72,74,67,81,81,80,75,74,67,79,73,73,90,82,83,79,92,84,89,83,80,77,87,85,80,89,90,77,9,10,13,11,14),(9,9,79,58,85,70,88,89,87,83,78,82,66,65,82,73,26,81,87,73,86,77,45,77,66,46,61,84,90,81,10,9,12,9,8),(10,10,87,96,84,94,94,83,83,88,93,82,75,74,82,89,28,85,86,85,90,94,33,84,88,38,90,82,90,96,11,7,5,11,12),(11,11,73,61,83,82,93,77,77,86,93,71,90,86,64,80,13,80,92,94,89,90,19,74,62,25,78,77,89,94,7,8,8,12,8),(12,12,86,56,82,82,80,66,69,76,80,65,79,73,45,57,31,84,89,86,72,75,10,82,68,28,54,80,72,78,15,6,8,7,11),(13,13,89,59,92,79,86,81,76,86,69,75,45,52,59,83,30,63,60,69,70,81,33,87,72,30,62,60,74,76,5,12,13,6,12),(14,14,76,85,59,74,81,77,58,72,61,47,73,80,77,73,83,50,81,78,84,61,74,76,93,79,77,77,73,58,9,10,13,11,12),(15,15,79,81,78,77,85,82,80,73,50,85,67,69,80,79,78,73,91,90,86,76,81,83,81,85,76,90,83,60,6,13,9,6,11),(16,16,73,84,53,83,71,64,62,63,38,34,84,85,66,39,81,47,80,74,80,61,78,76,80,80,83,84,71,63,5,6,4,9,4),(17,17,68,81,53,68,60,60,32,39,28,25,77,83,55,25,80,34,76,74,71,42,81,63,78,82,75,74,56,46,7,8,5,11,6),(18,18,53,55,47,62,18,10,15,14,18,17,14,70,21,22,10,18,69,63,21,27,9,53,48,10,66,59,51,9,81,76,78,75,80),(19,19,86,81,84,83,85,70,79,85,58,79,54,68,80,65,63,79,81,77,84,83,60,84,79,69,78,77,85,71,9,8,7,9,8),(20,20,84,74,81,82,79,76,63,82,76,53,66,44,59,66,55,71,83,77,75,72,51,84,92,59,60,76,73,77,10,7,5,14,5),(21,21,85,40,79,68,75,71,58,77,74,67,64,66,39,74,20,66,75,60,61,78,21,83,68,24,61,62,57,70,3,5,6,5,3),(22,22,76,46,75,70,75,64,65,69,77,51,69,73,23,75,20,64,63,71,69,77,12,76,68,11,68,61,62,76,2,8,5,5,6),(23,23,85,64,71,71,70,75,68,61,55,59,37,57,61,42,52,61,68,69,64,51,41,87,69,47,59,68,67,47,7,7,9,6,5),(24,24,81,81,81,72,81,79,48,81,57,72,57,58,75,78,78,64,75,75,76,79,70,84,80,78,71,79,75,75,4,5,6,8,8),(25,25,69,81,49,67,59,70,41,43,22,24,73,79,53,29,79,35,77,64,62,43,83,72,75,80,78,77,56,31,7,6,10,10,10),(26,26,84,67,81,46,74,76,58,76,62,77,49,61,70,69,72,72,62,72,74,79,72,81,76,75,43,58,72,67,7,5,9,1,6),(27,27,50,62,52,55,26,15,12,25,14,12,15,67,26,23,23,21,61,69,35,25,23,53,68,25,60,58,63,15,76,69,53,68,76),(28,28,70,71,53,74,73,75,45,58,54,65,63,72,75,83,71,34,74,68,76,84,52,77,83,58,73,68,69,66,7,5,14,8,9),(29,29,80,38,75,52,80,76,75,77,68,82,50,64,65,75,20,61,69,56,73,79,13,77,71,14,48,68,72,67,7,6,5,7,6),(30,30,74,38,74,64,74,65,51,81,60,39,43,48,40,52,14,63,45,62,65,69,15,74,53,17,65,43,49,58,7,1,4,3,4),(31,31,60,65,57,56,57,38,38,30,23,38,65,64,24,35,62,28,52,64,49,38,72,65,64,68,57,59,47,29,4,9,2,5,5),(32,32,64,75,51,64,46,58,27,38,21,32,62,65,47,41,64,24,63,54,52,60,65,72,65,66,67,63,48,23,6,5,19,7,15),(33,33,72,52,69,49,68,45,45,62,42,72,44,55,65,56,34,40,49,65,69,74,48,68,72,56,49,50,67,59,1,2,3,5,6),(34,34,52,35,22,66,17,8,6,10,12,9,13,71,12,9,10,12,17,61,13,23,26,44,43,24,55,18,24,12,69,54,51,50,64),(35,35,71,57,55,31,65,45,43,56,55,43,47,38,60,63,40,52,53,54,66,72,32,65,66,49,49,42,63,50,1,4,7,4,1),(36,36,62,75,43,61,59,37,37,38,42,34,37,61,47,42,52,31,58,68,57,62,64,78,59,66,72,51,48,33,7,2,1,2,9),(37,37,78,32,56,30,57,36,45,45,53,47,61,27,31,54,10,48,46,54,43,71,11,74,39,11,62,49,21,44,2,8,4,8,4),(38,38,62,33,53,54,62,41,41,53,54,43,54,63,62,55,57,53,39,52,63,66,42,58,64,44,64,41,57,45,8,3,6,5,5),(39,39,56,78,67,75,41,31,37,19,19,39,25,76,38,24,79,33,57,65,31,17,85,68,78,69,75,51,52,24,4,1,3,6,2),(40,41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,'Europe'),(2,'Africa'),(3,'Asia'),(4,'Oceania'),(5,'North America'),(6,'South America');
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
INSERT INTO `schema_migrations` VALUES ('20091213140109'),('20091213140924'),('20091214104031'),('20091214104312'),('20091214140704'),('20091218123850'),('20091219070150'),('20091222234521'),('20091225231523'),('20091227075745'),('20091230104100'),('20100113115430'),('20100113124614'),('20100114120528'),('20100115234855'),('20100116085624'),('20100116090112'),('20100116105859'),('20100116121347'),('20100116133545'),('20100116134903'),('20100117010630'),('20100123162508'),('20100126000710'),('20100126230813');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `seasons`
--

LOCK TABLES `seasons` WRITE;
/*!40000 ALTER TABLE `seasons` DISABLE KEYS */;
INSERT INTO `seasons` VALUES (1,'2009-2010',1,1,1),(2,'2010-2011',1,1,0),(3,'2009-2010',2,1,0);
/*!40000 ALTER TABLE `seasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `series`
--

DROP TABLE IF EXISTS `series`;
CREATE TABLE `series` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `abbr` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `series`
--

LOCK TABLES `series` WRITE;
/*!40000 ALTER TABLE `series` DISABLE KEYS */;
INSERT INTO `series` VALUES (1,'UEFA Champions League','CL'),(2,'UEFA Europa League','EL'),(3,'UEFA Super Cup','UEFA SC'),(4,'Premier League','Premier'),(5,'FA Cup','FA Cup'),(6,'League Cup','L. Cup'),(7,'Community Shield','C. Shield'),(8,'League Championship','Championship');
/*!40000 ALTER TABLE `series` ENABLE KEYS */;
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
  `nation_id` int(11) NOT NULL,
  `abbr` varchar(255) collate utf8_unicode_ci default NULL,
  `nickname` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_teams_nations` (`nation_id`),
  CONSTRAINT `fk_teams_nations` FOREIGN KEY (`nation_id`) REFERENCES `nations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'Manchester United',1878,'Old Trafford',4,'Man. Utd.','The Red Devils'),(2,'Liverpool',1892,'Anfield',4,NULL,'The Reds'),(3,'Chelsea',1905,'Stamford Bridge',4,NULL,'The Pensioners'),(4,'Arsenal',1886,'Emirates Stadium',4,NULL,'The Gunners'),(5,'Everton',1878,'Goodison Park',4,NULL,'The Toffees'),(6,'Aston Villa',1874,'Villa Park',4,'Aston V.','The Villa'),(7,'Tottenham Hotspur',1882,'White Hart Lane',4,'Tottenham','Spurs'),(8,'Manchester City',1887,'City of Manchester Stadium',4,'Man. City','The Citizens'),(9,'Fulham',1879,'Craven Cottage',4,NULL,'The Cottagers'),(10,'West Ham United',1895,'Upton Park',4,'West Ham','The Hammers'),(11,'Wigan Athletic',1932,'DW Stadium',4,'Wigan','Latics'),(12,'Stoke City',1863,'Britannia Stadium',4,'Stoke','The Potters'),(13,'Bolton Wanderers',1874,'Reebok Stadium',4,'Bolton','The Trotters'),(14,'Portsmouth',1898,'Fratton Park',4,NULL,'Pompey'),(15,'Blackburn Rovers',1875,'Ewood Park',4,'Blackburn','Rovers'),(16,'Sunderland',1879,'Stadium of Light',4,NULL,'The Black Cats'),(17,'Hull City',1904,'KC Stadium',4,'Hull','The Tigers'),(18,'Wolverhampton',1877,'Molineux Stadium',4,'Wolves','Wolves'),(19,'Birmingham City',1875,'St. Andrew\'s Stadium',4,'Birmingham','Blues'),(20,'Burnley',1882,'Turf Moor',4,NULL,'The Clarets'),(21,'Newcastle United',1892,'St. James\' Park',4,'Newcastle','The Magpies'),(22,'Derby County',1884,'Pride Park Stadium',4,'Derby','The Rams'),(23,'Leeds United',1919,'Elland Road',4,'Leeds Utd.','The Whites'),(24,'Norwich City',1902,'Carrow Road',4,'Norwich','The Canaries'),(25,'West Bromwich Albion',1878,'The Hawthorns',4,'West Brom.','The Baggies'),(26,'Nottingham Forest',1865,'City Ground',4,'Nottingham','Forest'),(27,'Cardiff City',1899,'Cardiff City Stadium',4,'Cardiff','The Bluebirds'),(28,'Sheffield United',1889,'Bramall Lane',4,'Sheffield','The Blades'),(29,'Ipswich Town',1878,'Portman Road',4,'Ipswich','Town'),(30,'Dagenham & Redbridge',1992,'Victoria Road',4,'Dag & Red','The Daggers'),(31,'Standard Liege',1898,'Stade Maurice Dufrasne',6,'Std. Liege','Les Rouches'),(32,'Galatasaray SK',1905,'Ali Sami Yen Stadium',21,'Galatasary','Cim Bom'),(33,'Alkmaar Zaanstreek',1967,'DSB Stadion',11,'AZ','AZ'),(34,'Atletico Madrid',1903,'Vicente Calderon',22,'Atletico M','Los colchoneros'),(35,'Middlesbrough',1876,'Riverside Stadium',4,'Middlesbr.','The Boro'),(36,'Bradford Park Avenue',1863,'Horsfall Stadium',4,'Bradfrd PA','The Avenue'),(37,'Coventry City',1883,'Ricoh Arena',4,'Coventry','The Sky Blues'),(38,'Swansea City',1912,'Liberty Stadium',4,'Swansea','The Swans'),(39,'Leicester City',1884,'Walkers Stadium',4,'Leicester','The Foxes'),(40,'Crystal Palace',1905,'Selhurst Park',4,'Crystal P.','The Eagles'),(41,'AC Milan',1899,'San Siro',9,NULL,'Rossoneri'),(42,'Besiktas',1903,'BJK Inonu Stadium',21,NULL,'Kara Kartallar'),(43,'VfL Wolfsburg',1945,'Volkswagen Arena',7,'Wolfsburg','Die Wolfe'),(44,'CSKA Moscow',1911,'Luzhniki Stadium',82,'CSKA Mscow','Koni'),(45,'TBD',NULL,'To be determined...',4,NULL,NULL),(46,'Porto',1893,'Estadio do Dragao',15,NULL,'Dragoes'),(47,'Barcelona',1899,'Camp Nou',22,NULL,'L\'equip blaugrana'),(48,'Real Madrid',1902,'Estadio Santiago Bernabeu',22,NULL,'Los Blancos');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `hashed_password` varchar(255) collate utf8_unicode_ci default NULL,
  `salt` varchar(255) collate utf8_unicode_ci default NULL,
  `is_writer` tinyint(1) NOT NULL default '0',
  `is_admin` tinyint(1) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'kumagai','5e92e4de63468ec22a23002bdd87063b762f79a0','29638100.368817561253004',1,1,'2010-01-27 08:48:33','2010-02-03 12:09:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-02-22 10:44:16
