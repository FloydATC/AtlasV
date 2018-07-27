
# Pre
DELIMITER $$

# Hosts

DROP TRIGGER IF EXISTS host_up_change$$ 
CREATE TRIGGER host_up_change BEFORE UPDATE ON hosts FOR EACH ROW
BEGIN
  IF ((OLD.up = 0 AND NEW.up > 0) OR (OLD.up > 0 AND NEW.up = 0) OR (OLD.up IS NULL AND NEW.up IS NOT NULL)) THEN
    SET NEW.since = NOW();
  END IF;
  IF NEW.up = 0 AND OLD.up > 0 AND NEW.alert = 1 AND new.disabled = 0 THEN
    # Raise alert 
    INSERT INTO alerts (alert_type, object_type, object_id, object_name)
    VALUES ((SELECT id FROM alert_types WHERE name = "HOST DOWN"), 'hosts', NEW.id, NEW.name);

    # Cancel any opposite alerts about this object
    DELETE alerts FROM alerts
    LEFT JOIN alert_types ON (alert_types.id = (SELECT id FROM alert_types WHERE name = "HOST DOWN"))
    WHERE alert_type = alert_types.cancel_id
    AND object_id = NEW.id;
  END IF;
  IF NEW.up > 0 AND OLD.up = 0 AND NEW.alert = 1 AND NEW.disabled = 0 THEN
    # Raise alert
    INSERT INTO alerts (alert_type, object_type, object_id, object_name)
    VALUES ((SELECT id FROM alert_types WHERE name = "HOST UP"), 'hosts', NEW.id, NEW.name);

    # Cancel any opposite alerts about this object
    DELETE alerts FROM alerts
    LEFT JOIN alert_types ON (alert_types.id = (SELECT id FROM alert_types WHERE name = "HOST UP"))
    WHERE alert_type = alert_types.cancel_id
    AND object_id = NEW.id;
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

