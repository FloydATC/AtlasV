
tables:
	mysql -f atlas5 < sql/00_schema.sql
	
testdata:
	mysql -f atlas5 < sql/01_testdata.sql

stored_procedures:
	mysql -f atlas5 < sql/02_stored_procedures.sql

triggers:
	mysql -f atlas5 < sql/03_triggers.sql

clean:
	find -name "*~" -delete
