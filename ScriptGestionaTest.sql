CREATE DATABASE  IF NOT EXISTS `GBDgestionaTests` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `GBDgestionaTests`;
-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (i686)
--
-- Host: 127.0.0.1    Database: GBDgestionaTests
-- ------------------------------------------------------
-- Server version	5.5.35-0ubuntu0.12.04.2

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
-- Table structure for table `alumnos`
--

DROP TABLE IF EXISTS `alumnos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alumnos` (
  `numexped` char(12) NOT NULL DEFAULT '',
  `nomalum` varchar(30) DEFAULT NULL,
  `ape1alum` varchar(30) DEFAULT NULL,
  `ape2alum` varchar(30) DEFAULT NULL,
  `fecnacim` date DEFAULT NULL,
  `observaciones` text,
  `calle` varchar(60) DEFAULT NULL,
  `poblacion` varchar(60) DEFAULT NULL,
  `codpostal` char(5) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `telefono` char(12) DEFAULT NULL,
  `nomuser` char(8) DEFAULT '12345678',
  `password` char(12) DEFAULT NULL,
  PRIMARY KEY (`numexped`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumnos`
--

LOCK TABLES `alumnos` WRITE;
/*!40000 ALTER TABLE `alumnos` DISABLE KEYS */;
INSERT INTO `alumnos` VALUES ('1','Loreta','Zapata',NULL,'2002-01-01',NULL,'C/ Eras 18','Pedrezuela','28723','LoretaZapataOzuna@trashymail.com','911 703 967','12345678','`M327naJ'),('10','Michele','Acosta',NULL,'2002-02-21',NULL,'Zumalakarregi etorbidea 83','Calvià','07184','MicheleAcostaLuevano@dodgit.com','971 452 132','12345678','`N481beF'),('11','Sofiel','Centeno',NULL,'2002-04-21',NULL,'Avendaño 72','Níjar','04100','SofielCentenoApodaca@trashymail.com','710 745 168','12345678','nT001rpA'),('12','Abbot','Valadez',NULL,'2001-11-30',NULL,'C/ Domingo Beltrán 62','Mahora','02240','AbbotValadezCenteno@spambob.com','967 914 876','12345678','yB042voN'),('13','Myrna','Ibarra',NULL,'2000-02-05',NULL,'Atamaria 37','Pontecesures','36640','MyrnaIbarraRodriguez@mailinator.com','886 479 253','12345678','`N046beF'),('14','Hilario','Alonso',NULL,'2000-12-20',NULL,'Avda. Explanada Barnuevo 23','Artenara','35350','HilarioAlonsoTijerina@pookmail.com','928 949 392','12345678','nI053ceD'),('15','Elsira','Gaytan',NULL,'2003-02-20',NULL,'El Roqueo 41','Ribeira','15960','ElsiraGaytanVillagomez@pookmail.com','881 364 701','12345678','mF069beF'),('16','Nacho','Batista',NULL,'1999-12-03',NULL,'Cartagena 6','Cehegín','30430','NachoBatistaFranco@spambob.com','643 260 124','12345678','`O034ceD'),('17','Evarista','Torres',NULL,'1999-06-04',NULL,'Avda. Andalucía 96','Rabanera','26133','EvaristaTorresSalazar@mailinator.com','687 956 187','12345678','rF331nuJ'),('18','Domiciano','Ballesteros',NULL,'2001-10-17',NULL,'Plaza Colón 81','Astorga','24700','DomicianoBallesterosUribe@dodgit.com','785 112 581','12345678','rE007tcO'),('19','Arquímedes','Muñiz',NULL,'2001-09-17',NULL,'C/ Eras 53','Lozoya','28742','ArquimedesMunizCordova@trashymail.com','915 232 873','12345678','yB247peS'),('2','Teodequilda','Godoy',NULL,'2001-08-09',NULL,'Eusebio Dávila 82','La Campana','41429','TeodequildaGodoyBahena@dodgit.com','955 510 917','12345678','xU924guA'),('20','Eira','Salcido',NULL,'2001-08-15',NULL,'Ctra. Bailén-Motril 66','Santa Elena','23213','EiraSalcidoTirado@trashymail.com','953 001 863','12345678','nF312guA'),('21','Carmine','Mata',NULL,'2002-07-01',NULL,'Ctra. Hornos 33','Ochánduri','26213','CarmineMataCarrera@trashymail.com','941 573 470','12345678','`D312luJ'),('22','Patsy','Cordova',NULL,'2002-06-14',NULL,'Calvo Sotelo 85','Tudela de Duero','47320','PatsyCordovaLebron@trashymail.com','983 328 940','12345678','`Q023nuJ'),('23','Madeleine','Merino',NULL,'2002-06-14',NULL,'Cercas Bajas 89','Lliçà d\'Amunt','08186','MadeleineMerinoPosada@mailinator.com','932 032 333','12345678','nN681nuJ'),('24','Hilen','Anaya',NULL,'2001-06-21',NULL,'Cartagena 54','Ulea','30612','HilenAnayaEnriquez@mailinator.com','637 192 074','12345678','`I216nuJ'),('25','Gian','Gastelum',NULL,'2001-06-29',NULL,'Paseo Junquera 33','Caudiel','12440','GianGastelumBarrientos@pookmail.com','964 171 853','12345678','lH044nuJ'),('26','Fuencista','Becerra',NULL,'1998-06-29',NULL,'C/ Benito Guinea 35','Premià de Mar','08330','FuencistaBecerraAlvarez@pookmail.com','937 478 804','12345678','`G033nuJ'),('27','Georges','Matos',NULL,'2003-12-18',NULL,'C/ Canarias 96','Hernani','20120','GeorgesMatosNevarez@trashymail.com','665 977 426','12345678','rH021ceD'),('28','Midas','Saenz',NULL,'2001-01-15',NULL,'Antonio Vázquez 19','Fuencaliente de la Palma','38740','MidasSaenzEspinal@spambob.com','822 724 166','12345678','yN047naJ'),('29','Ray','Villareal',NULL,'2002-11-15',NULL,'Cruce Casa de Postas 36','Pampaneira','18411','RayVillarealColunga@mailinator.com','789 149 909','12345678','kS114voN'),('3','Danel','Jimínez',NULL,'2000-11-19',NULL,'Outid de Arriba 7','Alcanar','43530','DanelJiminezSisneros@pookmail.com','877 886 700','12345678','yE035voN'),('30','Joseph','Haro',NULL,'2000-11-19',NULL,'C/ Rosa de los Vientos 87','Arcos de la Frontera','11630','JosephHaroPrado@pookmail.com','716 392 850','12345678','nK036voN'),('31','Alejandrino','Romero',NULL,'2000-02-21',NULL,'Reiseñor 97','Quintanar de la Orden','45800','AlejandrinoRomeroMadrid@mailinator.com','925 152 955','12345678','nB008beF'),('32','Lain','Alaniz',NULL,'1985-04-01',NULL,'C/ Henan Cortes 85','Alcorcón','28920','LainAlanizJasso@trashymail.com','917 441 902','12345678','yM029rpA'),('33','Jessica','Rojo',NULL,'2001-04-15',NULL,'El Roqueo 54','Vedra','15885','JessicaRojoNava@mailinator.com','981 095 481','12345678','nK588rpA'),('34','Minotauro','Hinojosa',NULL,'2001-04-17',NULL,'Prolongacion San Sebastian 62','Linares de la Sierra','21341','MinotauroHinojosaMojica@dodgit.com','959 586 346','12345678','`N143rpA'),('35','Ahmed','Zaragoza',NULL,'2001-04-17',NULL,'Cañadilla 46','Aínsa-Sobrarbe','22330','AhmedZaragozaVera@trashymail.com','974 901 458','12345678','`B033rpA'),('36','Cupido','Sotelo',NULL,'2001-09-13',NULL,'C/ Los Herrán 91','Villafranca de los Barros','06220','CupidoSoteloRodrigez@mailinator.com','628 406 327','12345678','nD022peS'),('37','Grau','Nino',NULL,'2001-05-18',NULL,'Paseo del Atlántico 46','Arenas del Rey','18126','GrauNinoRubio@pookmail.com','858 206 685','12345678','nH621yaM'),('38','Chiara','Leyva',NULL,'2001-08-18',NULL,'Paseo del Atlántico 92','Píñar','18127','ChiaraLeyvaRojo@spambob.com','958 466 144','12345678','`D721guA'),('39','Neptuno','Gamboa',NULL,'2003-07-11',NULL,'La Fontanilla 35','Villanueva de Córdoba','14440','NeptunoGamboaPorras@dodgit.com','957 024 646','12345678','`O044luJ'),('4','Eliezer','Arroyo',NULL,'2003-09-04',NULL,'Quevedo 1','Cariño','15360','EliezerArroyoPedraza@pookmail.com','981 329 553','12345678','nF063peS'),('40','Adassa','Porras',NULL,'2003-09-22',NULL,'Cartagena 3','Ojós','30611','AdassaPorrasApodaca@dodgit.com','868 006 445','12345678','rB116peS'),('41','Arydea','Segura',NULL,'2003-01-22',NULL,'Ctra. de la Puerta 42','Bergasa','26588','ArydeaSeguraZavala@dodgit.com','941 042 551','12345678','`B885naJ'),('42','Daila','Mena',NULL,'2003-01-12',NULL,'Cádiz 87','Ferreira','18513','DailaMenaTafoya@trashymail.com','958 000 361','12345678','`E315naJ'),('43','Igone','Gutiérrez',NULL,'2001-03-12',NULL,'Socampo 1','Sepulcro-Hilario','37638','IgoneGutierrezHernadez@pookmail.com','923 105 288','12345678','yJ836raM'),('44','Clotilde','Ulibarri',NULL,'2001-04-18',NULL,'Ventanilla de Beas 56','Madrid','28000','ClotildeUlibarriVelasco@mailinator.com','913 015 945','12345678','hD000rpA'),('45','Lara','Varela',NULL,'2001-04-30',NULL,'Cartagena 97','Caravaca de la Cruz','30400','LaraVarelaSoria@pookmail.com','691 127 389','12345678','`M004rpA'),('46','Dalma','Abrego',NULL,'1998-04-10',NULL,'Alcon Molina 8','Mazarrón','30870','DalmaAbregoSaldana@pookmail.com','868 570 420','12345678','nE078rpA'),('47','Prudencio','Haro',NULL,'2002-08-10',NULL,'Rúa de San Pedro 42','Berrocal de Salvatierra','37795','PrudencioHaroSanabria@mailinator.com','663 979 020','12345678','nQ597guA'),('48','Yair','Reyna',NULL,'2002-07-21',NULL,'Prolongacion San Sebastian 87','El Cerro de Andévalo','21320','YairReynaHinojosa@mailinator.com','693 941 435','12345678','`Z023luJ'),('49','Marién','Tejada',NULL,'2002-10-30',NULL,'Rua da Rapina 91','Aldehuela de la Bóveda','37460','MarienTejadaRangel@mailinator.com','923 579 458','12345678','`N064tcO'),('5','Clelia','Gurule',NULL,'2001-10-05',NULL,'C/ Amoladera 95','Ajalvir','28864','CleliaGuruleBenitez@mailinator.com','911 626 241','12345678','dD468tcO'),('50','Amira','Cardona',NULL,'2000-09-07',NULL,'Salzillo 91','A Mezquita','32549','AmiraCardonaBarela@pookmail.com','988 016 388','12345678','`B945peS'),('51','Maggie','Benavidez',NULL,'2001-09-11',NULL,'C/ Amoladera 20','Ribatejada','28815','MaggieBenavidezCenteno@pookmail.com','913 712 363','12345678','yN518peS'),('52','Uberto','Mateo',NULL,'2002-12-19',NULL,'Plaza Colón 51','Albelda de Iregua','26120','UbertoMateoUrias@pookmail.com','941 077 139','12345678','nV021ceD'),('53','Apia','Carrión',NULL,'0000-00-00',NULL,'Alcon Molina 94','Los Alcázares','30710','ApiaCarrionRocha@pookmail.com','968 843 679','12345678',NULL),('54','Emillen','Oquendo',NULL,'0000-00-00',NULL,'Zumalakarregi etorbidea 58','Bunyola','07110','EmillenOquendoPichardo@spambob.com','971 142 335','12345678',NULL),('55','Erico','Barrios',NULL,'0000-00-00',NULL,'Bouciña 35','Amposta','43870','EricoBarriosRael@pookmail.com','601 095 182','12345678',NULL),('6','Longinos','Nazario',NULL,'0000-00-00',NULL,'Enxertos 49','La Atalaya','37591','LonginosNazarioAcevedo@mailinator.com','923 684 639','12345678',NULL),('7','Débora','Carranza',NULL,'0000-00-00',NULL,'Avda. de la Estación 80','Chapinería','28694','DeboraCarranzaOrdonez@mailinator.com','911 956 522','12345678',NULL),('8','Florida','Candelaria',NULL,'0000-00-00',NULL,'C/ Libertad 80','El Barraco','05110','FloridaCandelariaOcasio@mailinator.com','920 308 253','12345678',NULL),('9','Elisea','Pabón',NULL,'0000-00-00',NULL,'Ctra. Villena 11','San Martín del Rey Aurelio','33950','EliseaPabonAngulo@dodgit.com','984 208 438','12345678',NULL);
/*!40000 ALTER TABLE `alumnos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tests`
--

DROP TABLE IF EXISTS `tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tests` (
  `codtest` int(11) NOT NULL DEFAULT '0',
  `descrip` varchar(30) DEFAULT NULL,
  `unidadtest` int(11) DEFAULT NULL,
  `codmateria` int(11) DEFAULT NULL,
  `repetible` tinyint(4) DEFAULT NULL,
  `feccreacion` datetime DEFAULT NULL,
  `fecpublic` datetime DEFAULT NULL,
  PRIMARY KEY (`codtest`),
  KEY `fk_tests_materia` (`codmateria`),
  CONSTRAINT `fk_tests_materia` FOREIGN KEY (`codmateria`) REFERENCES `materias` (`codmateria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tests`
--

LOCK TABLES `tests` WRITE;
/*!40000 ALTER TABLE `tests` DISABLE KEYS */;
INSERT INTO `tests` VALUES (1,'Test 1 matematicas 1ESO',1,1,1,'2012-10-10 00:00:00','2012-10-10 00:00:00'),(2,'Test 2 matematicas 1ESO',1,1,0,'2012-12-10 00:00:00','2012-12-10 00:00:00'),(3,'Test 3 matematicas 1ESO',2,1,1,'2012-12-10 00:00:00','2012-12-10 00:00:00'),(4,'Test 4 matematicas 1ESO',3,1,1,'2012-10-11 00:00:00','2012-10-11 00:00:00'),(5,'Test 1 matematicas 2ESO',1,1,0,'2012-10-10 00:00:00','2012-10-10 00:00:00');
/*!40000 ALTER TABLE `tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestas`
--

DROP TABLE IF EXISTS `respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `respuestas` (
  `numexped` char(12) NOT NULL DEFAULT '',
  `codtest` int(11) NOT NULL DEFAULT '0',
  `numpreg` int(11) NOT NULL DEFAULT '0',
  `numrepeticion` tinyint(4) NOT NULL DEFAULT '0',
  `respuesta` char(1) DEFAULT NULL,
  PRIMARY KEY (`numexped`,`codtest`,`numpreg`,`numrepeticion`),
  KEY `fk_respuestas_preguntas` (`codtest`,`numpreg`),
  CONSTRAINT `fk_respuestas_alumnos` FOREIGN KEY (`numexped`) REFERENCES `alumnos` (`numexped`),
  CONSTRAINT `fk_respuestas_preguntas` FOREIGN KEY (`codtest`, `numpreg`) REFERENCES `preguntas` (`codtest`, `numpreg`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas`
--

LOCK TABLES `respuestas` WRITE;
/*!40000 ALTER TABLE `respuestas` DISABLE KEYS */;
INSERT INTO `respuestas` VALUES ('1',1,1,1,'a'),('1',1,1,2,'b'),('1',1,2,1,'b'),('1',1,2,2,'c'),('1',1,3,1,'c'),('1',1,3,2,'c'),('1',1,4,1,'d'),('1',1,4,2,'d'),('12',1,1,1,'a'),('12',1,2,1,'b'),('12',1,3,1,'c'),('12',1,4,1,'d');
/*!40000 ALTER TABLE `respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias`
--

DROP TABLE IF EXISTS `materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `materias` (
  `codmateria` int(11) NOT NULL DEFAULT '0',
  `nommateria` varchar(60) DEFAULT NULL,
  `cursomateria` char(6) DEFAULT NULL,
  PRIMARY KEY (`codmateria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias`
--

LOCK TABLES `materias` WRITE;
/*!40000 ALTER TABLE `materias` DISABLE KEYS */;
INSERT INTO `materias` VALUES (1,'MATEMÁTICAS','1ESO'),(2,'MATEMÁTICAS','2ESO'),(3,'MATEMÁTICAS','3ESO'),(4,'MATEMÁTICAS','4ESO'),(5,'MATEMÁTICAS TECNOLÓGICAS','1BAC'),(6,'MATEMÁTICAS TECNOLÓGICAS','2BAC'),(7,'MATEMÁTICAS DE LAS CIENCIAS SOCIALES','1BAC'),(8,'MATEMÁTICAS DE LAS CIENCIAS SOCIALES','2BAC'),(9,'MATEMÁTICAS DE LA SALUD','1BAC'),(10,'MATEMÁTICAS DE LA SALUD','2BAC'),(11,'LENGUA CASTELLANA Y LITERATURA','1ESO'),(12,'LENGUA CASTELLANA Y LITERATURA','2ESO'),(13,'LENGUA CASTELLANA Y LITERATURA','3ESO'),(14,'LENGUA CASTELLANA Y LITERATURA','4ESO'),(15,'LENGUA CASTELLANA Y LITERATURA','1BAC'),(16,'LENGUA CASTELLANA Y LITERATURA','2BAC'),(17,'CIENCIAS SOCIALES','1ESO'),(18,'CIENCIAS SOCIALES','2ESO'),(19,'CIENCIAS SOCIALES','3ESO'),(20,'CIENCIAS SOCIALES','4ESO'),(21,'GEOGRAFÍA E HISTORIA','1BAC'),(22,'HISTORIA','2BAC'),(23,'HISTORIA DEL ARTE','1BAC'),(24,'GEOGRAFÍA','2BAC'),(25,'BIOLOGÍA','1BAC'),(26,'FÍSICA','2BAC'),(27,'FÍSICA Y QUÍMICA','1ESO'),(28,'TECNOLOGÍA','2ESO'),(29,'TECNOLOGÍA','3ESO'),(30,'TECNOLOGÍA','4ESO'),(31,'TECNOLOGÍAS DE LA INFORMACIÓN Y LA COMUNICACIÓN','1BAC'),(32,'TECNOLOGÍAS DE LA INFORMACIÓN Y LA COMUNICACIÓN','2BAC'),(33,'GESTIÓN DE BASES DE DATOS','1ASIR'),(34,'LENGUAJES DE MARCAS','1ASIR'),(35,'ADMINISTRACIÓN DE SISTEMAS GESTORES DE BASES DE DATOS','2ASIR'),(36,'SEGURIDAD INFORMÁTICA','2ASIR'),(37,'REDES DE ÁREA LOCAL','1ASIR'),(38,'SERVICIOS EN RED','2ASIR');
/*!40000 ALTER TABLE `materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntas`
--

DROP TABLE IF EXISTS `preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preguntas` (
  `codtest` int(11) NOT NULL DEFAULT '0',
  `numpreg` int(11) NOT NULL DEFAULT '0',
  `textopreg` varchar(200) DEFAULT NULL,
  `resa` varchar(100) DEFAULT NULL,
  `resb` varchar(100) DEFAULT NULL,
  `resc` varchar(100) DEFAULT NULL,
  `resvalida` char(1) DEFAULT NULL,
  PRIMARY KEY (`codtest`,`numpreg`),
  CONSTRAINT `fk_preguntas_tests` FOREIGN KEY (`codtest`) REFERENCES `tests` (`codtest`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,1,'5 + 7','-2','12','0','b'),(1,2,'5 - 7','-2','12','0','a'),(1,3,'-5 + 17','-2','12','0','b'),(1,4,'300 - 520','-2','120','-120','c'),(1,5,'-2*300','600','298','-600','c'),(2,1,'-25 - 17','-42','12','0','a'),(2,2,'23 - 1 + 2','25','20','24','c'),(2,3,'-19 + 15 - 3','-2','-7','-17','b'),(2,4,'3 + (-5)','-2','8','-8','a'),(3,1,'45/2','22,50','-20','22,45','a'),(3,2,'100/3','33','30,33','33,3333','c');
/*!40000 ALTER TABLE `preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matriculas`
--

DROP TABLE IF EXISTS `matriculas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matriculas` (
  `numexped` char(12) NOT NULL DEFAULT '',
  `codmateria` int(11) NOT NULL DEFAULT '0',
  `nota` int(11) DEFAULT NULL,
  PRIMARY KEY (`numexped`,`codmateria`),
  KEY `fk_matriculas_materias` (`codmateria`),
  CONSTRAINT `fk_matriculas_alumnos` FOREIGN KEY (`numexped`) REFERENCES `alumnos` (`numexped`),
  CONSTRAINT `fk_matriculas_materias` FOREIGN KEY (`codmateria`) REFERENCES `materias` (`codmateria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matriculas`
--

LOCK TABLES `matriculas` WRITE;
/*!40000 ALTER TABLE `matriculas` DISABLE KEYS */;
INSERT INTO `matriculas` VALUES ('1',1,6),('1',11,8),('1',17,3),('1',27,5),('10',33,NULL),('12',1,9),('14',1,2),('15',33,6),('2',1,NULL),('2',2,1),('21',1,7),('30',1,4);
/*!40000 ALTER TABLE `matriculas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-03-28  7:05:28
