
# Pre
DELIMITER $$

# Hosts

DROP TRIGGER IF EXISTS host_up_change$$ 
CREATE TRIGGER host_up_change BEFORE UPDATE ON hosts FOR EACH ROW
BEGIN
  IF OLD.up <> NEW.up THEN
    SET NEW.since = NOW();
  END IF;
END$$



# Hostgroups

DROP TRIGGER IF EXISTS hostgroup_up_change$$ 
CREATE TRIGGER hostgroup_up_change BEFORE UPDATE ON hostgroups FOR EACH ROW
BEGIN
  IF OLD.up <> NEW.up THEN
    SET NEW.since = NOW();
  END IF;
END$$



# Sites

DROP TRIGGER IF EXISTS site_up_change$$ 
CREATE TRIGGER site_up_change BEFORE UPDATE ON sites FOR EACH ROW
BEGIN
  IF OLD.up <> NEW.up THEN
    SET NEW.since = NOW();
  END IF;
END$$



# Sitegroups

DROP TRIGGER IF EXISTS sitegroup_up_change$$ 
CREATE TRIGGER sitegroup_up_change BEFORE UPDATE ON sitegroups FOR EACH ROW
BEGIN
  IF OLD.up <> NEW.up THEN
    SET NEW.since = NOW();
  END IF;
END$$



# Commlinks

DROP TRIGGER IF EXISTS commlink_up_change$$ 
CREATE TRIGGER commlink_up_change BEFORE UPDATE ON commlinks FOR EACH ROW
BEGIN
  IF OLD.up <> NEW.up THEN
    SET NEW.since = NOW();
  END IF;
END$$



# Interfaces

DROP TRIGGER IF EXISTS port_up_change$$ 
CREATE TRIGGER port_up_change BEFORE UPDATE ON ports FOR EACH ROW
BEGIN
  IF OLD.up <> NEW.up THEN
    SET NEW.since = NOW();
  END IF;
END$$



# Post
DELIMITER ;

