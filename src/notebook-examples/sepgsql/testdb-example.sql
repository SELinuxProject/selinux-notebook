/*
 * This is the example for the SELinux Notebook.
 *
 * From psql prompt run this to build the database by:
 * 		\i testdb-example.sql
*/

/* These show the sepgsql postgresql.conf entries, normally not set */
SHOW sepgsql.permissive;
SHOW sepgsql.debug_audit;

SELECT sepgsql_getcon();
--- If mcstransd running and the sample setrans.conf installed then show translated info
SELECT sepgsql_mcstrans_out((SELECT sepgsql_getcon()));

CREATE SCHEMA test_ns;
CREATE TABLE test_ns.info (user_name CHAR(10), email_addr CHAR(20));

--- This sets the security labels:
SECURITY LABEL ON SCHEMA test_ns IS 'unconfined_u:object_r:sepgsql_schema_t:s0:c10';
SECURITY LABEL ON TABLE test_ns.info IS 'unconfined_u:object_r:sepgsql_table_t:s0:c20';
SECURITY LABEL ON COLUMN test_ns.info.user_name IS 'unconfined_u:object_r:sepgsql_table_t:s0:c30';
SECURITY LABEL ON COLUMN test_ns.info.email_addr IS 'unconfined_u:object_r:sepgsql_table_t:s0:c40';

--- Note: No support for row labeling
INSERT INTO test_ns.info (user_name, email_addr) VALUES ('fred', 'fred@yahoo.com');
INSERT INTO test_ns.info (user_name, email_addr) VALUES ('derf', 'derf@hotmail.com');
INSERT INTO test_ns.info (user_name, email_addr) VALUES ('george', 'george@hotmail.com');
INSERT INTO test_ns.info (user_name, email_addr) VALUES ('jane', 'jane@yahoo.com');

--- Show the columns
SELECT user_name, email_addr FROM test_ns.info;

--- This shows the testdb internal database entries using the pg_seclabels view
SELECT objtype, objname, label FROM pg_seclabels WHERE provider = 'selinux' AND  objtype in ('schema', 'table', 'column') AND objname in ('testdb', 'test_ns', 'test_ns.info', 'test_ns.info.user_name', 'test_ns.info.email_addr');

--- Shows labels on user_name and email_addr columns
SELECT user_name, label FROM pg_seclabels, test_ns.info WHERE provider = 'selinux' AND objname in ('test_ns.info.user_name');
SELECT email_addr, label FROM pg_seclabels, test_ns.info WHERE provider = 'selinux' AND objname in ('test_ns.info.email_addr');
