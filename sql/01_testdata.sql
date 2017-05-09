
INSERT INTO sites (name,x,y) VALUES ('Test site A',100,100);
INSERT INTO sites (name,x,y) VALUES ('Test site B',200,100);
INSERT INTO sites (name,x,y) VALUES ('Test site C',300,100);
INSERT INTO sites (name,x,y) VALUES ('Test site D',300,200);

INSERT INTO sitegroups (name) VALUES ('Test sitegroup 1');
INSERT INTO sitegroups (name) VALUES ('Test sitegroup 2');

INSERT INTO sitegroupmembers (site,sitegroup) VALUES (1,1); 
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (2,1); 
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (3,2); 
INSERT INTO sitegroupmembers (site,sitegroup) VALUES (4,2); 

INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.252',1,'A-01',100,100);
INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.251',1,'A-02',100,200);
INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.250',1,'A-03',100,300);
INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.249',1,'A-04',200,300);

INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.248',2,'B-01',100,200);
INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.247',2,'B-02',200,200);

INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.246',3,'C-01',100,200);
INSERT INTO hosts (ip,site,name,x,y) VALUES ('10.1.1.245',3,'C-02',200,200);

INSERT INTO commlinks (host1,host2) VALUES (1,2);
INSERT INTO commlinks (host1,host2) VALUES (1,3);
INSERT INTO commlinks (host1,host2) VALUES (3,4);

INSERT INTO commlinks (host1,host2) VALUES (5,6);

INSERT INTO commlinks (host1,host2) VALUES (7,8);

INSERT INTO commlinks (host1,host2) VALUES (1,5);
INSERT INTO commlinks (host1,host2) VALUES (1,7);

INSERT INTO users (username,realm,password) VALUES ('andlun','AtlasV@man-monitor-02.oikt.net','73bf3fcd2b3861bde5f8a4999786a12f');
