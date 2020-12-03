# SE-PostgreSQL Demo

This README describes the instructions to build the initial testdb database
that is used to test SE-PostgreSQL functionality.

All tests have been carried out on Fedora 31 with the targeted policy
using PostgreSQL server 11.7.

The testdb-example.sql script is used to build the db.

The Notebook SE-PostgreSQL demo requires the following packages to be
installed:

```
	postgresql
	postgresql-libs
	postgresql-server
	postgresql-contrib # This contains the sepgsql SELinux object manager
	postgresql-devel
	postgresql-docs
```

## Installing PostgreSQL + sepgsql and building sample testdb database

For a good intro to sepgsql read the following:
[*/usr/share/doc/postgresql-docs/html/sepgsql.html*](/usr/share/doc/postgresql-docs/html/sepgsql.html)
that should be installed with postgresql package. This also has instructions on
how to initialise sepgsql and label the database. The instructions below
have been extracted and modified to suit the demo.

The following assumes the packages are installed and this is a first
installation. Ensure SELinux is in permissive mode, otherwise various
error are shown. Once installation is complete, enforcement mode can be ON.

Note that the targeted policy will have installed the `postgresql` policy
module.

Must be set to permissive mode for setup - Probably because initially
database is set to 'unlabled'

1. `setenforce 0`

2. As root initialise PostgreSQL:

	`postgresql-setup --initdb --unit postgresql`

	If an error states that the 'Data directory is not empty!' then you
	have already built a database service (*/var/lib/pgsql/data* exists).

3. To use the SELinux sepgsql extension module, the *postgresql.conf* file
   needs to be updated as follows:

	`vi /var/lib/pgsql/data/postgresql.conf`

	and change the:

		#shared_preload_libraries = ''

	entry to read:

		shared_preload_libraries = 'sepgsql'

4. Start the PostgreSQL database by:

	`service postgresql start`

5. su to the postgres user and create roles for any database users giving
   them superuser rights:

```
	su - postgres
	createuser root
	createuser ....
```

6. Create the testdb database:

	`createdb --owner=root testdb`

7. Now Crtl\D to exit the postgres user and as root stop the db:

	`service postgresql stop`

8. The database now needs to be initialised to support labeling. This
   involves running an SQL script that is supplied in the
   postgresql-contrib package:

	`su - postgres`

   paste the following in to the terminal session:


```
for testdb in template0 template1 postgres; do
postgres --single -F -c exit_on_error=true testdb \
</usr/share/pgsql/contrib/sepgsql.sql
done
```

   The */usr/share/pgsql/contrib/sepgsql.sql* script adds sepgsql functions
   and then runs sepgsql_restorecon(NULL); to label the database objects.

9. Now Crtl\D to exit the postgres user and as root start the db:

	`service postgresql start`

10. Now run psql from one of the superusers that were created by 'createuser'
    and build the testdb database as follows:

```
	psql -d testdb -U root
	\i /path/to/notebook-examples/sepgsql/testdb-example.sql
```

   As the data and security labels are assigned to the database, various
   information is displayed. The labels assigned are:

```
	Schema  - test_ns    unconfined_u:object_r:sepgsql_schema_t:s0:c10
	Table   - info       unconfined_u:object_r:sepgsql_table_t:s0:c20
	Column1 - user_name  unconfined_u:object_r:sepgsql_table_t:s0:c30
	Column2 - email_addr unconfined_u:object_r:sepgsql_table_t:s0:c40
```

11. Now Crtl\D to exit psql and `setenforce 1`. ***runcon**(1)* will now be used
    to start local psql sessions to display various testdb columns.

	Display both columns:

		runcon -l s0-s0:c10,c20,c30,c40 -t unconfined_t psql testdb
		SELECT user_name, email_addr FROM test_ns.info;

	Display only the `user_name` column:

		Crtl\D to exit psql
		runcon -l s0-s0:c10,c20,c30 -t unconfined_t psql testdb

		SELECT user_name, email_addr FROM test_ns.info;
		ERROR:  SELinux: security policy violation - As not allowed access to email_addr

	Display only the `email_addr` column:

		Crtl\D to exit psql
		runcon -l s0-s0:c10,c20,c40 -t unconfined_t psql testdb

		SELECT user_name, email_addr FROM test_ns.info;
		ERROR:  SELinux: security policy violation - As not allowed access to user_name


Full examples are:
	Crtl\D to exit psql
```
	runcon -l s0-s0:c10,c20,c30,c40 -t unconfined_t psql testdb

testdb=# SELECT sepgsql_getcon();
                        sepgsql_getcon
--------------------------------------------------------------
 unconfined_u:unconfined_r:unconfined_t:s0-s0:c10,c20,c30,c40
(1 row)

testdb=# SELECT user_name, label FROM pg_seclabels, test_ns.info WHERE provider = 'selinux' AND objname in ('test_ns.info.user_name');

 user_name  |                    label
------------+----------------------------------------------
 fred       | unconfined_u:object_r:sepgsql_table_t:s0:c30
 derf       | unconfined_u:object_r:sepgsql_table_t:s0:c30
 george     | unconfined_u:object_r:sepgsql_table_t:s0:c30
 jane       | unconfined_u:object_r:sepgsql_table_t:s0:c30
(4 rows)

testdb=# SELECT email_addr, label FROM pg_seclabels, test_ns.info WHERE provider = 'selinux' AND objname in ('test_ns.info.email_addr');

      email_addr      |                    label
----------------------+----------------------------------------------
 fred@yahoo.com       | unconfined_u:object_r:sepgsql_table_t:s0:c40
 derf@hotmail.com     | unconfined_u:object_r:sepgsql_table_t:s0:c40
 george@hotmail.com   | unconfined_u:object_r:sepgsql_table_t:s0:c40
 jane@yahoo.com       | unconfined_u:object_r:sepgsql_table_t:s0:c40
(4 rows)
```
