
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (1,'LINEPROTO UP',100,2);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (2,'LINEPROTO DOWN',150,1);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (3,'INTERFACE UP',200,4);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (4,'INTERFACE DOWN',250,3);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (5,'HOST UP',300,6);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (6,'HOST DOWN',350,5);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (7,'HOSTGROUP UP',400,8);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (8,'HOSTGROUP DOWN',450,7);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (9,'SITE UP',500,10);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (10,'SITE DOWN',550,9);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (11,'SITEGROUP UP',600,12);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (12,'SITEGROUP DOWN',650,11);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (13,'INTERNET UP',70,14); 
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (14,'INTERNET DOWN',75,13); 
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (15,'TEMP.NORMAL',80,16);
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (16,'TEMP.WARNING',85,15); 
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (17,'POWER RESTORED',90,18); 
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (18,'POWER FAILURE',95,17); 
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (19,'GENERATOR OFF',93,20); 
INSERT INTO alert_types (id,name,priority,cancel_id) VALUES (20,'GENERATOR ON',97,19); 



INSERT INTO siteclasses (id,name,alert_type_up,alert_type_down) VALUES (1, 'Leaf',9,10);
INSERT INTO siteclasses (id,name,alert_type_up,alert_type_down) VALUES (2, 'Branch',9,10);
INSERT INTO siteclasses (id,name,alert_type_up,alert_type_down) VALUES (3, 'Priority',9,10);
INSERT INTO siteclasses (id,name,alert_type_up,alert_type_down) VALUES (4, 'Core',9,10);

INSERT INTO sites (id,name,x,y) VALUES (1,'Test site A',100,100);
INSERT INTO sites (id,name,x,y) VALUES (2,'Test site B',200,100);
INSERT INTO sites (id,name,x,y) VALUES (3,'Test site C',300,100);
INSERT INTO sites (id,name,x,y) VALUES (4,'Test site D',300,200);

INSERT INTO sitegroups (id,name) VALUES (1,'Test sitegroup 1');
INSERT INTO sitegroups (id,name) VALUES (2,'Test sitegroup 2');

INSERT INTO sitegroupmembers (site,sitegroup) VALUES (1,1); 
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (2,1); 
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (3,2); 
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (4,2); 

INSERT INTO hostclasses (id,name,alert_type_up,alert_type_down) VALUES (1, 'Switch',5,6);
INSERT INTO hostclasses (id,name,alert_type_up,alert_type_down) VALUES (2, 'Router',5,6);
INSERT INTO hostclasses (id,name,alert_type_up,alert_type_down) VALUES (3, 'UPS',5,6);
INSERT INTO hostclasses (id,name,alert_type_up,alert_type_down) VALUES (4, 'Server',5,6);
INSERT INTO hostclasses (id,name,alert_type_up,alert_type_down) VALUES (5, 'Sensor',5,6);

INSERT INTO snmp_oids (id,name,oid) VALUES (1,'ifIndex',                    '1.3.6.1.2.1.2.2.1.1');
INSERT INTO snmp_oids (id,name,oid) VALUES (2,'ifType',                     '1.3.6.1.2.1.2.2.1.3');
INSERT INTO snmp_oids (id,name,oid) VALUES (3,'ifName',                     '1.3.6.1.2.1.31.1.1.1.1');      
INSERT INTO snmp_oids (id,name,oid) VALUES (4,'vtpVlanState',               '1.3.6.1.4.1.9.9.46.1.3.1.1.2'); 
INSERT INTO snmp_oids (id,name,oid) VALUES (5,'dot1dTpFdbPort',             '1.3.6.1.2.1.17.4.3.1.2');
INSERT INTO snmp_oids (id,name,oid) VALUES (6,'dot1dBasePortIfIndex',       '1.3.6.1.2.1.17.1.4.1.2');     
INSERT INTO snmp_oids (id,name,oid) VALUES (7,'ifVlan',                     '1.3.6.1.4.1.9.9.68.1.2.2.1.2'); 
INSERT INTO snmp_oids (id,name,oid) VALUES (8,'ifAlias',                    '1.3.6.1.2.1.31.1.1.1.18');   
INSERT INTO snmp_oids (id,name,oid) VALUES (9,'ifHighSpeed',                '1.3.6.1.2.1.31.1.1.1.15');   
INSERT INTO snmp_oids (id,name,oid) VALUES (10,'ifAdminStatus',             '1.3.6.1.2.1.2.2.1.7');   
INSERT INTO snmp_oids (id,name,oid) VALUES (11,'ifOperStatus',              '1.3.6.1.2.1.2.2.1.8');       
INSERT INTO snmp_oids (id,name,oid) VALUES (12,'ipNetToMediaPhysAddress',   '1.3.6.1.2.1.4.22.1.2');       
INSERT INTO snmp_oids (id,name,oid) VALUES (13,'upsBatteryStatus',          '1.3.6.1.2.1.33.1.2.1');
INSERT INTO snmp_oids (id,name,oid) VALUES (14,'upsOutputSource',           '1.3.6.1.2.1.33.1.4.1');
INSERT INTO snmp_oids (id,name,oid) VALUES (15,'upsAlarmsPresent',          '1.3.6.1.2.1.33.1.6.1');
INSERT INTO snmp_oids (id,name,oid) VALUES (16,'upsBasicBatteryStatus',     '1.3.6.1.4.1.318.1.1.1.2.1.1');
INSERT INTO snmp_oids (id,name,oid) VALUES (17,'upsBasicOutputStatus',      '1.3.6.1.4.1.318.1.1.1.4.1.1');
INSERT INTO snmp_oids (id,name,oid) VALUES (18,'upsAdvStateSystemMessages', '1.3.6.1.4.1.318.1.1.1.11.2.6');

INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,1);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,2);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,3);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,4);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,5);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,6);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,7);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,8);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,9);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,10);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,11);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (1,12);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (3,13);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (3,14);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (3,15);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (3,16);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (3,17);
INSERT INTO hostclass_snmp (hostclass,snmp_oid) VALUES (3,18);

INSERT INTO hosts (id,ip,site,name,x,y) VALUES (1,'10.1.1.252',1,'A-01',100,100);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (2,'10.1.1.251',1,'A-02',100,200);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (3,'10.1.1.250',1,'A-03',100,300);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (4,'10.1.1.249',1,'A-04',200,300);

INSERT INTO hostgroups (id,name,site) VALUES (1,'Test hostgroup 1',1);
INSERT INTO hostgroups (id,name,site) VALUES (2,'Test hostgroup 2',1);

INSERT INTO hostgroupmembers (host,hostgroup) VALUES (1,1); 
INSERT INTO hostgroupmembers (host,hostgroup) VALUES (2,1); 
INSERT INTO hostgroupmembers (host,hostgroup) VALUES (3,2); 
INSERT INTO hostgroupmembers (host,hostgroup) VALUES (4,2); 


INSERT INTO hosts (id,ip,site,name,x,y) VALUES (5,'10.1.1.248',2,'B-01',100,200);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (6,'10.1.1.247',2,'B-02',200,200);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (7,'10.1.1.246',3,'C-01',100,200);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (8,'10.1.1.245',3,'C-02',200,200);


INSERT INTO commlinks (host1,host2) VALUES (1,2);
INSERT INTO commlinks (host1,host2) VALUES (1,3);
INSERT INTO commlinks (host1,host2) VALUES (3,4);

INSERT INTO commlinks (host1,host2) VALUES (5,6);

INSERT INTO commlinks (host1,host2) VALUES (7,8);

INSERT INTO commlinks (host1,host2) VALUES (1,5);
INSERT INTO commlinks (host1,host2) VALUES (1,7);

INSERT INTO sites (id,name,x,y) VALUES (5,'RARADH',300,300);
INSERT INTO sitegroups (id,name) VALUES (3,'Ralingen');
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (5,3);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (9,'172.29.0.40',5,'RARADH-FW-02',100,100);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (10,'172.29.9.1',5,'RARADH-GW-01',200,100);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (11,'10.82.10.101',5,'RARADH-SW-01',300,100);
INSERT INTO hosts (id,ip,site,name,x,y) VALUES (12,'10.82.10.30',5,'RARADH-UPS-01',400,100);


INSERT INTO users (username,realm,password,alert,email,sms) VALUES ('andlun','AtlasV@man-monitor-02.oikt.net','73bf3fcd2b3861bde5f8a4999786a12f',1,'andreas.lund@oikt.no','90077162');
INSERT INTO users (username,realm,password,alert,email,sms) VALUES ('andlun','AtlasV@pixie','6005f2fdbc44249f1ca3bc189e64c63e',1,'andreas.lund@oikt.no','90077162');
INSERT INTO users (username,realm,password,alert,email,sms) VALUES ('andlun','AtlasV@ikt-atlas-01.ansatt.oikt.net','9c4eabc2c1d884a0320aaf3f32a685ad',1,'andreas.lund@oikt.no','90077162');

INSERT INTO alert_groups (name,hours_begin,hours_end,weekdays_begin,weekdays_end,email_level,sms_level) VALUES ('Test 24/7','00:00:00','23:59:59',0,6,0,0);

INSERT INTO alert_groupusers (alert_group,user) VALUES (1,1);
INSERT INTO alert_groupusers (alert_group,user) VALUES (1,2);
INSERT INTO alert_groupusers (alert_group,user) VALUES (1,3);
