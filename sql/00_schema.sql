-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: atlas5
-- ------------------------------------------------------
-- Server version	5.7.18-0ubuntu0.16.04.1

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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `realm` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_realm` (`username`,`realm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  `x` int(11) DEFAULT 100,
  `y` int(11) DEFAULT 100,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(16) DEFAULT NULL,
  `site` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `disabled` boolean DEFAULT FALSE,
  `x` int(11) DEFAULT 100,
  `y` int(11) DEFAULT 100,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `alive` datetime DEFAULT NULL,
  `checked` datetime DEFAULT NULL,
  `scanned` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `disabled` (`disabled`),
  KEY `ip` (`ip`),
  KEY `site` (`site`),
  KEY `alive` (`alive`),
  KEY `checked` (`checked`),
  KEY `scanned` (`scanned`),
  CONSTRAINT `hosts_ibfk_1` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts`
--

LOCK TABLES `hosts` WRITE;
/*!40000 ALTER TABLE `hosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hostgroupmembers`
--

DROP TABLE IF EXISTS `hostgroupmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostgroupmembers` (
  `host` int(11) NOT NULL,
  `hostgroup` int(11) NOT NULL,
  UNIQUE KEY `host_hostgroup` (`host`,`hostgroup`),
  KEY `hostgroup` (`hostgroup`),
  CONSTRAINT `hostgroupmembers_ibfk_1` FOREIGN KEY (`host`) REFERENCES `hosts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `hostgroupmembers_ibfk_2` FOREIGN KEY (`hostgroup`) REFERENCES `hostgroups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostgroupmembers`
--

LOCK TABLES `hostgroupmembers` WRITE;
/*!40000 ALTER TABLE `hostgroupmembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostgroupmembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hostgroups`
--

DROP TABLE IF EXISTS `hostgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  `site` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_site` (`name`,`site`),
  KEY `site` (`site`),
  CONSTRAINT `hostgroups_ibfk_1` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostgroups`
--

LOCK TABLES `hostgroups` WRITE;
/*!40000 ALTER TABLE `hostgroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commlinks`
--

DROP TABLE IF EXISTS `commlinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commlinks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `host1` int(11) NOT NULL,
  `host2` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `host1_host2` (`host1`,`host2`),
  CONSTRAINT `commlinks_ibfk_1` FOREIGN KEY (`host1`) REFERENCES `hosts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `commlinks_ibfk_2` FOREIGN KEY (`host2`) REFERENCES `hosts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commlinks`
--

LOCK TABLES `commlinks` WRITE;
/*!40000 ALTER TABLE `commlinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `commlinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interfaces`
--

DROP TABLE IF EXISTS `interfaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interfaces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(64) DEFAULT NULL,
  `host` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `host` (`host`),
  CONSTRAINT `interfaces_ibfk_1` FOREIGN KEY (`host`) REFERENCES `hosts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interfaces`
--

LOCK TABLES `interfaces` WRITE;
/*!40000 ALTER TABLE `interfaces` DISABLE KEYS */;
/*!40000 ALTER TABLE `interfaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `macs`
--

DROP TABLE IF EXISTS `macs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `macs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `macs`
--

LOCK TABLES `macs` WRITE;
/*!40000 ALTER TABLE `macs` DISABLE KEYS */;
/*!40000 ALTER TABLE `macs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `macsightings`
--

DROP TABLE IF EXISTS `macsightings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `macsightings` (
  `mac` int(11) NOT NULL,
  `vlan` int(11) DEFAULT NULL,
  `interface` int(11) NOT NULL,
  `recorded` datetime NOT NULL,
  KEY `mac` (`mac`),
  KEY `vlan` (`vlan`),
  KEY `interface` (`interface`),
  CONSTRAINT `macsightings_ibfk_1` FOREIGN KEY (`mac`) REFERENCES `macs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `macsightings_ibfk_2` FOREIGN KEY (`vlan`) REFERENCES `vlans` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `macsightings_ibfk_3` FOREIGN KEY (`interface`) REFERENCES `interfaces` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `macsightings`
--

LOCK TABLES `macsightings` WRITE;
/*!40000 ALTER TABLE `macsightings` DISABLE KEYS */;
/*!40000 ALTER TABLE `macsightings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitegroupmembers`
--

DROP TABLE IF EXISTS `sitegroupmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitegroupmembers` (
  `site` int(11) NOT NULL,
  `sitegroup` int(11) NOT NULL,
  UNIQUE KEY `site_sitegroup` (`site`,`sitegroup`),
  KEY `sitegroup` (`sitegroup`),
  CONSTRAINT `sitegroupmembers_ibfk_1` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sitegroupmembers_ibfk_2` FOREIGN KEY (`sitegroup`) REFERENCES `sitegroups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitegroupmembers`
--

LOCK TABLES `sitegroupmembers` WRITE;
/*!40000 ALTER TABLE `sitegroupmembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitegroupmembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitegroups`
--

DROP TABLE IF EXISTS `sitegroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitegroups`
--

LOCK TABLES `sitegroups` WRITE;
/*!40000 ALTER TABLE `sitegroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitegroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vlans`
--

DROP TABLE IF EXISTS `vlans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlans` (
  `id` int(11) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vlans`
--

LOCK TABLES `vlans` WRITE;
/*!40000 ALTER TABLE `vlans` DISABLE KEYS */;
/*!40000 ALTER TABLE `vlans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vlansightings`
--

DROP TABLE IF EXISTS `vlansightings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlansightings` (
  `vlan` int(11) NOT NULL,
  `interface` int(11) NOT NULL,
  `recorded` datetime NOT NULL,
  KEY `vlan` (`vlan`),
  KEY `interface` (`interface`),
  KEY `recorded` (`recorded`),
  CONSTRAINT `vlansightings_ibfk_1` FOREIGN KEY (`vlan`) REFERENCES `vlans` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `vlansightings_ibfk_2` FOREIGN KEY (`interface`) REFERENCES `interfaces` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vlansightings`
--

LOCK TABLES `vlansightings` WRITE;
/*!40000 ALTER TABLE `vlansightings` DISABLE KEYS */;
/*!40000 ALTER TABLE `vlansightings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-08 14:17:52
