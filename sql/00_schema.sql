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
-- Table structure for table `alert_types`
--

DROP TABLE IF EXISTS `alert_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) DEFAULT NULL,
  `priority` int(11) NOT NULL,
  `cancel_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alert_type` int(11) NOT NULL,
  `object_type` varchar(16) DEFAULT NULL,
  `object_id` int(11) NULL,
  `object_name` varchar(32) NOT NULL,
  `test` boolean DEFAULT false,
  `raised` timestamp,
  PRIMARY KEY (`id`),
  CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`alert_type`) REFERENCES `alert_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `alert_groups`
--

DROP TABLE IF EXISTS `alert_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `hours_begin` time NOT NULL,
  `hours_end` time NOT NULL,
  `weekdays_begin` tinyint(4) NOT NULL,
  `weekdays_end` tinyint(4) NOT NULL,
  `email_level` int(11) NOT NULL,
  `sms_level` int(11) NOT NULL,
  `enabled` tinyint(1) DEFAULT 1,
  `auto` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alert_groupusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_groupusers` (
  `alert_group` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  UNIQUE KEY `alert_groupuser_user` (`alert_group`,`user`),
  CONSTRAINT `alert_groupusers_ibfk_1` FOREIGN KEY (`alert_group`) REFERENCES `alert_groups` (`id`),
  CONSTRAINT `alert_groupusers_ibfk_2` FOREIGN KEY (`user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `siteclasses`
--

DROP TABLE IF EXISTS `siteclasses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `siteclasses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `alert_type_up` int(11) NOT NULL,
  `alert_type_down` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `siteclasses_ibfk_1` FOREIGN KEY (`alert_type_up`) REFERENCES `alert_types` (`id`),
  CONSTRAINT `siteclasses_ibfk_2` FOREIGN KEY (`alert_type_down`) REFERENCES `alert_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `class` int(11) DEFAULT '1',
  `x` int(11) DEFAULT '100',
  `y` int(11) DEFAULT '100',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `sites_ibfk_1` FOREIGN KEY (`class`) REFERENCES `siteclasses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `hostclasses`
--

DROP TABLE IF EXISTS `hostclasses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostclasses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `alert_type_up` int(11) NOT NULL,
  `alert_type_down` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `hostclasses_ibfk_1` FOREIGN KEY (`alert_type_up`) REFERENCES `alert_types` (`id`),
  CONSTRAINT `hostclasses_ibfk_2` FOREIGN KEY (`alert_type_down`) REFERENCES `alert_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `disabled` tinyint(1) DEFAULT '0',
  `alert` tinyint(1) DEFAULT '1',
  `class` int(11) DEFAULT '1',
  `x` int(11) DEFAULT '100',
  `y` int(11) DEFAULT '100',
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
  CONSTRAINT `hosts_ibfk_1` FOREIGN KEY (`site`) REFERENCES `sites` (`id`),
  CONSTRAINT `hosts_ibfk_2` FOREIGN KEY (`class`) REFERENCES `hostclasses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  CONSTRAINT `hostgroupmembers_ibfk_1` FOREIGN KEY (`host`) REFERENCES `hosts` (`id`),
  CONSTRAINT `hostgroupmembers_ibfk_2` FOREIGN KEY (`hostgroup`) REFERENCES `hostgroups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `hostgroups_ibfk_1` FOREIGN KEY (`site`) REFERENCES `sites` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ports`
--

DROP TABLE IF EXISTS `ports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `up` float DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `index` int(11) DEFAULT NULL,
  `admin` tinyint DEFAULT NULL,
  `speed` int(11) DEFAULT NULL,
  `vlan` int(11) DEFAULT NULL,
  `description` varchar(64) DEFAULT NULL,
  `host` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `host` (`host`),
  KEY `index` (`index`),
  UNIQUE KEY `name_host` (`name`,`host`),
  CONSTRAINT `ports_ibfk_1` FOREIGN KEY (`host`) REFERENCES `hosts` (`id`),
  CONSTRAINT `ports_ibfk_2` FOREIGN KEY (`vlan`) REFERENCES `vlans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
-- Table structure for table `macsightings`
--

DROP TABLE IF EXISTS `macsightings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `macsightings` (
  `mac` int(11) NOT NULL,
  `vlan` int(11) DEFAULT NULL,
  `port` int(11) NOT NULL,
  `recorded` datetime DEFAULT NOW(),
  KEY `mac` (`mac`),
  KEY `vlan` (`vlan`),
  KEY `port` (`port`),
  UNIQUE KEY `mac_vlan_port` (`mac`,`vlan`,`port`),
  CONSTRAINT `macsightings_ibfk_1` FOREIGN KEY (`mac`) REFERENCES `macs` (`id`),
  CONSTRAINT `macsightings_ibfk_2` FOREIGN KEY (`vlan`) REFERENCES `vlans` (`id`),
  CONSTRAINT `macsightings_ibfk_3` FOREIGN KEY (`port`) REFERENCES `ports` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arpsightings`
--

DROP TABLE IF EXISTS `arpsightings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arpsightings` (
  `mac` int(11) NOT NULL,
  `ipn` int(11) UNSIGNED NOT NULL,
  `port` int(11) NOT NULL,
  `recorded` datetime DEFAULT NOW(),
  KEY `mac` (`mac`),
  KEY `ipn` (`ipn`),
  KEY `port` (`port`),
  UNIQUE KEY `mac_ipn_port` (`mac`,`ipn`,`port`),
  CONSTRAINT `arpsightings_ibfk_1` FOREIGN KEY (`mac`) REFERENCES `macs` (`id`),
  CONSTRAINT `arpsightings_ibfk_2` FOREIGN KEY (`port`) REFERENCES `ports` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `sitegroupmembers_ibfk_1` FOREIGN KEY (`site`) REFERENCES `sites` (`id`),
  CONSTRAINT `sitegroupmembers_ibfk_2` FOREIGN KEY (`sitegroup`) REFERENCES `sitegroups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  `alert` tinyint(1) DEFAULT 0,
  `email` varchar(64) DEFAULT NULL,
  `sms` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_realm` (`username`,`realm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


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
-- Table structure for table `vlansightings`
--

DROP TABLE IF EXISTS `vlansightings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlansightings` (
  `vlan` int(11) NOT NULL,
  `port` int(11) NOT NULL,
  `recorded` datetime NOT NULL,
  KEY `vlan` (`vlan`),
  KEY `port` (`port`),
  KEY `recorded` (`recorded`),
  CONSTRAINT `vlansightings_ibfk_1` FOREIGN KEY (`vlan`) REFERENCES `vlans` (`id`),
  CONSTRAINT `vlansightings_ibfk_2` FOREIGN KEY (`port`) REFERENCES `ports` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


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
  KEY `commlinks_ibfk_2` (`host2`),
  CONSTRAINT `commlinks_ibfk_1` FOREIGN KEY (`host1`) REFERENCES `hosts` (`id`),
  CONSTRAINT `commlinks_ibfk_2` FOREIGN KEY (`host2`) REFERENCES `hosts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;



-- Dump completed on 2017-09-29  9:06:50
