
tables:
	mysql -f atlas5 < sql/00_schema.sql
	
testdata:
	mysql -f atlas5 < sql/01_testdata.sql

clean:
	find -name "*~" -delete
