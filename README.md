KySQL - Kynetx MySQL Module
===========================

The KySQL module provides a MySQL query function `KyQuery()` function to remote database servers within a Kynetx Ruleset. In addtion there are a couple of helper functions to retrieve the query results in JSON format, access request status and simpilify the process of writing database insert statements.

Functions
---------

### KySQL:KyQuery();

To submit a query, use the following function:

    KySQL:KyQuery('YOUR QUERY HERE');

The `KyQuery()` function returns a database result object when "read" type queries are run, which you can use to show your results. When "write" type queries are run it simply returns TRUE or FALSE depending on success or failure. When retrieving data you will typically assign the query to your own variable, like this:

    KyObject = KySQL:KyQuery('YOUR QUERY HERE');

### KySQL:KyResult();

This function returns the query result as a JSON object:

    KyJSON = KySQL:KyResult(KyObject);

For example:

    KyObject = KySQL:KyQuery('SELECT * FROM addressbook');
    KyJSON = KySQL:KyResult(KyObject);

Returns the following JSON object:

    {
        'results': [
            {
                'uid': 1,
                'name': 'Ed Orcutt'
                'email': 'edo@foo.org',
            },
            {
                'uid': 2,
                'name': 'LauraOrcutt'
                'email': 'laura@example.org',
            }
        ]
    }

### KySQL:KyRowCount();

This function returns the number of rows from a result set:

    Status = KySQL:KyRowCount(KyObject);

This function is only valid for SELECT statement that returns an actual result set.

### KySQL:KyStatus();

This function returns the status code from the query:

    Status = KySQL:KyStatus(KyObject);

### KySQL:KyError();

This function returns the MySQL error message when a status code of 503 is returned by the query:

    Message = KySQL:KyError(KyObject);

Here is a sample error message would be of the following form:

    Access denied for user 'foobar'@'localhost'(using password:YES)

### KySQL:KyInsertString();

This function simplifies the process of writing database inserts. It returns a corretly formatted SQL insert string. Example:

    kyData = {
      "name"  : "Ed Orcutt",
      "email" : "edo@example.org",
      "phone" : "(801) 555-1234"
    };
    
    kyInsert = KyInsertString("addressbook", kyData);

The first parameter is the table name, the second is a hash with the to be inserted. The above example produces:

    INSERT INTO neubook ('email','name','phone') VALUES ('edo@example.org','Ed Orcutt','(801) 555-1234')

Installation
------------

In order for KySQL to access your database server the PHP file `KySQL.php` will need to be placed on a publicly available web server which has access to the database. The default configuration assumes that the database server is available via `localhost`. However, you should be able to access a remote database server host by changing `$dbhost` to the hostname of the database server.

Before placing `KySQL.php` on your web server you will need to set the API key: `$THEKEY`. The value should be unique to each instance in order to provide security. The API key will be needed when configuring the KRL module as well.

Usage
-----

There are two approaches which you can take to use the Kynetx KySQL module. The simplist approach is to use the public module that has been released here. The second approach is to create your own module using the KRL source provided in this repository. The second approach will be left as a excerise for the reader.

To use the public module start with the `Hello-KySQL.krl` source code. Replace `apikey` with the exact value you used for `$THEKEY` in the file `KySQL.php`. Next, set `callback` to the full public URL for `KySQL.php` what you placed on your public web server. Finally, set `username`, `password` and `database` to the credentials of your database server.
